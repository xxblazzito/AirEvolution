public with sharing class asientos {
    
    @AuraEnabled(cacheable = true)
    public static infoAsiento listarAsientos(string idTiquete){
        list<Pricebook2> listasPrecios = [select id, name from pricebook2 ];

        string idTurista;
        string idNegocios;
        string tipo;
        

        for (pricebook2 precio : listasPrecios){
            if(precio.name == 'Turista'){
                idTurista = precio.Id;
            }
            if(precio.name == 'Negocio'){
                idNegocios = precio.Id;
            }
        }
        infoAsiento info;

        OpportunityLineItem tiquete = [select id, name, opportunityId, product2Id, asientoReal__c, Pasajero__c from OpportunityLineItem where Id =: idTiquete limit 1];


        Opportunity reserva = [select id, name, Pricebook2Id from Opportunity where Id =: tiquete.opportunityId limit 1];

        if(reserva.Pricebook2Id == idTurista){
            tipo = 'Turista';
        }
        if(reserva.Pricebook2Id == idNegocios){
            tipo = 'Negocio';
        }

        Product2 vuelo = [select id, Avion__c from product2 where Id =: tiquete.product2Id limit 1];

        if( tiquete.asientoReal__c == null ){
            List<Asiento__c> asientos = [select id,Name, tipo__c, Avion__c from Asiento__c where Pasajero__c = null AND Avion__c =: vuelo.Avion__c AND Tipo__c =: tipo];
            info = new infoAsiento(false, null , asientos);

        }else{
            Asiento__c asiento = [select id, Name, Tipo__c, Avion__c from Asiento__c where Avion__c =: vuelo.Avion__c AND pasajero__c =: tiquete.Pasajero__c];
            info = new infoAsiento(true, asiento, null);

        }

        

        return info;

    }

    @AuraEnabled
    public static boolean asignarAsiento(string idTiquete, string idAsiento){
        OpportunityLineItem tiquete = [select id, name, opportunityId,Pasajero__c, product2Id, asientoReal__c from OpportunityLineItem where Id =: idTiquete limit 1];
        List<Sobject> datos = new List<Sobject>();

        OpportunityLineItem tiqueteActualizable = new OpportunityLineItem(id = idTiquete, asientoReal__c = idAsiento);

        Asiento__c asientoActualizable = new Asiento__c(id = idAsiento, Pasajero__c = tiquete.pasajero__c);

        datos.add(tiqueteActualizable);
        datos.add(asientoActualizable);

        
        try{
            update datos;
            return true;
        }catch(exception e){
            return false;
        }
    }

    public class infoAsiento{
        @auraEnabled 
        public Boolean asignado;
        @auraEnabled 
        public Sobject asiento;
        @auraEnabled 
        public List<Sobject> disponibles;
        
        public infoAsiento(boolean tiene, SObject puesto, List<Sobject> listado){
            asignado = tiene;
            asiento = puesto;
            disponibles = listado;
        }
    }
}
