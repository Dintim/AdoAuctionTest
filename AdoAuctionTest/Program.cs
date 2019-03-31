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
            AccountService service = new AccountService();
            //Console.WriteLine(service.AutorizationSecurity("93293056-DF3A-4CF5-89B7-FD4332C560AE").ToShortDateString());
            //int cnt = 5;
            //service.AutorizationSecurity("93293056-DF3A-4CF5-89B7-FD4332C560AE", out cnt);
            //Console.WriteLine(cnt);

            string userId = "93293056-DF3A-4CF5-89B7-FD4332C560AE";
            string userPhone = "+777777777777";
            string message = "";
            service.AutorizationSecurity(userId, userPhone, out message);


        }
    }
}
