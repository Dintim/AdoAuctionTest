﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdoAuctionTest.Exceptions
{
    public class ApplicationException:Exception
    {
        public ApplicationException(string exceptionIfno) : base(exceptionIfno)
        {

        }
    }
}
