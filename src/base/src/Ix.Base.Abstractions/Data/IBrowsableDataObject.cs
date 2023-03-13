using System;

namespace Ix.Base.Data
{
    public interface IBrowsableDataObject
    {
        dynamic _recordId { get; set; }
      
        string DataEntityId { get; set; }        
    }
}