@isTest
public class TiqueteTriggerHandlerTest {

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
        
        Avion__c avion = new Avion__c (Numero_de_pasajeros_clase_negocios__c = 2,Numero_de_pasajeros_clase_turista__c = 2, Tipo__c ='pitovolador 1424');
        insert avion;
        
        Contact contactoSinReserva = new Contact (firstName = 'pablito', lastName = 'josefino', Tipo_de_Identificacion__c = 'Cedula de Ciudadania',
                                                  Numero_de_Identificacion__c= '99050903482', Nacionalidad__c = 'colombiano', ffecha_de_nacimiento__c = Date.newInstance(1999, 05, 09) );
        insert contactoSinReserva;
                           
        Contact contactoConReserva = new Contact (firstName = 'cristian', lastName = 'aguirre', Tipo_de_Identificacion__c = 'Cedula de Ciudadania', 
                                                  Numero_de_Identificacion__c= '1040758632', Nacionalidad__c = 'colombiano', ffecha_de_nacimiento__c = Date.newInstance(1999, 05, 09) );
        insert contactoConReserva;
                           
        Opportunity reservaContacto = new Opportunity (Titular_de_la_reserva__c= contactoConReserva.Id,Name = 'a',CloseDate = Date.today().addDays(1),StageName = 'Pre-venta',
                                                       Pricebook2Id = turista.Id );
        insert reservaContacto;
        
        list<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        for(integer i = 0 ; i < 2; i++){
            Aeropuerto__c aeropuerto = new Aeropuerto__c(Name='aeropuerto'+i , Pais__c = 'Colombia', Ciudad__c = 'Antioquia',  Ubicacion__latitude__s = 	6.243499 ,Ubicacion__longitude__s =	-75.579226);
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
    private static void crearTiquete(){
        contact contacto = [select id from contact where Numero_de_Identificacion__c = '1040758632' Limit 1];
        opportunity reserva = [select id from opportunity limit 1];
        product2 vuelo = [select id from product2 Limit 1];
        
        OpportunityLineItem tiquete = new OpportunityLineitem(product2Id = vuelo.Id, OpportunityId= reserva.Id, pasajero__c = contacto.Id);
        insert tiquete;
        
        List<OpportunityLineItem> tiqueteCreado = [select Id From OpportunityLineItem];
        system.assertEquals(1, tiqueteCreado.size());
    }
    
    @isTest
    private static void sobreventa(){
        contact contacto = [select id from contact where Numero_de_Identificacion__c = '1040758632' Limit 1];
        opportunity reserva = [select id from opportunity limit 1];
        product2 vuelo = [select id from product2 Limit 1];
        List<OpportunityLineItem> tiquetes = new List<OpportunityLineItem>();
        try{
            for(Integer i = 0; i < 5; i++){
            OpportunityLineItem tiquete = new OpportunityLineitem(product2Id = vuelo.Id, OpportunityId= reserva.Id, pasajero__c = contacto.Id);
            tiquetes.add(tiquete);
        	}
        	insert tiquetes;
        }catch(exception e){
            system.assert(e.getMessage().contains('No es posible sobrevender los tiquetes'));
        }
    }
    
    @isTest
    private static void asignarMaleta(){
        contact contacto = [select id from contact where Numero_de_Identificacion__c = '1040758632' Limit 1];
        opportunity reserva = [select id from opportunity limit 1];
        product2 vuelo = [select id from product2 Limit 1];
        Pricebook2 listaNegocio = [select id from Pricebook2 Where Name = 'Negocio' Limit 1];
        
        Opportunity reservaContacto = new Opportunity (Titular_de_la_reserva__c= contacto.Id,Name = 'a',CloseDate = Date.today().addDays(1),StageName = 'Pre-venta',
                                                       Pricebook2Id = listaNegocio.Id );
        insert reservaContacto;
        
        PricebookEntry negociando = new PricebookEntry(Pricebook2Id = listaNegocio.Id, UnitPrice=6000,Product2Id=vuelo.Id, IsActive = true);
        insert negociando;
        
        OpportunityLineItem tiquete = new OpportunityLineitem(product2Id = vuelo.Id, OpportunityId= reservaContacto.Id, pasajero__c = contacto.Id);
        insert tiquete;
        
        List<OpportunityLineItem> tiqueteCreado = [select Id, Equipaje_Permitido__c From OpportunityLineItem];
        system.assert(tiqueteCreado[0].Equipaje_Permitido__c.contains('Personal;Maleta de Cabina;Maleta de Bodega'));
    }
    
    @isTest
    private static void actualizarTiquete(){
        contact contacto = [select id from contact where Numero_de_Identificacion__c = '1040758632' Limit 1];
        opportunity reserva = [select id from opportunity limit 1];
        product2 vuelo = [select id from product2 Limit 1];
        
        OpportunityLineItem tiquete = new OpportunityLineitem(product2Id = vuelo.Id, OpportunityId= reserva.Id, pasajero__c = contacto.Id);
        insert tiquete;
        
        OpportunityLineItem tiqueteCreado = [select Id, Equipaje_Permitido__c From OpportunityLineItem Limit 1];
        tiqueteCreado.Equipaje_Permitido__c = 'Personal;Maleta de Cabina;Maleta de Bodega';
        
        update tiqueteCreado;
        
        OpportunityLineItem tiqueteActualizado = [select Id, Equipaje_Permitido__c From OpportunityLineItem Limit 1];
        system.assert(tiqueteActualizado.Equipaje_Permitido__c.contains('Personal;Maleta de Cabina;Maleta de Bodega'));
    }
    
    @isTest
    private static void tiqueteSinPasajero(){
        contact contacto = [select id from contact where Numero_de_Identificacion__c = '1040758632' Limit 1];
        opportunity reserva = [select id from opportunity limit 1];
        product2 vuelo = [select id from product2 Limit 1];
        
        OpportunityLineItem tiquete = new OpportunityLineitem(product2Id = vuelo.Id, OpportunityId= reserva.Id);
        insert tiquete;
        
        List<OpportunityLineItem> tiqueteCreado = [select Id, pasajero__c From OpportunityLineItem];
        system.assert(tiqueteCreado[0].pasajero__c == contacto.Id);
    }
    
    @isTest
    private static void deleteTiquete(){
        opportunity reserva = [select id from opportunity limit 1];
        product2 vuelo = [select id from product2 Limit 1];
        
        OpportunityLineItem tiquete = new OpportunityLineitem(product2Id = vuelo.Id, OpportunityId= reserva.Id);
        insert tiquete;
        OpportunityLineItem tiqueteParaEliminar = [select Id From OpportunityLineItem Limit 1];
        delete tiqueteParaEliminar;
        
        List<OpportunityLineItem> tiqueteCreado = [select Id, pasajero__c From OpportunityLineItem];
        system.assert(tiqueteCreado.size() == 0);
    }
}