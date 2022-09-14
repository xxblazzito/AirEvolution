public with sharing class Vuelo {
    
    public static List<product2> cambiarEstadoEnVuelo(list<product2> vuelos){
        
        list<Product2> listaVuelos = new List<Product2>();
        Datetime modificacion = Datetime.now();
        try{
            for(product2 vuelo: vuelos){
                if(vuelo.Fecha_y_hora_de_partida__c <= modificacion && (vuelo.Estado__c == 'En Venta' || vuelo.Estado__c == 'Check In')){
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

    public class MyException extends Exception {}
}
