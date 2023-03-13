using System.Collections.Generic;
using Ix.Base.Data;
using ix.framework.data;

namespace Pocos.ix.framework.data
{
    public partial class DataEntity : IBrowsableDataObject, IDataEntity
    {
        public dynamic _recordId { get; set; }

        List<ValueChangeItem> changes = new List<ValueChangeItem>();
        public List<ValueChangeItem> Changes
        {
            get
            {
                return changes;
            }
            set
            {
                changes = value;
            }
        }
    }

}
