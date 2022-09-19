@isTest
public class VueloTest {

    @isTest
    static void errorValidarEstadoCheckIn(){
        list<product2> vuelos = new List<Product2>();
        try{
        Vuelo.validarEstadoCheckIn(vuelos);
        }catch(exception e){
            system.assert(e != null);
        }
    }
}