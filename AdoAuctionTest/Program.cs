using AdoAuctionTest.Services;
using AdoAuctionTest.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdoAuctionTest
{
    class Program
    {
        static void Main(string[] args)
        {
            //OpenOrganizationViewModel viewModel = new OpenOrganizationViewModel()
            //{
            //    OrganizationFullName="KEGOC",
            //    OrganizationIdentificationNumber="159753456",
            //    OrganizationTypeId= "87081655-D350-45C7-A6C5-8A51EDE383AF",
            //    CeoFirstName="Руслан",
            //    CeoLastName="Русланов",
            //    CeoMiddleName="Русланович",
            //    Email="ddd@mail.ru",
            //    DoB=new DateTime(1985,5,16),
            //    Password="qwerty",
            //    PasswordConfirmation= "qwerty"
            //};
            ChangeUserPasswordViewModel viewModel = new ChangeUserPasswordViewModel()
            {
                Email = "ddd@mail.ru",
                oldPassword = "qwerty",
                newPassword = "qwerty123",
                newPasswordConfirmation = "qwerty123"
            };
            AccountService s = new AccountService();
            //s.OpenOrganization(viewModel);
            s.ChangeUserPassword(viewModel);


            //Console.WriteLine(s.GetGeolocationInfo().ip.ToString());
        }
    }
}
