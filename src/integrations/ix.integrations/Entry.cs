using Ix.Connector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Ix.Connector.S71500.WebApi;

namespace intergrations
{
    public static class Entry
    {

        public static integrationsTwinController Plc { get; }
            = new(ConnectorAdapterBuilder.Build()
                .CreateWebApi(System.Environment.GetEnvironmentVariable("AXTARGET"), "Everybody", "", true));

        //public static integrationsTwinController Plc { get; }
        //    = new(ConnectorAdapterBuilder.Build()
        //        .CreateDummy());
    }
}
