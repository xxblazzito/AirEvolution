@isTest
public class futuraCuentaTest {

    @isTest
    private static void actualizarSLA()
    {
        Account cuentaNueva = New Account(Name = 'prueba Unitaria Futura');
        insert cuentaNueva;
        Test.startTest();
        futuraCuenta.updateCuenta(cuentaNueva.Id);
        Test.stopTest();
        
        List<Account> cuenta = [SELECT ID FROM Account WHERE SLA__c != null ];
        system.assertEquals(1, cuenta.size());
        
       
    }
}