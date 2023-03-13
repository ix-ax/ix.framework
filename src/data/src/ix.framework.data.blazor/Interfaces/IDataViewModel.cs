using ix.framework.core.ViewModels;
using ix.framework.data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ix.framework.core.Interfaces
{
    public interface IDataViewModel
    {
        DataExchange DataExchange { get; }
        List<Ix.Base.Data.IBrowsableDataObject> ObservableRecords { get; }

        void CreateNew();
    }
}
