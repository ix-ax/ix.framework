USING AxUnit;

NAMESPACE ix.core.IxContext_Tests

    CLASS TestContext EXTENDS ix.framework.core.IxContext         
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD
    END_CLASS  

    {TestFixture}
    CLASS IxContextUnitTests
        VAR PROTECTED
            _context : TestContext;
        END_VAR    

        {Test}
        METHOD PUBLIC should_increment_counters_on_execute
            Assert.Equal(actual := ULINT#0, expected := _context.OpenCycleCount());
            Assert.Equal(actual := ULINT#0, expected := _context.ClosedCycleCount());
            _context.Run();
            Assert.Equal(actual := ULINT#1, expected := _context.OpenCycleCount());
            Assert.Equal(actual := ULINT#1, expected := _context.ClosedCycleCount());
        END_METHOD

        {Test}
        METHOD PUBLIC should_increment_identity_counter
            VAR
                expected    : ULINT;
                actual      : ULINT;
            END_VAR    
            expected := _context.PeekIdentity() + ULINT#1;
            actual := _context.CreateIdentity();
            Assert.Equal(expected, actual);
        END_METHOD
    END_CLASS

END_NAMESPACE
