using System;
using Ix.Connector;
using System.ComponentModel;
using System.Threading.Tasks;

namespace ix.framework.core
{
    public partial class IxRemoteTask 
    {
        internal Action DeferredAction { get; private set; }

        public event PropertyChangedEventHandler PropertyChanged;

        /// <summary>
        /// Initializes this  <see cref="IxRemoteTask"/>.
        /// </summary>
        /// <param name="deferredAction">Action to be executed on this <see cref="IxRemoteTask"/> call.</param>
        public void Initialize(Action deferredAction)
        {
            DeferredAction = deferredAction;
            this.IsInitialized.Cyclic = true;
            this.StartSignature.Subscribe(ExecuteAsync);
            _defferedActionCount++;
        }

        /// <summary>
        /// Initializes this  <see cref="IxRemoteTask"/>.
        /// </summary>
        /// <param name="deferredAction">Action to be executed on this <see cref="IxRemoteTask"/> call.</param>
        public void Initialize(Func<bool> deferredAction)
        {
            DeferredAction = new Action(() => deferredAction());
            this.IsInitialized.Cyclic = true;
            this.StartSignature.Subscribe(ExecuteAsync);
            _defferedActionCount++;
        }

        private int _defferedActionCount;

        /// <summary>
        /// Initializes this  <see cref="IxRemoteTask"/> exclusively for this <see cref="DeferredAction"/>. Any following attempt
        /// to initialize this <see cref="IxRemoteTask"/> will throw an exception.
        /// </summary>
        /// <param name="deferredAction">Action to be executed on this <see cref="IxRemoteTask"/> call.</param>
        public void InitializeExclusively(Action deferredAction)
        {

            if (_defferedActionCount > 0)
            {
                throw new MultipleRemoteCallInitializationException("There was an attempt to initialize exclusive RPC call more than once in this application.");
            }

            DeferredAction = deferredAction;
            this.IsInitialized.Cyclic = true;
            this.StartSignature.Subscribe(ExecuteAsync);
            _defferedActionCount++;
        }

        /// <summary>
        /// Initializes this  <see cref="IxRemoteTask"/> exclusively for this <see cref="DeferredAction"/>. Any following attempt
        /// to initialize this <see cref="IxRemoteTask"/> will throw an exception.
        /// </summary>
        /// <param name="deferredAction">Action to be executed on this <see cref="IxRemoteTask"/> call.</param>
        public void InitializeExclusively(Func<bool> deferredAction)
        {

            if (_defferedActionCount > 0)
            {
                throw new MultipleRemoteCallInitializationException("There was an attempt to initialize exclusive RPC call more than once in this application.");
            }

            DeferredAction = new Action(() => deferredAction());
            this.IsInitialized.Cyclic = true;
            this.StartSignature.Subscribe(ExecuteAsync);
            _defferedActionCount++;
        }

        /// <summary>
        /// Removes currently bound <see cref="DeferredAction"/> from the execution of this <see cref="IxRemoteTask"/>
        /// </summary>
        public void DeInitialize()
        {
            this.IsInitialized.Cyclic = false;
            this.StartSignature.UnSubscribe(ExecuteAsync);
            _defferedActionCount--;
        }

        internal bool IsRunning = false;

        private async void ExecuteAsync(Ix.Connector.ITwinPrimitive sender, Ix.Connector.ValueTypes.ValueChangedEventArgs args)
        {
            await (this as ITwinObject).ReadAsync();

            if (this.StartSignature.LastValue != 0 &&
                !IsRunning &&
                this.StartSignature.LastValue != this.DoneSignature.LastValue)
            {
                try
                {
                    IsRunning = true;
                    RemoteExecutionException = null;
                    await System.Threading.Tasks.Task.Run(() => { DeferredAction.Invoke(); });
                }
                catch (Exception ex)
                {
                    await this.ExceptionMessage.SetAsync(ex.Message);
                    RemoteExecutionException = ex;
                    RemoteExceptionDetails = ex.ToString();
                    // TODO: Add logging
                    return;
                }
                finally
                {
                    IsRunning = false;
                }

                await this.DoneSignature.SetAsync(this.StartSignature.LastValue);
            }
        }

        private Exception _remoteExecutionException;

        /// <summary>
        /// Gets the exception that occurred during the last execution.
        /// </summary>
        public Exception RemoteExecutionException
        {
            get => _remoteExecutionException;
            private set
            {
                if (_remoteExecutionException == value)
                {
                    return;
                }

                _remoteExecutionException = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(RemoteExecutionException)));
            }
        }

        private string _remoteExceptionDetails;

        /// <summary>
        /// Gets string representation of the current exception on this remote task.
        /// </summary>
        public string RemoteExceptionDetails
        {
            get => _remoteExceptionDetails;
            private set
            {
                _remoteExceptionDetails = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(RemoteExceptionDetails)));
            }
        }

        /// <summary>
        /// Resets the resets this instance of <see cref="IxRemoteTask"/>.        
        /// </summary>
        /// <note>If the procedure is being called from the PLC, once the <see cref="ResetExecution"/> method is called the execution of this 
        /// <see cref="IxRemoteTask"/> will start again.</note>
        public async Task ResetExecution()
        {
            await this.StartSignature.SetAsync(0);
            await this.DoneSignature.SetAsync(0);
            await this.ExceptionMessage.SetAsync(string.Empty);
            IsRunning = false;
        }
    }
}