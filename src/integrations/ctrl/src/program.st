PROGRAM MyProgram
    VAR_EXTERNAL
        MainContext : MyContext;
        ixcoreSequencers : IxSequencerExamples.SequencerExample;
        I_am_alive : ULINT;
        ixcoreTasks : IxTaskExamples.Tasks;
        myComponentExample : IxComponentExamples.ComponentExampleContext;
        myComponentHeaderOnlyExample : IxComponentExamples.ComponentHeaderOnlyExampleContext;
        ixcore_remote_tasks : IxRemoteTaskExamples.RemoteTasks;
        
    END_VAR    
    I_am_alive := I_am_alive + ULINT#1;
    MainContext.Run();
    ixcoreTasks.Run();
    ixcoreSequencers.Run();
    myComponentExample.Run();
    myComponentHeaderOnlyExample.Run();
    ixcore_remote_tasks.Run();   
END_PROGRAM


CLASS MyContext EXTENDS ix.framework.core.IxContext    
    VAR PUBLIC         
        process_data_manager_remote_exec: ixDataExamples.IxProcessDataManager;
    END_VAR

    METHOD PROTECTED OVERRIDE Main        
        THIS.DataExchangeTests();
    END_METHOD

    METHOD DataExchangeTests : Int       
        process_data_manager_remote_exec.Initialize(THIS);
        process_data_manager_remote_exec.Run();   
        
        IF(process_data_manager_remote_exec._create) THEN
            IF(process_data_manager_remote_exec.Create(process_data_manager_remote_exec._identifier).IsDone()) THEN
                process_data_manager_remote_exec._create := FALSE;
            END_IF;    
        END_IF;   
        
        IF(process_data_manager_remote_exec._read) THEN
            IF(process_data_manager_remote_exec.Read(process_data_manager_remote_exec._identifier).IsDone()) THEN
                process_data_manager_remote_exec._read := FALSE;
            END_IF;    
        END_IF;  

        IF(process_data_manager_remote_exec._update) THEN
            IF(process_data_manager_remote_exec.Update(process_data_manager_remote_exec._identifier).IsDone()) THEN
                process_data_manager_remote_exec._update := FALSE;
            END_IF;    
        END_IF;  

        IF(process_data_manager_remote_exec._delete) THEN
            IF(process_data_manager_remote_exec.Delete(process_data_manager_remote_exec._identifier).IsDone()) THEN
                process_data_manager_remote_exec._delete := FALSE;
            END_IF;    
        END_IF; 
    END_METHOD
END_CLASS    

