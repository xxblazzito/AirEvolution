public with sharing class agregarDescuentoMartes implements Database.Batchable<sObject>{
        
        public Database.QueryLocator start(Database.BatchableContext BC){
            string query = 'select id, unitprice,Descuento_Martes__c from pricebookEntry where Descuento_Martes__c = false AND Descuento_Por_Vencer__c = false';
            return Database.getQueryLocator(query);
        }
    
        public void execute(Database.BatchableContext BC, List<pricebookEntry> precios){
            for(pricebookEntry a: precios){
                decimal precio = a.unitprice;
                a.UnitPrice = precio - (precio * 0.35);
                a.Descuento_Martes__c = True;
            }
            
            update precios;
        }
    
        public void finish(Database.BatchableContext BC){
            // notificar acerca del proceso
        }
    }