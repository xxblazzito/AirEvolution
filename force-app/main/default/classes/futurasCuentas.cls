public with sharing class futurasCuentas implements Database.Batchable<sObject>{
        
        public Database.QueryLocator start(Database.BatchableContext BC){
            string query = 'SELECT id FROM Account '+'WHERE SLASerialNumber__c = null';
            return Database.getQueryLocator(query);
        }
    
        public void execute(Database.BatchableContext BC, List<Account> accts){
            for(account a: accts){
                String numeroRandom = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 9);
                a.SLASerialNumber__c = numeroRandom;
                
            }
            
            update accts;
        }
    
        public void finish(Database.BatchableContext BC){
            // notificar acerca del proceso
        }
    }