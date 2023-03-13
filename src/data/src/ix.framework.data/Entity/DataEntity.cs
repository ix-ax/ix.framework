using System.Collections.Generic;
using Ix.Connector;
using ix.framework.data;

namespace ix.framework.data
{
    public partial class DataEntity : ICrudDataObject
    {
        public ValueChangeTracker ChangeTracker { get; private set; }

        partial void PostConstruct(ITwinObject parent, string readableTail, string symbolTail)
        {
            ChangeTracker = new ValueChangeTracker(this);
        }


        public List<ValueChangeItem> Changes { get; set; }
    }

}
