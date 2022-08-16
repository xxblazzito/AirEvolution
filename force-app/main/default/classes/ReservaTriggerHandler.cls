public with sharing class ReservaTriggerHandler implements triggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;

    Public ReservaTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Opportunity> newAccounts){
        NombreDeReserva(newAccounts);
    }
    public void beforeUpdate(List<Opportunity> oldAccounts,List<Opportunity> newAccounts,Map<ID,SObject> oldAccountMap,Map<ID,SObject> newAccountMap){
        ReservarSinVuelo(newAccounts);
    }
    public void beforeDelete(List<Opportunity> oldAccounts, Map<ID,SObject> oldAccountMap){
        // code here
    }
    public void afterInsert(List<Opportunity> newAccounts,Map<ID,SObject> newAccountMap){
        
    }
    public void afterUpdate(List<Opportunity> oldAccounts,List<Opportunity> newAccounts,Map<ID,SObject> oldAccountMap, Map<ID,SObject> newAccountMap){
        ReservaPagada(newAccounts);
    }
    public void afterDelete(List<Opportunity> oldAccounts,Map<ID,SObject> oldAccountMap){
        // code here
    }
    public void afterUndelete(List<Opportunity> newAccounts,Map<ID,SObject> newAccountMap){
        // code here
    }

    public static void ReservarSinVuelo(List<Opportunity> oportunidad){
        for(Opportunity reserva : oportunidad){
            if((reserva.Numero_de_Vuelo__c<1 && reserva.StageName == 'Pagado')||(reserva.Numero_de_Vuelo__c<1 && reserva.StageName == 'Completado')){
                reserva.Numero_de_Vuelo__c.addError('Para completar o pagar una reserva, Esta debe de tener por lo menos un vuelo asignado');
            } 
        }
    }

    public static void NombreDeReserva(List<Opportunity> opportunities) {
        set <Id> TitularesID = new set<Id>();
        for(Opportunity opp : opportunities){
            TitularesID.add(opp.Titular_de_la_Reserva__c);
        }
        Map<Id, Contact>  Titulares = new Map<Id, Contact>([SELECT Id,Name FROM Contact WHERE Id = : TitularesID]);
        
        for (Opportunity opp : opportunities) {
            if(String.isNotEmpty(opp.Name)){
                String NumeroDeReserva = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 7);
                opp.Name = Titulares.get(opp.Titular_de_la_Reserva__c).name.replace(' ','') +'-'+ NumeroDeReserva;
                System.debug('nombre de reserva: '+ opp.Name);
            }
        }
    }
    
    public static void ReservaPagada(List<Opportunity> oportunidades){
        List<String> idContactos= new list<String>();
        for(Opportunity reserva: oportunidades){
            if(reserva.StageName == 'Pagado'){
            	idContactos.add(reserva.Titular_de_la_reserva__c);
            }
        }
        if(idContactos.size()>0){
           EmailTemplate et=[Select id from EmailTemplate where name = 'Querido pasajero de reserva' limit 1];
           Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
           mail.setTargetObjectIds(idContactos);
           mail.setSenderDisplayName('System Admin');
           mail.setTemplateId(et.id);
           Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail }); 
        }
 	}
}