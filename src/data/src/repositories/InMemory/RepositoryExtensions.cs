using Ix.Base.Data;
using Ix.Framework.Data;

namespace Ix.Framework.Data.InMemory
{
    public static class Repository
    {
        public static IRepository<T> Factory<T>(this InMemoryRepositorySettings<T> parameters) where T : IBrowsableDataObject
        {
            return new InMemoryRepository<T>(parameters);
        }
    }
}
