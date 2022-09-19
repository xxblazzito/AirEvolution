@isTest
public class SchedulableCadaDiaTest {
    
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
            Aeropuerto__c aeropuerto = new Aeropuerto__c(Name='aeropuerto'+i , Pais__c = 'Colombia', Ciudad__c = 'Antioquia', Ubicacion__latitude__s = 	6.243499 ,Ubicacion__longitude__s =	-75.579226 );
            aeropuertos.add(aeropuerto);
        }
        insert aeropuertos;
        
        list<product2> vuelos = new List<Product2>();
        for(integer i = 0 ; i<15; i++){
            if(i <10){
                Date fechaPartida = date.today().addDays(1);
                Date fechaLlegada = date.today().addDays(2); 
                product2 vuelo = new product2(Name = 'ae56'+i, Aeropuerto_de_partida__c =aeropuertos[0].id, Aeropuerto_de_llegada__c = aeropuertos[1].id,Estado__c = 'En Venta',IsActive = true,
                                              Fecha_y_hora_de_partida__c = fechaPartida ,Avion__c = avion.Id,Fecha_y_hora_estimada_de_llegada__c = fechaLlegada);
                vuelos.add(vuelo);
            }else{
                Date fechaPartida = date.today().addDays(5);
                Date fechaLlegada = date.today().addDays(6); 
                product2 vuelo = new product2(Name = 'ae56'+i, Aeropuerto_de_partida__c =aeropuertos[0].id, Aeropuerto_de_llegada__c = aeropuertos[1].id,Estado__c = 'En Venta',IsActive = true,
                                              Fecha_y_hora_de_partida__c = fechaPartida ,Avion__c = avion.Id,Fecha_y_hora_estimada_de_llegada__c = fechaLlegada);
                vuelos.add(vuelo);
            }
            
        }
        insert vuelos;
        
        list<pricebookEntry> EntradaListaPreciosEstandar = new List<PricebookEntry>();
        list<pricebookEntry> EntradaListaPreciosTuristaYNegocio = new List<PricebookEntry>();
        for(product2 vuelo: vuelos){
            pricebookEntry precioestandard = new PricebookEntry(isActive = true, Pricebook2Id = pricebookId, unitprice = 100, product2Id = vuelo.Id );
            EntradaListaPreciosEstandar.add(precioestandard);
            
            pricebookEntry precioTurista = new PricebookEntry(isActive = true, Pricebook2Id = turista.Id, unitprice = 100, product2Id = vuelo.Id );
            pricebookEntry precioNegocio = new PricebookEntry(isActive = true, Pricebook2Id = negocio.Id, unitprice = 100, product2Id = vuelo.Id ,	Descuento_Martes__c = true);
            
            EntradaListaPreciosTuristaYNegocio.add(precioTurista);
            EntradaListaPreciosTuristaYNegocio.add(precioNegocio);
        }
        insert EntradaListaPreciosEstandar;
        insert EntradaListaPreciosTuristaYNegocio;
    }
    
    @isTest
    static void programarCadaDia(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetClimaResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        
        SchedulableCadaDia m = new SchedulableCadaDia();
        String sch = '0 0 * * * ?'; 
        
        Test.startTest();
        
        String jobID = system.schedule('Schedulable (cada dia) TEST', sch, m);
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        DateTime actual = datetime.now().addhours(1);
        
        System.assertEquals(sch, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        FutureDiaAntes.validarVuelos();
        
        Test.stopTest();
        
        //CronTrigger cronTrigger_after = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
		//System.assertEquals(1, cronTrigger_after.TimesTriggered);
        
        List<Product2> vuelosARevisar = [select id, Estado__c from Product2 where Estado__c = 'check In'];
        system.assertEquals(10, vuelosARevisar.size());
        
        List<Clima__c> climas = [select id from Clima__c];
        system.assertEquals(10, climas.size());
        
        List<PricebookEntry> precios = [select id from PricebookEntry where Descuento_Por_Vencer__c = true];
        system.assertEquals(30, precios.size());
    }
}