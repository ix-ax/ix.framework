using ix.framework.core;

NAMESPACE IxTaskExamples

    CLASS MyCommandTask EXTENDS ix.framework.core.IxTask
        VAR PUBLIC
        {#ix-set:AttributeName = "Counter"}
        _counter : ULINT;
        END_VAR

        METHOD PROTECTED OVERRIDE OnRestore
            _counter := ULINT#0;
        END_METHOD
    END_CLASS    

    CLASS Tasks EXTENDS ix.framework.core.IxContext
        VAR PUBLIC
            {#ix-set:AttributeName = "Click to execute this command"}
            _commandTask : MyCommandTask;
            {#ix-set:AttributeName = "If true the command will end in failure."}
            _commandEndsInFailure : BOOL;
        END_VAR    
    
        METHOD PROTECTED OVERRIDE Main
            _commandTask.Initialize(THIS);    

            IF(_commandTask.Execute()) THEN        
                _commandTask._counter := _commandTask._counter + ULINT#1;        
                IF (_commandTask._counter MOD ULINT#250) = ULINT#0 THEN
                    if(_commandEndsInFailure) THEN
                        _commandTask.ThrowWhen(TRUE);    
                    ELSE                            
                        _commandTask.DoneWhen(TRUE);
                    END_IF;    
                END_IF;    
            END_IF;    
        END_METHOD
    END_CLASS    
END_NAMESPACE
