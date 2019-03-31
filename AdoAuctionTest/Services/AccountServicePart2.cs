using AdoAuctionTest.Extensions;
using AdoAuctionTest.ExternalModels;
using AdoAuctionTest.Models;
using AdoAuctionTest.ViewModels;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Device.Location;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Twilio;
using Twilio.Rest.Api.V2010.Account;

namespace AdoAuctionTest.Services
{
    public partial class AccountService
    {
        public bool IsEmailPasswordValid(LogOnViewModel viewModel, out string messageOrId)
        {
            viewModel.GeoLocation = GetGeolocationInfo();

            DataSet identityDataSet = new DataSet();
            string usersTable = "[dbo].[ApplicationUsers]";
            string userPasswordTable = "[dbo].[ApplicationUserPasswordHistories]";
            string userSignInTable = "[dbo].[ApplicationUserSignInHistories]";
            string userId = string.Empty;

            using (SqlConnection connection=new SqlConnection(ConfigurationManager.ConnectionStrings["IdentityDbConnectionString"].ConnectionString))
            {
                connection.Open();
                
                string selectByEmail = $"select * from {usersTable} where [Email]='{viewModel.Email}'";

                using (SqlDataAdapter adapter=new SqlDataAdapter(selectByEmail, connection))
                {
                    //проверяем, есть ли емейл в базе
                    SqlCommandBuilder commandBuilder = new SqlCommandBuilder(adapter);
                    adapter.Fill(identityDataSet);
                    if (identityDataSet.Tables[0].Rows.Count == 0)
                    {
                        messageOrId = $"There is no email in database like {viewModel.Email}";
                        return false;
                    }

                    userId = identityDataSet.Tables[0].Rows[0]["Id"].ToString();

                    //проверяем, подходит ли пароль емейлу
                    identityDataSet.Clear();
                    string selectByEmailAndPassword = $"select * from {usersTable} u, {userPasswordTable} p " +
                    $"where u.[Id]=p.[ApplicationUserId] " +
                    $"and u.[Email]='{viewModel.Email}' and p.[PasswordHash]= '{viewModel.Password}' and p.[InvalidatedDate] is null";
                    adapter.SelectCommand = new SqlCommand(selectByEmailAndPassword, connection);
                    commandBuilder = new SqlCommandBuilder(adapter);

                    adapter.Fill(identityDataSet);
                    if (identityDataSet.Tables[0].Rows.Count == 0)
                    {
                        DataSet tmp = new DataSet();                        
                        adapter.SelectCommand = new SqlCommand(selectByEmail, connection);
                        commandBuilder = new SqlCommandBuilder(adapter);

                        adapter.Fill(tmp);
                        DataTable table = tmp.Tables[0];
                        int cnt = 0;
                        Int32.TryParse(table.Rows[0]["FailedSignInCount"].ToString(), out cnt);
                        table.Rows[0]["FailedSignInCount"] = cnt + 1;
                        adapter.Update(tmp);

                        messageOrId = "Invalid password, try again";
                        return false;                        
                    }

                    //добавляем строку нового входа в таблице ApplicationUserSignInHistories в БД
                    identityDataSet.Clear();
                    ApplicationUserSignInHistories userSignIn = new ApplicationUserSignInHistories()
                    {
                        Id = Guid.NewGuid().ToString(),
                        ApplicationUserId = userId,
                        SignInTime = DateTime.Now.ToString("yyyy-MM-dd"),
                        MachineIp = viewModel.GeoLocation.ip,
                        IpToGeoCountryCode = viewModel.GeoLocation.country_name,
                        IpToGeoCityName = viewModel.GeoLocation.city,
                        IpToGeoLatitude = viewModel.GeoLocation.latitude,
                        IpToGeoLongitude = viewModel.GeoLocation.longitude
                    };

                    string userSignInSql = $"select * from {userSignInTable}";
                    adapter.SelectCommand = new SqlCommand(userSignInSql, connection);
                    commandBuilder = new SqlCommandBuilder(adapter);

                    adapter.Fill(identityDataSet);
                    DataRow dataRow = identityDataSet.Tables[0].NewRowWithData(userSignIn);
                    identityDataSet.Tables[0].Rows.Add(dataRow);
                    adapter.Update(identityDataSet);

                }
            }

            messageOrId = userId;
            return true;
        }

