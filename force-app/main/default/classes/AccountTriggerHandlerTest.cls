@isTest
public with sharing class AccountTriggerHandlerTest {
    
    @TestSetup
    static void makeData()
    {
        Account cuenta = new Account(Name='Prueba');
        insert cuenta;
    }
        
    @isTest
    private static void casoCreado(){
        Account cuenta = new Account(Name = 'Cuenta de Test');
        insert cuenta;
        
        case casoCreado = [SELECT Subject FROM case Limit 1];
        
        system.assertEquals('Dedupe this Account', casoCreado.subject);
    }
    
    @isTest
    private static void casosMasivos(){
        List<Account> cuentas = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            Account cuenta = new Account(Name = 'Cuenta de Test'+i);
            cuentas.add(cuenta);
        }
        insert cuentas;
        
        List<Case> casos = [SELECT Id FROM Case];
        
        system.assertEquals(201, casos.size());
        
    }
    
    @isTest
    private static void actualizarUnaCuenta(){
        Account cuentita = [SELECT Id,Name FROM Account WHERE Name ='Prueba'];
        
        cuentita.Name = 'Prueba Actualizada';
        
        update cuentita;
        
        Account cuentaActualizada = [Select Id,Name From Account];
        
        system.assertEquals('Prueba Actualizada', cuentaActualizada.Name);
    }
    
    @isTest
    private static void deleteCuenta(){
        Account cuentas = [Select Id From Account Limit 1];
        Id idcuenta = cuentas.Id;
        Case casos = [Select Id From Case Where AccountId =: idcuenta];
        delete casos;
        delete cuentas;
        
        List<Account> CuentaEliminada = [Select id From Account Where Id =: idcuenta];
        
        system.assertEquals(0, CuentaEliminada.size()); 
        
        Account cuentaPaRestaurar = new Account(Id = idcuenta);
        undelete cuentaPaRestaurar;
        
        List<Account> CuentaRestaurada = [Select id From Account Where Id =: idcuenta];
        
        system.assertEquals(1, CuentaRestaurada.size());
    }
    
}