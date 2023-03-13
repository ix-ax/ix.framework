using Ix.Base.Data;
using Raven.Client.Documents;

namespace Ix.Framework.RavenDb
{
    public class RavenDbRepositorySettingsBase<T> : RepositorySettings where T : IBrowsableDataObject
    {
        public IDocumentStore Store { get; set; }
    }
}
