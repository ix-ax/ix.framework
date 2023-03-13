USING ix.framework.core;
NAMESPACE ix.framework.data    
    CLASS DataExchangeTask EXTENDS ix.framework.core.IxRemoteTask 
        VAR PUBLIC
            DataEntityIdentifier : STRING[254];
        END_VAR                

        METHOD PUBLIC Invoke : ix.framework.core.IIxTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR 

            DataEntityIdentifier := identifier;            
            Invoke := SUPER.Invoke();
        END_METHOD    
    END_CLASS   
END_NAMESPACE