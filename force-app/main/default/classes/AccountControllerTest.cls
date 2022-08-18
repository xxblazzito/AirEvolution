@isTest
public class AccountControllerTest {

    @TestSetup
    static void makeData()
    {
        List<Account> cuentas = new List<Account>();
        for(integer i = 0 ; i < 50; i++){
            Account cuenta = new Account(Active__c = 'Yes',Name = 'a-000'+i);
            cuentas.add(cuenta);
        }
        insert cuentas;
    }
    
    @isTest
    private static void contarCuentas(){
        List<Account> cuentas = AccountController.getAllActiveAccounts();
        
        system.assertEquals(50, cuentas.size());
    }
}