﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdoAuctionTest.ViewModels
{
    public class OpenOrganizationViewModel
    {
        public string OrganizationFullName { get; set; }
        public string OrganizationIdentificationNumber { get; set; }
        public string OrganizationTypeId { get; set; }
        public string CeoFirstName { get; set; }
        public string CeoLastName { get; set; }
        public string CeoMiddleName { get; set; }
        public string Email { get; set; }
        public DateTime DoB { get; set; }
        public string Password { get; set; }
        public string PasswordConfirmation { get; set; }
    }
}
