using System.Timers;

namespace ix.framework.core.blazor.Toaster
{
    public class ToastService : IDisposable
    {
        private List<Toast> ToastsList { get; set; } = new List<Toast>();
        private System.Timers.Timer Timer = new System.Timers.Timer();

        public event EventHandler? ToasterChanged;

        public ToastService()
        {
            Timer.Interval = 1000;
            Timer.AutoReset = true;
            Timer.Elapsed += TimerElapsed;
            Timer.Start();
        }

        public void AddToast(string type, string title, string message, int time)
        {
            ToastsList.Add(new Toast(type, title, message, DateTimeOffset.Now.AddSeconds(time)));
            ToasterChanged?.Invoke(this, EventArgs.Empty);
        }

        public List<Toast> GetToasts()
        {
            ClearBurntToast();
            return ToastsList;
        }

        public void RemoveToast(Toast toast)
        {
            ToastsList.Remove(toast);
            ToasterChanged?.Invoke(this, EventArgs.Empty);
        }

        private void ClearBurntToast()
        {
            var toastsToDelete = ToastsList.Where(item => item.TimeToBurn < DateTimeOffset.Now).ToList();
            if (toastsToDelete != null && toastsToDelete.Count > 0)
            {
                toastsToDelete.ForEach(toast => ToastsList.Remove(toast));
                ToasterChanged?.Invoke(this, EventArgs.Empty);
            }
        }

        private void TimerElapsed(object? sender, ElapsedEventArgs e)
        {
            ClearBurntToast();
            ToasterChanged?.Invoke(this, EventArgs.Empty);
        }

        public void Dispose()
        {
            if (Timer != null)
            {
                Timer.Elapsed += TimerElapsed;
                Timer.Stop();
            }
        }
    }
}
