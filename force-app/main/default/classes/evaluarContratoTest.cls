@isTest
public with sharing class evaluarContratoTest {
    
    @isTest
    static void contratoTrimestreUno(){
        contract contrato1 = new contract(Status='Draft',Valor_Contrato__c=100000,startDate=Date.newInstance(2022,02,01));

        Contrato.evaluarContrato(contrato1);
        system.assertEquals(6,contrato1.ContractTerm);
    }

    @isTest
    static void contratoTrimestreDos(){
        contract contrato1 = new contract(Status='Draft',Valor_Contrato__c=100000,startDate=Date.newInstance(2022,05,01));

        Contrato.evaluarContrato(contrato1);
        system.assertEquals(3,contrato1.ContractTerm);
    }

    @isTest
    static void contratoTrimestreTres(){
        contract contrato1 = new contract(Status='Draft',Valor_Contrato__c=100,startDate=Date.newInstance(2022,10,01));

        Contrato.evaluarContrato(contrato1);
        system.assertEquals(1,contrato1.ContractTerm);
        system.assertEquals(85,contrato1.Valor_Total__c);
    }

    @isTest
    static void contratoFechaInvalida(){
        contract contrato1 = new contract(Status='Draft',Valor_Contrato__c=100000,startDate=Date.newInstance(2022,12,21));

        
        try {
            Contrato.evaluarContrato(contrato1);
        } catch (Exception e) {
            system.assert(e.getMessage().contains('fecha invalida'));
        }
    }
}