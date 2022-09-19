public with sharing class Clima {
    public static List<Clima__c> crearClimaLlegada(List<product2> vuelos){
           
        List<clima__c> listaClimas = new List<clima__c>();
        Datetime modificacion = Datetime.now();
        try{
            for(product2 vuelo: vuelos){
                if(vuelo.Fecha_y_hora_de_partida__c <= modificacion && (vuelo.Estado__c == 'En Venta' || vuelo.Estado__c == 'Check In' || vuelo.Estado__c == 'En Vuelo')){
                    string Latitud = string.valueOf(vuelo.Aeropuerto_de_llegada__r.Ubicacion__Latitude__s);
                    string Longitude = string.valueOf(vuelo.Aeropuerto_de_llegada__r.Ubicacion__Longitude__s);
                    Decimal Temperatura = ObtenerClima.getClima(Latitud, Longitude);
                    Clima__c clima = new Clima__c(Aeropuerto__c = vuelo.Aeropuerto_de_llegada__c,Fecha_y_Hora__c  = DateTime.now(),Unidad__c = 'Centigrados',Temperatura__c = Temperatura);
                    listaClimas.add(clima);
                }   
            }
            return listaClimas;
        }catch(exception e){
            throw new MyException(e);
        }
    }

    public static List<Clima__c> crearClimaPartida(List<product2> vuelos){
           
        List<clima__c> listaClimas = new List<clima__c>();
        Datetime modificacion = Datetime.now();
        try{
            for(product2 vuelo: vuelos){
                if(vuelo.Fecha_y_hora_de_partida__c >= modificacion && (vuelo.Estado__c == 'En Venta' || vuelo.Estado__c == 'Check In')){
                    string Latitud = string.valueOf(vuelo.Aeropuerto_de_Partida__r.Ubicacion__Latitude__s);
                    string Longitude = string.valueOf(vuelo.Aeropuerto_de_Partida__r.Ubicacion__Longitude__s);
                    Decimal Temperatura = ObtenerClima.getClima(Latitud, Longitude);
                    Clima__c clima = new Clima__c(Aeropuerto__c = vuelo.Aeropuerto_de_Partida__c,Fecha_y_Hora__c  = DateTime.now(),Unidad__c = 'Centigrados',Temperatura__c = Temperatura);
                    listaClimas.add(clima);
                }   
            }
            return listaClimas;
        }catch(exception e){
            throw new MyException(e);
        }
    }

    public class MyException extends Exception {}
}