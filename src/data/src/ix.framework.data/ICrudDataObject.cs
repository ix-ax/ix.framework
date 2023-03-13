using System.Collections.Generic;
using Ix.Connector;
using Ix.Connector.ValueTypes;

namespace ix.framework.data
{
    public interface ICrudDataObject 
    {       
        OnlinerString DataEntityId { get; }        
        ValueChangeTracker ChangeTracker { get; }
        List<ValueChangeItem> Changes { get; set; }
    }
}
