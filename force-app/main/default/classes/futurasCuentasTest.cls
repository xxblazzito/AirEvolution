@isTest
public class futurasCuentasTest {
	@TestSetup
    static void makeData(){
        List<Account> accts = new List<Account>();
        for(integer i = 0; i < 50; i++){
            accts.add(new Account(name = 'test'+i));
        }

        insert accts;
    }

    @IsTest
    static void methodName(){        
        Test.startTest();
        futurasCuentas batchClass = new futurasCuentas(); 
        ID batchprocessid = Database.executeBatch(batchClass);
        Test.stopTest();
        
        List<Account> accts = [SELECT Id 
                                FROM Account 
                                WHERE SLASerialNumber__c != null
                               ];
        
        System.assertEquals(50,accts.size());
    }
}