using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Ix.Connector;

namespace ix.framework.data
{
    public static class DataOnlinerExtensions
    {
        public static async Task<object> PlainToShadowAsync(this ICrudDataObject twin, object plain)
        {
            return await ((dynamic)twin).PlainToShadowAsync(plain);
        }

        public static async Task<object> ShadowToPlainAsync(this ICrudDataObject twin, object plain)
        {
            return await ((dynamic)twin).PlainToShadowAsync(plain);
        }


        public static async Task<object> OnlineToPlainAsync(this ICrudDataObject twin)
        {
            return await ((dynamic)twin).OnlineToPlainAsync();
        }

        public static async Task<object> PlainToOnlineAsync(this ICrudDataObject twin, object plain)
        {
            return await ((dynamic)twin).PlainToOnlineAsync((dynamic)plain);
        }


        public static object CreateEmptyPoco(this ICrudDataObject twin)
        {
            return ((dynamic)twin).CreateEmptyPoco();
        }
    }
}
