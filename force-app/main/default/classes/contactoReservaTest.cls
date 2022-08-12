@istest
public class contactoReservaTest {
	
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
        
        Contact contactoSinReserva = new Contact (firstName = 'pablito', lastName = 'josefino', Tipo_de_Identificacion__c = 'Cedula de Ciudadania',
                                                  Numero_de_Identificacion__c= '99050903482', Nacionalidad__c = 'colombiano', ffecha_de_nacimiento__c = Date.newInstance(1999, 05, 09) );
        insert contactoSinReserva;
        
        Pricebook2 listaPrecios2 = new Pricebook2(Name = 'Turista');
        insert listaPrecios2;
                           
        Contact contactoConReserva = new Contact (firstName = 'cristian', lastName = 'aguirre', Tipo_de_Identificacion__c = 'Cedula de Ciudadania', 
                                                  Numero_de_Identificacion__c= '1040758632', Nacionalidad__c = 'colombiano', ffecha_de_nacimiento__c = Date.newInstance(1999, 05, 09) );
        insert contactoConReserva;
                           
        Opportunity reservaContacto = new Opportunity (Titular_de_la_reserva__c= contactoConReserva.Id,Name = 'a',CloseDate = Date.today().addDays(1),StageName = 'Pre-venta',
                                                       Pricebook2Id = turista.Id );
        insert reservaContacto;
        
        list<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        for(integer i = 0 ; i < 2; i++){
            Aeropuerto__c aeropuerto = new Aeropuerto__c(Name='aeropuerto'+i , Pais__c = 'Colombia', Ciudad__c = 'Antioquia');
            aeropuertos.add(aeropuerto);
        }
        insert aeropuertos;
        
        product2 vuelo = new product2(Name = 'ae56', Aeropuerto_de_partida__c =aeropuertos[0].id, Aeropuerto_de_llegada__c = aeropuertos[1].id,Estado__c = 'En Venta',IsActive = true,
                                      Fecha_y_hora_de_partida__c = Date.newInstance(2022, 08, 22),Avion__c = avion.Id,
                                      Fecha_y_hora_estimada_de_llegada__c = Date.newInstance(2022, 08, 23));
        insert vuelo;
        
        
        
        
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = pricebookId,UnitPrice=5000,Product2Id=vuelo.Id,IsActive = true);
        insert entrada;
        
        PricebookEntry turisteando = new PricebookEntry(Pricebook2Id = turista.Id, UnitPrice=5000,Product2Id=vuelo.Id, IsActive = true);
        insert turisteando;
    }
    
    @isTest
    private static void contactoNoExiste(){
        
        system.assertEquals(null, contactoReserva.clienteReserva('Cedula de Ciudadania', '101010').contacto);
        system.assertEquals(null, contactoReserva.clienteReserva('Cedula de Ciudadania', '101010').oportunidad);
    }
    
    @isTest
    private static void contactoSinReserva(){
        
        system.assert(contactoReserva.clienteReserva('Cedula de Ciudadania', '99050903482').contacto.Name.contains('pablito'));
        system.assertEquals(null, contactoReserva.clienteReserva('Cedula de Ciudadania', '99050903482').oportunidad);
    }
    
    @isTest
    private static void contactoConReserva(){
        
        system.assert(contactoReserva.clienteReserva('Cedula de Ciudadania', '1040758632').contacto.Name.contains('cristian'));
        system.assert(contactoReserva.clienteReserva('Cedula de Ciudadania', '1040758632').oportunidad.StageName.contains('Pre-venta'));
    }
    
    @isTest
    private static void contactoInfoMala(){
        
        system.assertEquals(null, contactoReserva.clienteReserva('Cedula de Ciudad', '101010').contacto);
        system.assertEquals(null, contactoReserva.clienteReserva('Cedula de Ciudad', '101010').oportunidad);
    }
    
    @isTest
    private static void crearReserva(){
		Contact contacto = [Select id From Contact Where Numero_de_Identificacion__c = '99050903482' LIMIT 1];
        contactoReserva.crearReserva(contacto.Id, 'Turista');
        List<Opportunity> reserva = [Select id From Opportunity Where Titular_de_la_reserva__c =: contacto.Id];
        system.assertEquals(1, reserva.size());
    }
    
    @isTest
    private static void listarVuelo(){
        pricebook2 turista = [select id from pricebook2 where Name = 'Turista' Limit 1];
        string id = turista.Id;
        system.assertEquals(1, contactoReserva.obtenerVuelos(id).size());
    }
    
    @isTest
    private static void crearTiquetes(){
        product2 vuelo = new product2(Name = 'ae56',Estado__c = 'En Venta',IsActive = true,Fecha_y_hora_de_partida__c = Date.newInstance(2022, 08, 22),
                                       Fecha_y_hora_estimada_de_llegada__c = Date.newInstance(2022, 08, 23));
        insert vuelo;
        List<product2> vuelo1 = [select id from Product2];
        List<string> idVuelos = new list<string>();
        for (Product2 a: vuelo1){
            idVuelos.add(a.Id);
        }
        string pricebookId = Test.getStandardPricebookId();
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = pricebookId,UnitPrice=5000,Product2Id=vuelo.Id,IsActive = true);
        insert entrada;
        pricebook2 listaTurista = [select id from pricebook2 where name = 'Turista' Limit 1];
        PricebookEntry turisteando = new PricebookEntry(Pricebook2Id = listaTurista.Id, UnitPrice=5000,Product2Id=vuelo.Id, IsActive = true);
        insert turisteando;
        Opportunity reserva = [select id from Opportunity Limit 1];
        String idReserva = reserva.Id;
        Contact contacto = [select id from Contact where Numero_de_Identificacion__c = '1040758632' Limit 1];
        String idContacto = contacto.Id;
        contactoReserva.crearTiquete(idReserva, idVuelos, idContacto);
        List<OpportunityLineItem> tiquetes = [Select id From OpportunityLineItem];
        system.assertEquals(2, tiquetes.size());
        
    }
    
    @isTest
    private static void obtenerPasajero(){
        List<product2> vuelo1 = [select id from Product2];
        List<string> idVuelos = new list<string>();
        for (Product2 a: vuelo1){
            idVuelos.add(a.Id);
        }
        pricebook2 listaTurista = [select id from pricebook2 where name = 'Turista' Limit 1];
        Opportunity reserva = [select id from Opportunity Limit 1];
        String idReserva = reserva.Id;
        Contact contacto = [select id from Contact where Numero_de_Identificacion__c = '1040758632' Limit 1];
        String idContacto = contacto.Id;
        Contact contactoPasajero = [select id from Contact where Numero_de_Identificacion__c = '99050903482' Limit 1];
        String idContactoPasajero = contactoPasajero.Id;
        contactoReserva.crearTiquete(idReserva, idVuelos, idContacto);
        contactoReserva.crearTiquete(idReserva, idVuelos, idContactoPasajero);
        List<OpportunityLineItem> listaPasajeros = contactoReserva.obtenerPasajeros(idReserva, idContacto);
        system.assertEquals(1, listaPasajeros.size());
        
    }
    
    @isTest
    private static void reservaMala(){
        try{
            string id = null;
        	contactoReserva.crearReserva(id, 'Turista');
        }catch(exception e){
            system.assertEquals(null, e.getMessage());
        }
    }
    
    @isTest
    private static void tiqueteMalo(){
        try{
            contactoReserva.crearTiquete(null, null, null);
        }catch(exception e){
            system.assert(e.getMessage().contains('se ha producido un error'));
        }
    }
}