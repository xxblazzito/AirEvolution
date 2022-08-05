@isTest
public class queueableFuturasCuentasTest {
	
    @TestSetup
    static void makeData(){
        List<Account> accts = new List<Account>();
        for(integer i = 0; i < 50; i++){
            accts.add(new Account(name = 'test'+i));
        }

        insert accts;
    }
	@isTest
    static void pruebaQueueable(){
        queueableFuturasCuentas prueba = new queueableFuturasCuentas();
        Test.startTest();
        system.enqueueJob(prueba);
        Test.stopTest();
        List<Account> accts = [SELECT Id 
                                FROM Account 
                                WHERE SLASerialNumber__c != null
                               ];
        
        System.assertEquals(50,accts.size());
    }
}