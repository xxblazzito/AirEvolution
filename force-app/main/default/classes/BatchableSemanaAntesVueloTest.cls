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
    static void batchableSemanaAntes(){ 
        Test.startTest();
        try{
            BatchableSemanaAntesVuelo batchClass = new BatchableSemanaAntesVuelo(); 
        	ID batchprocessid = Database.executeBatch(batchClass);
        }catch(exception e){
            system.assert(false, e.getMessage().Contains('se ha producido un error '));
        } 
        Test.stopTest();
    }
    
    @IsTest
    static void schedulableSemanaAntes(){
        integer dia = Date.today().addDays(1).day();
        string cronExpresion = '2022-08-'+dia+' 00:00:00';
        
        Test.startTest();
        schedulableSemanaAntesVuelo m = new schedulableSemanaAntesVuelo();
        String sch = '0 0 0 * * ? *';
        String jobID = system.schedule('Test Programado', sch, m);
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                         	FROM CronTrigger WHERE id =: jobID];
        
        system.assertEquals(sch, ct.CronExpression);
        
        system.assertEquals(0, ct.TimesTriggered);
        
        system.assertEquals(cronExpresion,String.valueOf(ct.NextFireTime));
        
        Test.stopTest();
    }
}