@isTest
public class BatchableDiaAntesVueloTest {

    @testSetup
    static void makeData(){
        string pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
            Id = pricebookId,
            IsActive = true
        );
        update standardPricebook;
        
        Pricebook2 turista = new Pricebook2(Name = 'Turista',IsActive = true);
        insert turista;
        
        Pricebook2 negocio = new Pricebook2(Name = 'Negocio',IsActive = true);
        insert negocio;
        
        Avion__c avion = new Avion__c (Numero_de_pasajeros_clase_negocios__c = 10,Numero_de_pasajeros_clase_turista__c = 10, Tipo__c ='pitovolador 1424');
        insert avion;
        
        list<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        for(integer i = 0 ; i < 2; i++){
            Aeropuerto__c aeropuerto = new Aeropuerto__c(Name='aeropuerto'+i , Pais__c = 'Colombia', Ciudad__c = 'Antioquia');
            aeropuertos.add(aeropuerto);
        }
        insert aeropuertos;
        
        product2 vuelo = new product2(Name = 'ae56', Aeropuerto_de_partida__c =aeropuertos[0].id, Aeropuerto_de_llegada__c = aeropuertos[1].id,Estado__c = 'En Venta',IsActive = true,
                                      Fecha_y_hora_de_partida__c = Date.newInstance(2022, 08, 19),Avion__c = avion.Id,
                                      Fecha_y_hora_estimada_de_llegada__c = Date.newInstance(2022, 08, 23));
        insert vuelo;
    }
    
    @isTest
    private static void descuentoSinOtroDescuento(){
        Pricebook2 turista = [select id from Pricebook2 where Name = 'Turista' Limit 1];
        
        
        string pricebookId = Test.getStandardPricebookId();
        
        Product2 vuelo = [select id from product2 limit 1];
        
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = pricebookId,UnitPrice=100000,Product2Id=vuelo.Id,IsActive = true, Descuento_Martes__c = false);
        insert entrada;
        
        PricebookEntry turisteando = new PricebookEntry(Pricebook2Id = turista.Id, UnitPrice=100000,Product2Id=vuelo.Id, IsActive = true, Descuento_Martes__c = false);
        insert turisteando;
        
        integer dia = Date.today().addDays(1).day();
        string cronExpresion = '2022-08-'+dia+' 00:00:00';
        
        Test.startTest();
        schedulableDiaAntesVuelo m = new schedulableDiaAntesVuelo();
        String sch = '0 0 0 * * ? *';
        String jobID = system.schedule('Test Programado', sch, m);
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                         	FROM CronTrigger WHERE id =: jobID];
        
        system.assertEquals(sch, ct.CronExpression);
        
        system.assertEquals(0, ct.TimesTriggered);
        
        system.assertEquals(cronExpresion,String.valueOf(ct.NextFireTime));
        
        BatchableDiaAntesVuelo batchClass = new BatchableDiaAntesVuelo(); 
        ID batchprocessid = Database.executeBatch(batchClass) ;
        Test.stopTest();
        
        PricebookEntry precio = [Select UnitPrice from PricebookEntry Where Pricebook2Id =: turista.Id Limit 1];
        system.assertEquals(50000, precio.UnitPrice);
    }
}