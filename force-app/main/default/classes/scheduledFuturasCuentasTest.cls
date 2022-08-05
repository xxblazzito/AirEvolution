@isTest
public class scheduledFuturasCuentasTest {
	@TestSetup
    static void makeData(){
        List<Account> accts = new List<Account>();
        for(integer i = 0; i < 50; i++){
            accts.add(new Account(name = 'test'+i));
        }

        insert accts;
    }
    
    @isTest
    static void pruebaSchedulable(){
        
        Test.startTest();
        scheduledFuturasCuentas m = new scheduledFuturasCuentas();
        String sch = '0 0 1 1/1 * ? *';
        String jobID = system.schedule('Test Programado', sch, m);
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                         	FROM CronTrigger WHERE id =: jobID];
        
        system.assertEquals(sch, ct.CronExpression);
        
        system.assertEquals(0, ct.TimesTriggered);
        
        system.assertEquals('2022-08-05 01:00:00',String.valueOf(ct.NextFireTime));
        
        Test.stopTest();
            
        List<Account> accts = [SELECT Id 
                                FROM Account 
                                WHERE SLASerialNumber__c != null
                               ];
        
        //System.assertEquals(50,accts.size());
    }
}