public with sharing class FutureCadaHora {

    @future(callout= true) 
    public static void validarVuelos() {
        try{
            List<Product2> vuelos = [Select id, Estado__c, Fecha_y_hora_de_partida__c, Fecha_y_hora_estimada_de_llegada__c,Aeropuerto_de_Partida__r.Id,
            Aeropuerto_de_Partida__r.Ubicacion__Longitude__s,Aeropuerto_de_Partida__r.Ubicacion__Latitude__s, Aeropuerto_de_llegada__r.Id,
            Aeropuerto_de_llegada__r.Ubicacion__Longitude__s,Aeropuerto_de_llegada__r.Ubicacion__Latitude__s from product2 where IsActive = true]; 
    
            List<Product2> vuelosEnVuelo = Vuelo.cambiarEstadoDeVuelo(vuelos);
            List<Clima__c> climasVuelos = Clima.crearClimaLlegada(vuelos);
    
    
            insert climasVuelos;
            update vuelosEnVuelo;
        }catch(exception e){
            throw new MyException(e);
        }
        
    }

    @future(callout= true) 
    public static void validarReservaPagada() {

        try{
            List<Opportunity> reservas = [Select Id, StageName, LastModifiedDate FROM Opportunity Where StageName IN ('	Pre-venta','Completado') ];

            reserva.cancelarReservaNoPagada(reservas);
        }catch(exception e){
            throw new MyException(e);
        }
       
    }

    public class MyException extends Exception {}
}
