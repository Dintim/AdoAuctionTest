using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdoAuctionTest.Extensions
{
    public static class StringExtensions
    {
        public static bool IsValidEmail(this string email)
        {
            return email.Contains("@");
        }
    }
}
