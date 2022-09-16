public with sharing class FutureDiaAntes {
    
    @future(callout= true) 
    public static void validarVuelos() {
        try{
            List<Product2> vuelos = [Select id, Estado__c, Fecha_y_hora_de_partida__c, Fecha_y_hora_estimada_de_llegada__c,Aeropuerto_de_Partida__r.Id,
            Aeropuerto_de_Partida__r.Ubicacion__Longitude__s,Aeropuerto_de_Partida__r.Ubicacion__Latitude__s, Aeropuerto_de_llegada__r.Id,
            Aeropuerto_de_llegada__r.Ubicacion__Longitude__s,Aeropuerto_de_llegada__r.Ubicacion__Latitude__s from product2 where IsActive = true]; 
    
            Vuelo.validarEstadoCheckIn(vuelos);
        }catch(exception e){
            throw new MyException(e);
        }
        
    }

    public class MyException extends Exception {}
}
