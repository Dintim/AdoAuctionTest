using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdoAuctionTest.Services
{
    public partial class AccountService
    {
        public bool IsEmailPasswordValid(string email, string password, out string messageOrId)
        {
            DataSet identityDataSet = new DataSet();

            string usersTable = "[dbo].[ApplicationUsers]";
            string userPasswordTable = "[dbo].[ApplicationUserPasswordHistories]";
            string userId = string.Empty;

            using (SqlConnection connection=new SqlConnection(ConfigurationManager.ConnectionStrings["IdentityDbConnectionString"].ConnectionString))
            {
                connection.Open();
                
                string selectByEmail = $"select * from {usersTable} where [Email]='{email}'";

                using (SqlDataAdapter adapter=new SqlDataAdapter(selectByEmail, connection))
                {
                    SqlCommandBuilder commandBuilder = new SqlCommandBuilder(adapter);
                    adapter.Fill(identityDataSet);
                    if (identityDataSet.Tables[0].Rows.Count == 0)
                    {
                        messageOrId = $"There is no email in database like {email}";
                        return false;
                    }

                    userId = identityDataSet.Tables[0].Rows[0]["Id"].ToString();

                    identityDataSet.Clear();
                    string selectByEmailAndPassword = $"select * from {usersTable} u, {userPasswordTable} p " +
                    $"where u.[Id]=p.[ApplicationUserId] " +
                    $"and u.[Email]='{email}' and p.[PasswordHash]= '{password}' and p.[InvalidatedDate] is null";
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
                }
            }

            messageOrId = userId;
            return true;
        }

        public void AutorizationSecurity(string userId)
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
                    SqlCommandBuilder commandBuilder = new SqlCommandBuilder(adapter);
                    adapter.Fill(identityDataSet);
                    if (identityDataSet.Tables[0].Rows.Count == 0)                        
                        throw new ApplicationException("Account is blocked");

                    //считаем кол-во успешных авторизаций с момента последней смены пароля
                    setupDate = Convert.ToDateTime(identityDataSet.Tables[0].Rows[0]["SetupDate"].ToString());

                    identityDataSet.Clear();
                    string selectSignInHistory = $"select * from {userSignInTable} " +
                        $"where [ApplicationUserId] = '{userId}' and [SignInTime]>='{setupDate.ToShortDateString()}'";
                    adapter.SelectCommand = new SqlCommand(selectSignInHistory, connection);
                    commandBuilder = new SqlCommandBuilder(adapter);
                    adapter.Fill(identityDataSet);
                    if (identityDataSet.Tables[0].Rows.Count > 50)
                        throw new ApplicationException("User has to change password");



                }
            }

            
        }
    }
}
