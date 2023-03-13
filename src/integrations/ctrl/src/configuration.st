CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;
    PROGRAM P2 WITH Main: ProgramExample;

    VAR_GLOBAL
        ixcoreTasks : IxTaskExamples.Tasks;
        ixcoreSequencers : IxSequencerExamples.SequencerExample;
        {#ix-attr:[Container(Layout.Wrap)]}
        MainContext : MyContext;
        Recipe : Recipe;
        myComponentExample : IxComponentExamples.ComponentExampleContext;
        myComponentHeaderOnlyExample : IxComponentExamples.ComponentHeaderOnlyExampleContext;
        {#ix-set:AttributeName = "If counting PLC is alive"}
        I_am_alive : ULINT;
        
        ixcore_remote_tasks : IxRemoteTaskExamples.RemoteTasks;
        
        process_data_manager: ixDataExamples.IxProcessDataManager;
       
        // Issues
        gh_ptku_8 : Layouts.Tabbed.weather;
    END_VAR
END_CONFIGURATION
