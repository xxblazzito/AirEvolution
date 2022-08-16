@isTest
public class BatchableSemanaAntesVueloTest {
	@TestSetup
    static void makeData(){
        List<Product2> vuelos = new List<Product2>();
        for(integer i = 0; i < 50; i++){
            vuelos.add(new Product2(Name  = 'a'+i, IsActive = true, Fecha_y_hora_de_partida__c = DateTime.now().addDays(2), Estado__c = 'En Venta'));
        }

        insert vuelos;
    }

    @IsTest
    static void methodName(){ 
        Test.startTest();
        try{
            BatchableSemanaAntesVuelo batchClass = new BatchableSemanaAntesVuelo(); 
        	ID batchprocessid = Database.executeBatch(batchClass);
        }catch(exception e){
            system.assert(false, e.getMessage().Contains('se ha producido un error '));
        } 
        Test.stopTest();
        
        
    }
}