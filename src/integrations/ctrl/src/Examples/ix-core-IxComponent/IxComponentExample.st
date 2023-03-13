using ix.framework.core;

NAMESPACE IxComponentExamples
    //<Implementation>
    {#ix-attr:[Container(Layout.Stack)]}
    {#ix-set:AttributeName = "IxComponent example name"}
    CLASS PUBLIC IxComponentExample EXTENDS ix.framework.core.IxComponent  
        METHOD PROTECTED OVERRIDE Restore: IIxTask 
            ;
        END_METHOD
        METHOD PROTECTED OVERRIDE ManualControl
            ;
        END_METHOD

        METHOD PUBLIC Run
            VAR_INPUT 
                inReal : REAL;
                inDint : DINT;
            END_VAR
            VAR_OUTPUT
                outReal : REAL;
                outDint : DINT;
            END_VAR
            // This must be called first.
            SUPER.Open();
            // Place the custom logic here.
            Status.SomeStatusValue1  := Status.SomeStatusValue1  * inReal;
            Status.SomeStatusValue2 := Status.SomeStatusValue2 + inDint;

            outReal := Status.SomeStatusValue1;
            outDint := Status.SomeStatusValue2;
        END_METHOD 

        VAR PUBLIC
            // Complete structure as a part of the component header. 
            // All structure members are going to be displayed in the component header.
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}        
            Header : Header_ComponentExample; 

            // Two separate tasks as a part of the component header. 
            // These tasks are going to be added to the previous members of the component header.
            {#ix-attr:[ComponentHeader()]}        
            {#ix-set:AttributeName = "Header task 1"}
            HeaderTask1 : IxTask;

            // Complete structure as a part of the component details tab `Tasks`. 
            // All structure members are going to be added to the previous members of the component details tab `Tasks`.
            {#ix-set:AttributeName = "Tasks"}
            {#ix-attr:[Container(Layout.Stack)]}
            Tasks : Tasks_ComponentExample;
    
            // Single task as a part of the component details tab `Tasks`. 
            // This task is going to be displayed in the component details tab `Tasks`
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "Detail task in Tasks tab"}
            DetailTaskInTasksTab : IxTask;
    
            // Additional separate task as a part of the component header. 
            // This task is going to be added to the previous members of the component header.
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "Header task 2"}
            HeaderTask2 : IxTask;

            // Complete structure as a part of the component details tab `Status` as the attribute [ComponentDetails("Status")] 
            // is defined on the class Status_ComponentExample. 
            // All structure members are going to be added to the previous members of the component details tab `Status`.
            {#ix-set:AttributeName = "Status class"}
            Status :Status_ComponentExample;

            // Single variable as a part of the component details tab `Status`. 
            // This variable is going to be added to the previous members of the component details tab `Status`.
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[Container(Layout.Stack)]}        
            {#ix-set:AttributeName = "Status string"}
            Status2 : string;

            // Additional separate task as a part of the component header. 
            // This task is going to be added to the previous members of the component header.
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "Header task 3"}
            HeaderTask3 : IxTask;

            // Complete structure as a part of the component details tab `Settings` as the attribute [ComponentDetails("Settings")] 
            // is defined on the class Settings_ComponentExample. 
            // All structure members are going to be added to the previous members of the component details tab `Settings`.
            {#ix-set:AttributeName = "Settings"}
            Settings : Settings_ComponentExample;

            // Complete structure as a part of the component details tab `Diagnostics` as the attribute [ComponentDetails("Diagnostics")] 
            // is defined on the class Diagnostics_ComponentExample. git 
            // All structure members are going to be added to the previous members of the component details tab `Diagnostics`.
            {#ix-set:AttributeName = "Diagnostics"}
            Diagnostics : Diagnostics_ComponentExample;

            // Complete structure as a part of the component details tab `Help` as the attribute [ComponentDetails("Help")] 
            // is defined on the class Help_ComponentExample. 
            // All structure members are going to be added to the previous members of the component details tab `Help`.
            {#ix-set:AttributeName = "Help"}
            Help : Help_ComponentExample; 


        END_VAR
    END_CLASS
   //</Implementation>

   //<ClassDefinitions>
    CLASS PUBLIC Header_ComponentExample
        VAR PUBLIC
            {#ix-set:AttributeName = "Start"}
            Start : IxTask;
            {#ix-set:AttributeName = "Stop"}
            Stop : IxTask;
            {#ix-set:AttributeName = "Status"}
            Status : STRING:='Some status description';
        END_VAR
    END_CLASS

    {#ix-attr:[Container(Layout.Stack)]}
    {#ix-attr:[ComponentDetails("Tasks")]}
    CLASS PUBLIC Tasks_ComponentExample
        VAR PUBLIC
            {#ix-set:AttributeName = "Some status value 1"}
            SomeStatusValue1 : REAL := REAL#45.3;
            {#ix-set:AttributeName = "Some advanced component task 1"}
            SomeAdvancedComponentTask1 : IxTask;
            {#ix-set:AttributeName = "Some advanced component task 2"}
            SomeAdvancedComponentTask2 : IxTask;
            {#ix-set:AttributeName = "Some advanced component task 3"}
            SomeAdvancedComponentTask3 : IxTask;
            {#ix-set:AttributeName = "Some advanced component task 4"}
            SomeAdvancedComponentTask4 : IxTask;
            {#ix-set:AttributeName = "Some advanced component task 5"}
            SomeAdvancedComponentTask5 : IxTask;
        END_VAR
    END_CLASS

    {#ix-attr:[Container(Layout.Stack)]}
    {#ix-attr:[ComponentDetails("Status")]}
    CLASS PUBLIC Status_ComponentExample
        VAR PUBLIC
            {#ix-set:AttributeName = "Some status value 1"}
            SomeStatusValue1 : REAL := REAL#45.3;
            {#ix-set:AttributeName = "Some status value 2"}
            SomeStatusValue2 : DINT := DINT#46587;
            {#ix-set:AttributeName = "Some status value 3"}
            SomeStatusValue3 : STRING := 'some description';
        END_VAR
    END_CLASS

    {#ix-attr:[ComponentDetails("Settings")]}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Settings_ComponentExample
        VAR PUBLIC
            {#ix-set:AttributeName = "Some setting value 1"}
            SomeSettingValue1 : REAL := REAL#45.3;
            {#ix-set:AttributeName = "Some setting value 2"}
            SomeSettingValue2 : DINT := DINT#46587;
            {#ix-set:AttributeName = "Some setting value 3"}
            SomeSettingValue3 : STRING := 'some setting';
        END_VAR
    END_CLASS

    {#ix-attr:[ComponentDetails("Diagnostics")]}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Diagnostics_ComponentExample
        VAR PUBLIC
            {#ix-set:AttributeName = "Some diagnostic message"}
            SomeDiagnosticMessage : STRING := 'TODO: Some diagnostic message needs to be placed here';
        END_VAR
    END_CLASS

    {#ix-attr:[ComponentDetails("Help")]}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Help_ComponentExample
        VAR PUBLIC
            {#ix-set:AttributeName = "Some help"}
            SomeHelp : STRING := 'TODO: Provide some help';
        END_VAR
    END_CLASS
   //</ClassDefinitions>

   //<Using>
    CLASS ComponentExampleContext EXTENDS ix.framework.core.IxContext
        VAR PUBLIC
            {#ix-set:AttributeName = "Component example name"}
            MyComponent : IxComponentExample;  
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;  

            inHwReal : REAL := REAL#1.0001;
            inHwDint : DINT := DINT#1;
            outHwReal : REAL;
            outHwDint : DINT;

        END_VAR

        METHOD PROTECTED OVERRIDE Main   
            // The `Initialize()` method must be called before any other method.
            MyComponent.Initialize(THIS);
            // Example of the activation of the manual control. 
            IF ActivateManualControl THEN
                MyComponent.ActivateManualControl();
            END_IF;
            // Calling the main method `Run` with respective input and output variables. 
            MyComponent.Run(inReal :=  inHwReal,
                            inDint :=  inHwDint,
                            outReal => outHwReal,
                            outDint => outHwDint);
        END_METHOD
    END_CLASS
   //</Using>
END_NAMESPACE
