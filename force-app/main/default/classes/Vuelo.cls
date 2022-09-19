public with sharing class Vuelo {
    
    public static List<product2> cambiarEstadoDeVuelo(list<product2> vuelos){
        
        list<Product2> listaVuelos = new List<Product2>();
        Datetime modificacion = Datetime.now();
        try{
            for(product2 vuelo: vuelos){
                if(vuelo.Fecha_y_hora_estimada_de_llegada__c <= modificacion && vuelo.Fecha_y_hora_de_partida__c <= modificacion && (vuelo.Estado__c == 'En Venta' || vuelo.Estado__c == 'Check In' || vuelo.Estado__c == 'En Vuelo')){
                    product2 vueloActualizado = new product2();
                    vueloActualizado.Id = vuelo.Id;
                    vueloActualizado.Estado__c = 'Terminado';
                    vueloActualizado.IsActive = false;
                    listaVuelos.add(vueloActualizado);
                }
                if(vuelo.Fecha_y_hora_de_partida__c <= modificacion && vuelo.Fecha_y_hora_estimada_de_llegada__c >= modificacion && (vuelo.Estado__c == 'En Venta' || vuelo.Estado__c == 'Check In')){
                    product2 vueloActualizado = new product2();
                    vueloActualizado.Id = vuelo.Id;
                    vueloActualizado.Estado__c = 'En Vuelo';
                    listaVuelos.add(vueloActualizado);
                }   
            }
            return listaVuelos;
        }catch(exception e){
            throw new MyException(e);
        }
    }

    public static void validarEstadoCheckIn(List<Product2> vuelos){
        List<Product2> vuelosActualizables = new List<Product2>();
        try{
            for(Product2 vuelo: Vuelos){
                double fechaPartida = vuelo.Fecha_y_hora_de_partida__c.getTime();
                double actual = DateTime.now().getTime();
                double milliseconds = fechaPartida - actual;
                double seconds = milliseconds / 1000;
                double minutes = seconds / 60;
                double hours = minutes / 60;
                
                if(hours <= 24){
                    Product2 vueloActualizado = new Product2();
                    vueloActualizado = vuelo;
                    vueloActualizado.Estado__c = 'Check In';
                    vuelosActualizables.add(vueloActualizado);
                }
            }
    
            List<Clima__c> climasVuelos =Clima.crearClimaPartida(vuelosActualizables);
    
            insert climasVuelos;
            
            update vuelosActualizables;
    
            EntradaListaPrecios.aplicarDescuentoCincuenta(vuelosActualizables);
            tiquete.enviarCorreoCheckIn(vuelosActualizables);
        }catch(exception e){
            throw new MyException(e);
        }
    }

    public class MyException extends Exception {}
}