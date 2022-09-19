@isTest
public class SchedulableCadaHoraTest {

    @testSetup
    static void makeData(){
        
        Avion__c avion = new Avion__c (Numero_de_pasajeros_clase_negocios__c = 10,Numero_de_pasajeros_clase_turista__c = 10, Tipo__c ='pitovolador 1424');
        insert avion;
        
        list<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        for(integer i = 0 ; i < 2; i++){
            Aeropuerto__c aeropuerto = new Aeropuerto__c(Name='aeropuerto'+i , Pais__c = 'Colombia', Ciudad__c = 'Antioquia', Ubicacion__latitude__s = 	6.243499 ,Ubicacion__longitude__s =	-75.579226 );
            aeropuertos.add(aeropuerto);
        }
        insert aeropuertos;
        
        list<product2> vuelos = new List<Product2>();
        for(integer i = 0 ; i<20; i++){
            if(i <10){
                Date fechaPartida = date.today().addDays(-3);
                Date fechaLlegada = date.today().addDays(-2); 
                product2 vuelo = new product2(Name = 'ae56'+i, Aeropuerto_de_partida__c =aeropuertos[0].id, Aeropuerto_de_llegada__c = aeropuertos[1].id,Estado__c = 'En Venta',IsActive = true,
                                              Fecha_y_hora_de_partida__c = fechaPartida ,Avion__c = avion.Id,Fecha_y_hora_estimada_de_llegada__c = fechaLlegada);
                vuelos.add(vuelo);
            }else{
                Date fechaPartida = date.today().addDays(-1);
                Date fechaLlegada = date.today().addDays(1); 
                product2 vuelo = new product2(Name = 'ae56'+i, Aeropuerto_de_partida__c =aeropuertos[0].id, Aeropuerto_de_llegada__c = aeropuertos[1].id,Estado__c = 'En Venta',IsActive = true,
                                              Fecha_y_hora_de_partida__c = fechaPartida ,Avion__c = avion.Id,Fecha_y_hora_estimada_de_llegada__c = fechaLlegada);
                vuelos.add(vuelo);
            }
            
        }
        insert vuelos;
    }
    
    @isTest
    static void validarEstadoVuelo(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetClimaResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        
        SchedulableCadaHora m = new SchedulableCadaHora();
        String sch = '0 0 * * * ?'; 
        
        Test.startTest();
        
        String jobID = system.schedule('Schedulable (cada hora) TEST', sch, m);
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        DateTime actual = datetime.now().addhours(1);
        
        System.assertEquals(sch, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        FutureCadaHora.validarVuelos();
        
    	//FutureCadaHora.validarReservaPagada();
        
        Test.stopTest();
        
        List<Product2> vuelosEnVuelo = [select Id From Product2 where Estado__c = 'En Vuelo'];
        system.assertEquals(10, vuelosEnVuelo.size());
        
        List<Product2> vuelosTerminados = [select Id From Product2 where Estado__c = 'Terminado'];
        system.assertEquals(10, vuelosEnVuelo.size());
        
        List<Clima__c> climas = [select id from Clima__c];
        system.assertEquals(20, climas.size());
    }
}