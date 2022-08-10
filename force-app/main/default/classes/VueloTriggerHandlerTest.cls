@isTest
public class VueloTriggerHandlerTest {

   @TestSetup
    static void makeData(){
        List<Product2> vuelos = new List<Product2>();
        for(integer i=0 ; i < 50 ; i++){
            
            Product2 vuelo = new Product2(Name = 'a', IsActive = true,Fecha_y_hora_de_partida__c= DateTime.newInstance(2022, 08, 18, 3, 3, 3),
                                          Fecha_y_hora_estimada_de_llegada__c=DateTime.newInstance(2022, 08, 20, 3, 3, 3),Estado__c = 'En Venta');
            vuelos.add(vuelo);
        }
        insert vuelos;
    }
    
    @isTest
    private static void cancelarSinMotivo(){
        try{
            List<Product2> vuelitos = [Select Id,Name, Estado__c From Product2];
            for(Product2 v: vuelitos){
                v.Estado__c = 'Cancelado';
            }
            update vuelitos;
        }catch(exception e){
            system.assert(e.getMessage().contains('Debe agregar un motivo de cancelación'));
        }
        
    }
    
    @isTest
    private static void cancelarConMotivo(){
        
        List<Product2> vuelitos = [Select Id,Name, Estado__c, Motivo_de_cancelacion__c From Product2];
        for(Product2 v: vuelitos){
            v.Estado__c = 'Cancelado';
            v.Motivo_de_cancelacion__c ='Sobreventa';
        }
        update vuelitos;
        
        List<Product2> vuelitosActualizados = [Select Id From Product2 Where Motivo_de_cancelacion__c != null ];
        system.assertEquals(50, vuelitosActualizados.size());
        
        
    }
}