        public bool AutorizationSecurity(string userId, string userPhone, out string message)
        {
            DataSet identityDataSet = new DataSet();
            
            string userPasswordTable = "[dbo].[ApplicationUserPasswordHistories]";
            string userSignInTable = "[dbo].[ApplicationUserSignInHistories]";

            DateTime setupDate = new DateTime();            

            using (SqlConnection connection=new SqlConnection(ConfigurationManager.ConnectionStrings["IdentityDbConnectionString"].ConnectionString))
            {
                connection.Open();

                string selectByIdAndInvalidatedDate = $"select * from {userPasswordTable}  " +
                    $"where [ApplicationUserId] = '{userId}' and [InvalidatedDate] is null";
                using (SqlDataAdapter adapter=new SqlDataAdapter(selectByIdAndInvalidatedDate, connection))
                {
                    //проверяем, не заблокирован ли аккаунт пользователя
                    SqlCommandBuilder commandBuilder = new SqlCommandBuilder(adapter);
                    adapter.Fill(identityDataSet);
                    if (identityDataSet.Tables[0].Rows.Count == 0)
                    {
                        message= "Account is blocked",
                        return false;
                    }
                        //throw new ApplicationException("Account is blocked");
                    
                    setupDate = Convert.ToDateTime(identityDataSet.Tables[0].Rows[0]["SetupDate"].ToString());


                    //2FA с отправкой СМС
                    identityDataSet.Clear();
                    string selectByIdAndCurrDate = $"select * from {userSignInTable} " +
                        $"where [ApplicationUserId] = '{userId}' and [SignInTime] = '{DateTime.Now.ToShortDateString()}'";
                    adapter.SelectCommand = new SqlCommand(selectByIdAndCurrDate, connection);
                    commandBuilder = new SqlCommandBuilder(adapter);
                    adapter.Fill(identityDataSet);

                    double currentLatitude = Convert.ToDouble(identityDataSet.Tables[0].Rows[0]["IpToGeoLatitude"].ToString());
                    double currentLongitude = Convert.ToDouble(identityDataSet.Tables[0].Rows[0]["IpToGeoLongitude"].ToString());                    
                    GeoCoordinate currentCoordinate = new GeoCoordinate(currentLatitude, currentLongitude);


                    identityDataSet.Clear();
                    string selectPreviousSignIn = $"select * from {userSignInTable}  " +
                        $"where [ApplicationUserId] = '{userId}' and [SignInTime] < '{DateTime.Now.ToShortDateString()}' order by [SignInTime] desc";
                    adapter.SelectCommand = new SqlCommand(selectPreviousSignIn, connection);
                    commandBuilder = new SqlCommandBuilder(adapter);
                    adapter.Fill(identityDataSet);
                    int cnt = 0;
                    if (identityDataSet.Tables[0].Rows.Count < 5)
                        cnt = identityDataSet.Tables[0].Rows.Count;
                    else if (identityDataSet.Tables[0].Rows.Count >= 5)
                        cnt = 5;
                    
                    for (int i = 0; i < cnt; i++)
                    {
                        double latitude = Convert.ToDouble(identityDataSet.Tables[0].Rows[i]["IpToGeoLatitude"].ToString());
                        double longitude = Convert.ToDouble(identityDataSet.Tables[0].Rows[i]["IpToGeoLongitude"].ToString());
                        GeoCoordinate tmp = new GeoCoordinate(latitude, longitude);

                        if (currentCoordinate.GetDistanceTo(tmp) / 1000 > 2000)
                        {
                            if (!CheckUserViaSms(userPhone))
                            {
                                message = "This is not your account!";
                                return false;
                            }
                                //throw new ApplicationException("This is not your account!");

                            break;
                        }
                    }


                    //считаем кол-во успешных авторизаций с момента последней смены пароля
                    identityDataSet.Clear();
                    string selectSignInHistory = $"select * from {userSignInTable} " +
                        $"where [ApplicationUserId] = '{userId}' and [SignInTime]>='{setupDate.ToShortDateString()}'";
                    adapter.SelectCommand = new SqlCommand(selectSignInHistory, connection);
                    commandBuilder = new SqlCommandBuilder(adapter);
                    adapter.Fill(identityDataSet);
                    if (identityDataSet.Tables[0].Rows.Count > 50)
                    {
                        message = "User has to change password";
                        return false;
                    }
                        //throw new ApplicationException("User has to change password");                    

                }
            }

            message = "";
            return true;
            
        }

        public void CeoAccountService(string userId)
        {
            DataSet applicationDataSet = new DataSet();
            
        }


        public bool CheckUserViaSms(string userPhone)
        {
            const string accountSid = "ACc707a32f2606933b91eea16095ac5924";
            const string authToken = "e60854654efd3a2e798455493970be9d";
            Random rnd = new Random();
            int smsCode = rnd.Next(1000, 9999);

            TwilioClient.Init(accountSid, authToken);

            var message = MessageResource.Create(
                body: $"Enter this code {smsCode}",
                from: new Twilio.Types.PhoneNumber("+12024997374"),
                to: new Twilio.Types.PhoneNumber(userPhone)
            );

            Console.Write("Enter your code: ");
            int userCode = Int32.Parse(Console.ReadLine());
            return smsCode == userCode;
        }
    }
}
