﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdoAuctionTest.Models
{
    public class ApplicationUserPasswordHistories
    {
        public string Id { get; set; }
        public string ApplicationUserId { get; set; }
        public string SetupDate { get; set; }
        public string InvalidatedDate { get; set; }
        public string PasswordHash { get; set; }
    }
}
