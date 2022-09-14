@isTest
public class TiquetesDeReservaTest {
    
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
        
        Contact contactoConReserva = new Contact (firstName = 'cristian', lastName = 'aguirre', Tipo_de_Identificacion__c = 'Cedula de Ciudadania', 
                                                  Numero_de_Identificacion__c= '1040758632', Nacionalidad__c = 'colombiano', ffecha_de_nacimiento__c = Date.newInstance(1999, 05, 09) );
        insert contactoConReserva;
        
        Contact contactoSinReserva = new Contact (firstName = 'pablito', lastName = 'josefino', Tipo_de_Identificacion__c = 'Cedula de Ciudadania',
                                                  Numero_de_Identificacion__c= '99050903482', Nacionalidad__c = 'colombiano', ffecha_de_nacimiento__c = Date.newInstance(1999, 05, 09) );
        insert contactoSinReserva;
        
        Opportunity reservaContacto = new Opportunity (Titular_de_la_reserva__c= contactoConReserva.Id,Name = 'a',CloseDate = Date.today().addDays(1),StageName = 'Pre-venta',
                                                       Pricebook2Id = turista.Id );
        insert reservaContacto;
        
        List<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>(); 
        aeropuertos.add(new Aeropuerto__c(Name = 'Aeropuerto Cristian Aguirre'
                                          , Codigo_IATA__c = 'ACA', Pais__c ='Colombia',
                                          Ciudad__c = 'Antioquia', Ubicacion__Latitude__s = 38.953326, 
                                          Ubicacion__Longitude__s = -1.862513));
        aeropuertos.add(new Aeropuerto__c(Name = 'Aeropuerto Josefina Aguirre'
                                          , Codigo_IATA__c = 'ACU', Pais__c ='Colombia',
                                          Ubicacion__Latitude__s = 38.953326, 
                                          Ubicacion__Longitude__s = -1.862513,
                                          Ciudad__c = 'Cali'));
        insert aeropuertos;
        
        Date date1 = Date.today().addDays(1);
        Date date2 = Date.today().addDays(2);
        DateTime fPartida = DateTime.newInstance(date1.year(), date1.month(), date1.day());
        DateTime fLlegada = DateTime.newInstance(date2.year(), date2.month(), date2.day());
        
        Product2 vuelo = new Product2(IsActive = true,Aeropuerto_de_llegada__c = aeropuertos[0].Id,
                                      Aeropuerto_de_partida__c = aeropuertos[1].Id, Estado__c = 'En Venta',
                                      Fecha_y_hora_de_partida__c = fPartida, Fecha_y_hora_estimada_de_llegada__c = fLlegada,
                                      Name = 'aa', Avion__c = avion.Id);
        Insert vuelo;
        
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = pricebookId,UnitPrice=5000,Product2Id=vuelo.Id,IsActive = true);
        insert entrada;
        
        PricebookEntry turisteando = new PricebookEntry(Pricebook2Id = turista.Id, UnitPrice=5000,Product2Id=vuelo.Id, IsActive = true);
        insert turisteando;
        
        OpportunityLineItem nuevoTiquete = new OpportunityLineItem(Pasajero__c = contactoConReserva.Id, OpportunityId = reservaContacto.Id, Product2Id = vuelo.Id);
        insert nuevoTiquete;
    } 
    
    @isTest
    private static void listaVueloAndTiquetes(){
        Opportunity reserva = [select id from Opportunity limit 1];
        //PageReference pageRef = Page.TiquetesReserva; 
        //Test.setCurrentPage(pageRef);
        //pageRef.getParameters().put('recordId',reserva.Id);
        //TiquetesDeReserva controlador = new TiquetesDeReserva(pageRef.);
        
        PageReference pageRef = Page.TiquetesReserva;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('recordId',reserva.Id);
        ApexPages.StandardController stc = new ApexPages.StandardController(reserva);
        TiquetesDeReserva controlador = new TiquetesDeReserva(stc);
        List<Product2> listaVuelo = controlador.vueloInfo;
        List<OpportunityLineItem> tiquetes = controlador.lineItems;
        
        System.assert(listaVuelo != null);
        system.assert(tiquetes != null);
    }
}