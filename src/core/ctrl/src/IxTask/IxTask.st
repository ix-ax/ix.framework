NAMESPACE ix.framework.core

    CLASS PUBLIC IxTask EXTENDS IxObject IMPLEMENTS IIxTask, IIxTaskState

        VAR PUBLIC
            ///<summary>
            /// Gets the state of this task.
            ///</summary>
            {#ix-set:AttributeName = "<#Command state#>"}
            {#ix-attr:[ReadOnly()]}
            Status : eIxTaskState;     
             
            ///<summary>
            /// Gets or sets whether this task is disabled for execution.
            ///</summary>
            IsDisabled : BOOL;

            ///<summary>
            /// Remote requests for invoke of this task.
            /// When 'TRUE' this task will be invoked.
            ///</summary>
            RemoteInvoke : BOOL;

            ///<summary>
            /// Remote requests for restore of this task.
            /// When 'TRUE' this task will be restored.
            ///</summary>
            RemoteRestore : BOOL;

            ///<summary>
            /// Remote requests for abort of this task.
            /// When 'TRUE' this task will be aborted.
            ///</summary>
            RemoteAbort : BOOL;

            ///<summary>
            /// Remote requests for resume of this task.
            /// When 'TRUE' this task will be resumed.
            ///</summary>
            RemoteResume : BOOL;

            ///<summary>
            /// Contains contex cycle number when this task started.            
            ///</summary>           
            StartSignature : ULINT;
        END_VAR    
        
        VAR PRIVATE
            _openCycleCountInvoke : ULINT;
            _openCycleCountExecute : ULINT;
        END_VAR 
        
        ///<summary>
        /// Gets the actual state of this task.
        ///</summary>    
        METHOD PUBLIC GetState : eIxTaskState          
            THIS.UpdateState();
            GetState := Status;
        END_METHOD

        ///<summary>
        /// Gets true when the task is ready.
        ///</summary>
        METHOD PUBLIC IsReady : BOOL 
            THIS.UpdateState();
            IsReady := Status = eIxTaskState#Ready; 
        END_METHOD   

        ///<summary>
        /// Gets true when the task is done.
        ///</summary>
        METHOD PUBLIC IsDone : BOOL 
            THIS.UpdateState();
            IsDone := Status = eIxTaskState#Done ; 
        END_METHOD
                    
        ///<summary>
        /// Gets true when the task is busy/executing.
        ///</summary>
        METHOD PUBLIC IsBusy : BOOL 
            THIS.UpdateState();
            IsBusy := Status = eIxTaskState#Busy; 
        END_METHOD
            
        ///<summary>
        /// Gets true when the task is aborted.
        ///</summary>
        METHOD PUBLIC IsAborted : BOOL 
            THIS.UpdateState();
            IsAborted := Status = eIxTaskState#Aborted; 
        END_METHOD
            
        ///<summary>
        /// Gets true when the task has error.
        ///</summary>
        METHOD PUBLIC HasError : BOOL 
            THIS.UpdateState();
            HasError := Status = eIxTaskState#Error; 
        END_METHOD   

        METHOD PRIVATE IsNewInvokeCall : BOOL
            IF NOT IsNullContext(THIS.GetContext()) THEN
                IsNewInvokeCall := _openCycleCountInvoke < THIS.GetContext().OpenCycleCount() - ULINT#1;
            ELSE
                IsNewInvokeCall := FALSE;
            END_IF;     
        END_METHOD 

        METHOD PRIVATE IsInvokeCalledInThisPlcCycle : BOOL
            IF NOT IsNullContext(THIS.GetContext()) THEN
                IsInvokeCalledInThisPlcCycle := _openCycleCountInvoke = THIS.GetContext().OpenCycleCount();
            ELSE
                IsInvokeCalledInThisPlcCycle := FALSE;
            END_IF;     
        END_METHOD 
        
        METHOD PRIVATE WasInvokeCalledInPreviousPlcCycle : BOOL
            IF NOT IsNullContext(THIS.GetContext()) THEN
                WasInvokeCalledInPreviousPlcCycle := _openCycleCountInvoke +ULINT#1 = THIS.GetContext().OpenCycleCount();
            ELSE
                WasInvokeCalledInPreviousPlcCycle := FALSE;
            END_IF;     
        END_METHOD 
        
        METHOD PRIVATE IsNewExecuteCall : BOOL
            IF NOT IsNullContext(THIS.GetContext()) THEN
                IsNewExecuteCall := _openCycleCountExecute < THIS.GetContext().OpenCycleCount() - ULINT#1;
            ELSE
                IsNewExecuteCall := FALSE;
            END_IF;     
        END_METHOD 

        METHOD PRIVATE IsExecuteCalledInThisPlcCycle : BOOL
            IF NOT IsNullContext(THIS.GetContext()) THEN
                IsExecuteCalledInThisPlcCycle := _openCycleCountExecute = THIS.GetContext().OpenCycleCount();
            ELSE
                IsExecuteCalledInThisPlcCycle := FALSE;
            END_IF;     
        END_METHOD 
        
        METHOD PRIVATE WasExecuteCalledInPreviousPlcCycle : BOOL
            IF NOT IsNullContext(THIS.GetContext()) THEN
                WasExecuteCalledInPreviousPlcCycle := _openCycleCountExecute + ULINT#1 = THIS.GetContext().OpenCycleCount();
            ELSE
                WasExecuteCalledInPreviousPlcCycle := FALSE;
            END_IF;     
        END_METHOD 
        
        METHOD PRIVATE UpdateState 
            IF Status <> eIxTaskState#Error AND IsDisabled THEN
                Status := eIxTaskState#Disabled; 
            ELSIF Status = eIxTaskState#Disabled AND NOT IsDisabled THEN
                Status := eIxTaskState#Ready; 
            END_IF;
        END_METHOD        

        ///<summary>
        /// Invokes this task.
        ///</summary>    
        METHOD PUBLIC Invoke : IIxTaskState
            VAR
                _isNullContext : BOOL;
            END_VAR;
            
            _isNullContext := IsNullContext(THIS.GetContext());


            IF _isNullContext THEN
                Status := eIxTaskState#Error;
            END_IF;
            THIS.UpdateState();

            IF Status = eIxTaskState#Done AND THIS.IsNewInvokeCall() THEN
                Status := eIxTaskState#Ready; 
            END_IF;

            _openCycleCountInvoke := THIS.GetContext().OpenCycleCount();

            // task task should not be Invoked, if the execute method was not called in this or previous PLC cycle
            IF Status = eIxTaskState#Ready AND (THIS.IsExecuteCalledInThisPlcCycle() OR THIS.WasExecuteCalledInPreviousPlcCycle()) THEN
                Status := eIxTaskState#Kicking;
            END_IF;     

            Invoke := THIS;
        END_METHOD    

        ///<summary>
        /// Restores this task.
        ///</summary>    
        METHOD PUBLIC Restore : IIxTaskState
            Status := eIxTaskState#Ready; 
            THIS.UpdateState();
            Restore := THIS;
            THIS.OnRestore();
        END_METHOD    
            
        ///<summary>
        ///  Makes this task to transition in `Done` state 
        ///  when `Condition` argument is `TRUE`.
        ///</summary>    
        METHOD PUBLIC DoneWhen
            VAR_INPUT
                Condition : BOOL;
            END_VAR
              
            IF Condition AND Status = eIxTaskState#Busy THEN   
                Status := eIxTaskState#Done;
                THIS.OnDone();
            END_IF;    
        END_METHOD

        ///<summary>
        /// Returns `TRUE` if the task is Busy, otherwise false.
        ///	This method needs to be called cyclically.
        ///</summary>    
        METHOD PUBLIC Execute : BOOL            
            IF( RemoteInvoke) THEN THIS.Invoke(); RemoteInvoke := FALSE; END_IF;
            IF( RemoteRestore) THEN THIS.Restore(); RemoteRestore := FALSE; END_IF;
            IF( RemoteAbort) THEN THIS.Abort(); RemoteAbort := FALSE; END_IF;
            IF( RemoteResume) THEN THIS.Resume(); RemoteResume := FALSE; END_IF;

            _openCycleCountExecute := THIS.GetContext().OpenCycleCount();
                
            // If the Invoke() method was called in more then one PLC cycle back without calling the Execute() method
            // and the Execute() is subsequently called without calling the Invoke() method in the same PLC cycle,
            // CommandTask is set back to ready and does not start the execution.
            IF Status = eIxTaskState#Kicking AND NOT THIS.IsInvokeCalledInThisPlcCycle() AND NOT THIS.WasInvokeCalledInPreviousPlcCycle() THEN
                Status := eIxTaskState#Ready;
            END_IF;

            IF(Status = eIxTaskState#Kicking) THEN
                Status := eIxTaskState#Busy; 
                // Don't touch this, it is used for remote execs.
                StartSignature := THIS.GetContext().OpenCycleCount();               
                THIS.OnStart();
            END_IF;    

            IF(Status = eIxTaskState#Error) THEN
                THIS.WhileError();
            END_IF;   

            THIS.UpdateState();
            Execute := Status = eIxTaskState#Busy;
        END_METHOD    

        ///<summary>
        /// Makes this task enter into `Error` state, when `HasErrorState` argument is `TRUE`
        /// task in error state stops its execution.
        ///</summary>    
        METHOD PUBLIC ThrowWhen
            VAR_INPUT
                HasErrorState : BOOL;
            END_VAR

            IF(HasErrorState) THEN
                Status := eIxTaskState#Error;           
                THIS.OnError();  
                THIS.WhileError();   
            END_IF;    
        END_METHOD    
    
        ///<summary>
        /// Sets the value of the `IsDisabled` variable
        ///</summary>
        METHOD PUBLIC SetIsDisabled
            VAR_INPUT
                Disabled : BOOL;
            END_VAR
            IsDisabled := Disabled;
        END_METHOD

        ///<summary>
        /// Returns the value of the `IsDisabled` variable
        ///</summary>
        METHOD PUBLIC GetIsDisabled : BOOL
            GetIsDisabled := IsDisabled;
        END_METHOD
    
        ///<summary>
        /// Aborts the execution of the task if running and sets its state to aborted.
        ///</summary>
        METHOD PUBLIC Abort 
            IF THIS.Status = eIxTaskState#Busy THEN
                THIS.Status := eIxTaskState#Aborted;
                THIS.OnAbort();
            END_IF;
        END_METHOD
    
        ///<summary>
        /// Resume the execution of the task if aborted and sets its state to busy.
        ///</summary>
        METHOD PUBLIC Resume 
            IF THIS.Status = eIxTaskState#Aborted THEN
                THIS.Status := eIxTaskState#Busy;
                THIS.OnResume();
            END_IF;
        END_METHOD
    
        ///<summary>
        /// Executes once when the task is aborted.
        ///</summary>
        METHOD PROTECTED OnAbort 
            ;
        END_METHOD

        ///<summary>
        /// Executes once when the task is resumed.
        ///</summary>
        METHOD PROTECTED OnResume 
            ;
        END_METHOD

        ///<summary>
        /// Executes once when the task reaches the `Done` state.
        ///</summary>
        METHOD PROTECTED OnDone 
            ;
        END_METHOD
    
        ///<summary>
        /// Executes once when the task reaches the `Error` state.
        ///</summary>
        METHOD PROTECTED OnError 
            ;
        END_METHOD
    
        ///<summary>
        /// Executes once when the task is restored.
        ///</summary>
        METHOD PROTECTED OnRestore 
            ;
        END_METHOD
    
        ///<summary>
        /// Executes once when the task starts (at the moment of transition from the `Kicking` state into the `Busy` state).
        ///</summary>
        METHOD PROTECTED OnStart 
            ;
        END_METHOD
    
        ///<summary>
        /// Executes repeatedly while the task is in `Error` state (and `Execute()` method is called).
        ///</summary>
        METHOD PROTECTED WhileError 
            ;
        END_METHOD    
    END_CLASS    
END_NAMESPACE