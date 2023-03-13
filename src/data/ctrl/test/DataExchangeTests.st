USING ix.framework.core;
USING AxUnit;
NAMESPACE ix.framework.data 
    NAMESPACE DataExchangeTests
        CLASS TestContext IMPLEMENTS ix.framework.core.IIxContext         
            VAR PROTECTED                        
                _openCounter : ULINT;
                _closeCounter : ULINT;
                _identityCounter : ULINT;
             END_VAR       
            METHOD PUBLIC Open : ULINT
                _openCounter := _openCounter + ULINT#1;
            END_METHOD    
    
            METHOD PUBLIC Close : ULINT
                _closeCounter := _closeCounter + ULINT#1;
            END_METHOD
    
            METHOD PUBLIC OpenCycleCount : ULINT
                OpenCycleCount := _openCounter;
            END_METHOD
                    
            METHOD PUBLIC ClosedCycleCount : ULINT
                ClosedCycleCount := _closeCounter;
            END_METHOD
    
            METHOD PUBLIC CreateIdentity : ULINT            
                _identityCounter := _identityCounter + ULINT#1;
                CreateIdentity := _identityCounter;
            END_METHOD 
        END_CLASS      

        {TestFixture}
        CLASS DataExchange_Tests
            VAR PROTECTED
                _context : TestContext;
                _dataExchange : DataExchange;
            END_VAR    

            {Test}
            METHOD PUBLIC Create_sets_identifier
                VAR
                    expected : STRING[254];
                END_VAR    
                _dataExchange.Initialize(_context);
                _context.Open();
                expected := 'CreateRecordIdentifier';
                _dataExchange.Create(expected);
                _context.Close();
                AxUnit.Assert.Equal(_dataExchange.CreateTask.DataEntityIdentifier, expected);
            END_METHOD

            
            {Test}
            METHOD PUBLIC Read_sets_identifier
                VAR
                    expected : STRING[254];
                END_VAR    
                _dataExchange.Initialize(_context);
                _context.Open();
                expected := 'ReadRecordIdentifier';
                _dataExchange.Read(expected);
                _context.Close();
                AxUnit.Assert.Equal(_dataExchange.ReadTask.DataEntityIdentifier, expected);
            END_METHOD

            {Test}
            METHOD PUBLIC Update_sets_identifier
                VAR
                    expected : STRING[254];
                END_VAR    
                _dataExchange.Initialize(_context);
                _context.Open();
                expected := 'UpdateRecordIdentifier';
                _dataExchange.Update(expected);
                _context.Close();
                AxUnit.Assert.Equal(_dataExchange.UpdateTask.DataEntityIdentifier, expected);
            END_METHOD

            {Test}
            METHOD PUBLIC Delete_sets_identifier
                VAR
                    expected : STRING[254];
                END_VAR    
                _dataExchange.Initialize(_context);
                _context.Open();
                expected := 'DeleteRecordIdentifier';
                _dataExchange.Delete(expected);
                _context.Close();
                AxUnit.Assert.Equal(_dataExchange.DeleteTask.DataEntityIdentifier, expected);
            END_METHOD
        END_CLASS
    END_NAMESPACE    
END_NAMESPACE
