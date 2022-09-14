public class BatchableEstadoVuelo implements Database.Batchable<sObject>, Database.AllowsCallouts {
    public Database.QueryLocator start(Database.BatchableContext BC){
        DateTime modificacionPasado = DateTime.now().addHours(-4);
        Datetime modificacionPresente = Datetime.now();
        return Database.getQueryLocator('select id, Estado__c, Fecha_y_hora_de_partida__c, Fecha_y_hora_estimada_de_llegada__c, Aeropuerto_de_llegada__r.Id, Aeropuerto_de_llegada__r.Ubicacion__Longitude__s,Aeropuerto_de_llegada__r.Ubicacion__Latitude__s from product2');
    }
    
    public void execute(Database.BatchableContext BC, List<Product2> vuelos){
        Datetime modificacion = Datetime.now();
        Set<Id> idVuelos = new Set<Id>();
        list<Product2> listaVuelos = new List<Product2>();
        List<clima__c> listaClimas = new List<clima__c>();
        try {
            for(product2 vuelo: vuelos){
                if(vuelo.Fecha_y_hora_de_partida__c <= modificacion && (vuelo.Estado__c == 'En Venta' || vuelo.Estado__c == 'Check In')){
                    string Latitud = string.valueOf(vuelo.Aeropuerto_de_llegada__r.Ubicacion__Latitude__s);
                    string Longitude = string.valueOf(vuelo.Aeropuerto_de_llegada__r.Ubicacion__Longitude__s);
                    Decimal Temperatura = ObtenerClima.getClima(Latitud, Longitude);
                    Clima__c clima = new Clima__c(Aeropuerto__c = vuelo.Aeropuerto_de_llegada__c,Fecha_y_Hora__c  = DateTime.now(),Unidad__c = 'Centigrados',Temperatura__c = Temperatura);
                    listaClimas.add(clima);
                    product2 vueloActualizado = new product2();
                    vueloActualizado.Id = vuelo.Id;
                    vueloActualizado.Estado__c = 'En Vuelo';
                    listaVuelos.add(vueloActualizado);
                }   
            }
            update listaVuelos;
            insert listaClimas;
        } catch (Exception e) {
            System.debug(e);
        }
        
    }
    
    public void finish(Database.BatchableContext BC){
        // notificar acerca del proceso
    }
}