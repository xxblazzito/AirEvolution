public with sharing class quitarDescuentoMartes implements Database.Batchable<sObject>{
        
        public Database.QueryLocator start(Database.BatchableContext BC){
            string query = 'select id, unitprice, Descuento_Martes__c from pricebookEntry where Descuento_Martes__c = true AND Descuento_Por_Vencer__c = false';
            return Database.getQueryLocator(query);
        }
    
        public void execute(Database.BatchableContext BC, List<pricebookEntry> precios){
            for(pricebookEntry a: precios){
                decimal precio = a.unitprice;
                a.UnitPrice = precio/0.65;
                a.Descuento_Martes__c = False;
            }
            
            update precios;
        }
    
        public void finish(Database.BatchableContext BC){
            // notificar acerca del proceso
        }
    }