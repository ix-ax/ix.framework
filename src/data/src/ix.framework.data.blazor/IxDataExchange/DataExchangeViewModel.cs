using ix.ax.core.blazor;
using ix.framework.core.Interfaces;
using ix.framework.core.ViewModels;
using ix.framework.data;
using Ix.Presentation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace ix.framework.data
{
    public class DataExchangeViewModel : RenderableViewModelBase
    {



        public IDataViewModel DataViewModel
        {
            get;
            private set;
        }
        public override object Model
        {
            get => this.DataViewModel.DataExchange;
            set
            {
                CreateBrowsable((DataExchange)value);
            }
        }


        private void CreateBrowsable(DataExchange dataExchangeObject)
        {
            try
            {
                var DataPropertyInfo = dataExchangeObject.GetType().GetProperty("_data");

                if (DataPropertyInfo == null)
                {
                    DataPropertyInfo = dataExchangeObject.GetType().GetProperty("_data", BindingFlags.NonPublic);
                }


                if (DataPropertyInfo == null)
                {
                    DataPropertyInfo = dataExchangeObject.GetType().GetProperty("_data", BindingFlags.NonPublic | BindingFlags.Instance);
                }

                if (DataPropertyInfo == null)
                {
                    throw new Exception($"{dataExchangeObject.GetType().ToString()} must implement member '_data' that inherits from {nameof(DataEntity)}.");
                }


                var dataOfType = DataPropertyInfo.PropertyType.Name;
                var dataNameSpace = DataPropertyInfo.PropertyType.Namespace;
                var dataAssembly = DataPropertyInfo.PropertyType.Assembly.ManifestModule.Name;
                if (dataAssembly.LastIndexOf(".") >= 0)
                    dataAssembly = dataAssembly.Substring(0, dataAssembly.LastIndexOf("."));


                MethodInfo method = typeof(IxDataViewModel).GetMethod("Create");
                var genericTypeName = $"Pocos.{dataNameSpace}.{dataOfType}, {dataAssembly}";
                var genericType = Type.GetType(genericTypeName);

                if (genericType == null)
                {
                    throw new Exception($"Could not retrieve {genericTypeName} when creating browsable object.");
                }

                MethodInfo generic = method.MakeGenericMethod(genericType);
                DataViewModel = (IDataViewModel)generic.Invoke(null, new object[] { dataExchangeObject.GetRepository(), dataExchangeObject });

            }
            catch
            {
                throw;//new BrowsableObjectCreationException("Unable to create browsable object for the view. For details see inner exception.", ex);
            }

        }
    }
}
