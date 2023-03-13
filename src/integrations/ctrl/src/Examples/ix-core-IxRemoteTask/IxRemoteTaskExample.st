using ix.framework.core;

NAMESPACE IxRemoteTaskExamples

    CLASS MyRemoteTask EXTENDS ix.framework.core.IxRemoteTask
        VAR PUBLIC        
            Message : STRING[254];
            Counter : INT;
        END_VAR

        
        METHOD PUBLIC Invoke : IIxTaskState
            VAR_INPUT
                LogMessage : STRING[254];
                LogCounter : INT;
            END_VAR;  
            Counter := LogCounter;
            Message := LogMessage;
            Invoke := SUPER.Invoke();
        END_METHOD

    END_CLASS    

    CLASS RemoteTasks EXTENDS ix.framework.core.IxContext
        VAR PUBLIC
            {#ix-set:AttributeName = "Click to execute this command"}
            _remoteTask : MyRemoteTask;
            {#ix-set:AttributeName = "Trigger from PLC"}  
            _remoteTaskInvokeFromPlc : BOOL;     
            _doneCounter : INT;
        END_VAR    
    
        METHOD PROTECTED OVERRIDE Main
            _remoteTask.Initialize(THIS); 
            
            IF(_remoteTaskInvokeFromPlc) THEN
                IF(_remoteTask.Invoke('hello', _doneCounter).IsDone()) THEN
                    _doneCounter := _doneCounter + 1;    
                    _remoteTaskInvokeFromPlc := FALSE;                
                END_IF;    
            END_IF;    
            _remoteTask.Execute();
        END_METHOD
    END_CLASS    
END_NAMESPACE
