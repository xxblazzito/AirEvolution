@isTest
public with sharing class AccountTriggerHandlerTest {
    
        
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

            system.assertEquals(200, casos.size());
            
        }

    }