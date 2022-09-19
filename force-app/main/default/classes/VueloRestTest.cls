@isTest
public class VueloRestTest {

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
        
        Contact contactoConReserva = new Contact (firstName = 'cristian', lastName = 'aguirre', Tipo_de_Identificacion__c = 'Cedula de Ciudadania',Email = 'cristian@gmail.com', 
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
    private static void reservaPostNuevoContacto(){
        Pricebook2 listaTurista = [select id from Pricebook2 where Name = 'Turista' Limit 1];
        PricebookEntry precioTurista = [select id from PricebookEntry where Pricebook2Id =: listaTurista.Id Limit 1];
        String idPrecio = precioTurista.Id;
        ReservaRest.ReservaWrapper resultadoReserva = ReservaRest.createReserva(idPrecio, 'Cristian Blazz', 'Aguirre Prueba', 'Cedula de Ciudadania', '10409905', 'blazzito@gmail.com');
        system.assertEquals(true, resultadoReserva.exito);
        system.assert(resultadoReserva.mensaje.contains('La reserva y el vuelo fueron Creados correctamente'));
        system.assert(resultadoReserva.reserva != null);
        system.assert(resultadoReserva.tiquete != null);
    }
    
    @isTest
    private static void reservaPostContactoExistente(){
        Pricebook2 listaTurista = [select id from Pricebook2 where Name = 'Turista' Limit 1];
        PricebookEntry precioTurista = [select id from PricebookEntry where Pricebook2Id =: listaTurista.Id Limit 1];
        String idPrecio = precioTurista.Id;
        ReservaRest.ReservaWrapper resultadoReserva = ReservaRest.createReserva(idPrecio, 'Pablito', 'Josefino', 'Cedula de Ciudadania', '99050903482', 'blazzito@gmail.com');
        system.assertEquals(true, resultadoReserva.exito);
        system.assert(resultadoReserva.mensaje.contains('La reserva y el vuelo fueron Creados correctamente'));
        system.assert(resultadoReserva.reserva != null);
        system.assert(resultadoReserva.tiquete != null);
    }
    
    @isTest
    private static void reservaPostReservaConVuelo(){
        Pricebook2 listaTurista = [select id from Pricebook2 where Name = 'Turista' Limit 1];
        PricebookEntry precioTurista = [select id from PricebookEntry where Pricebook2Id =: listaTurista.Id Limit 1];
        String idPrecio = precioTurista.Id;
        ReservaRest.ReservaWrapper resultadoReserva = ReservaRest.createReserva(idPrecio, 'Cristian', 'Aguirre', 'Cedula de Ciudadania', '1040758632', 'blazzito@gmail.com');
        system.assertEquals(false, resultadoReserva.exito);
        system.assert(resultadoReserva.mensaje.contains('El pasajero ya tiene asignada una reserva con dicho vuelo, no es posible asignarlo nuevamente'));
    }
    
    @isTest
    private static void reservaPostReservaSinVuelo(){
        string pricebookId = Test.getStandardPricebookId();
        Pricebook2 listaTurista = [select id from Pricebook2 where Name = 'Turista' Limit 1];
        List<Aeropuerto__c> aeropuertos = [select id from Aeropuerto__c];
        Avion__c avion = [select id from Avion__c limit 1];
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
        
        PricebookEntry turisteando = new PricebookEntry(Pricebook2Id = listaTurista.Id, UnitPrice=5000,Product2Id=vuelo.Id, IsActive = true);
        insert turisteando;
        string idPrecio = turisteando.Id;
        Contact contacto = [select id from Contact where Numero_de_Identificacion__c = '99050903482' limit 1];
        Opportunity reservaContacto = new Opportunity (Titular_de_la_reserva__c= contacto.Id,Name = 'a',CloseDate = Date.today().addDays(1),StageName = 'Pre-venta',
                                                       Pricebook2Id = listaTurista.Id );
        insert reservaContacto;
        ReservaRest.ReservaWrapper resultadoReserva = ReservaRest.createReserva(idPrecio, 'Pablito', 'Josefino', 'Cedula de Ciudadania', '1040758632', 'blazzito@gmail.com');
        system.assertEquals(true, resultadoReserva.exito);
        system.assert(resultadoReserva.mensaje.contains('La reserva se actualizo y se agrego el vuelo correctamente'));
        system.assert(resultadoReserva.reserva != null);
        system.assert(resultadoReserva.tiquete != null);
    }
    
    @isTest
    private static void reservaFaltaPriceBookEntry(){
        ReservaRest.ReservaWrapper resultadoReserva = ReservaRest.createReserva(null, 'Cristian Blazz', 'Aguirre Prueba', 'Cedula de Ciudadania', '10409905', 'blazzito@gmail.com');
        system.assertEquals(false, resultadoReserva.exito);
        system.assert(resultadoReserva.mensaje.contains('Falta el ID de la Entrada de Lista de Precios'));
        system.assert(resultadoReserva.reserva != null);
        system.assert(resultadoReserva.tiquete != null);
    }
    
    @isTest
    private static void reservaFaltaNombre(){
        Pricebook2 listaTurista = [select id from Pricebook2 where Name = 'Turista' Limit 1];
        PricebookEntry precioTurista = [select id from PricebookEntry where Pricebook2Id =: listaTurista.Id Limit 1];
        String idPrecio = precioTurista.Id;
        ReservaRest.ReservaWrapper resultadoReserva = ReservaRest.createReserva(idPrecio, null, 'Aguirre Prueba', 'Cedula de Ciudadania', '10409905', 'blazzito@gmail.com');
        system.assertEquals(false, resultadoReserva.exito);
        system.assert(resultadoReserva.mensaje.contains('Debe Ingresar el Nombre Completo del Contacto'));
        system.assert(resultadoReserva.reserva != null);
        system.assert(resultadoReserva.tiquete != null);
    }
    
    @isTest
    private static void reservaFaltaTipoDoc(){
        Pricebook2 listaTurista = [select id from Pricebook2 where Name = 'Turista' Limit 1];
        PricebookEntry precioTurista = [select id from PricebookEntry where Pricebook2Id =: listaTurista.Id Limit 1];
        String idPrecio = precioTurista.Id;
        ReservaRest.ReservaWrapper resultadoReserva = ReservaRest.createReserva(idPrecio, 'Cristian Blazz', 'Aguirre Prueba', null, '10409905', 'blazzito@gmail.com');
        system.assertEquals(false, resultadoReserva.exito);
        system.assert(resultadoReserva.mensaje.contains('Debe Ingresar el Tipo de Documento'));
        system.assert(resultadoReserva.reserva != null);
        system.assert(resultadoReserva.tiquete != null);
    }
    
    @isTest
    private static void reservaFaltaNumDoc(){
        Pricebook2 listaTurista = [select id from Pricebook2 where Name = 'Turista' Limit 1];
        PricebookEntry precioTurista = [select id from PricebookEntry where Pricebook2Id =: listaTurista.Id Limit 1];
        String idPrecio = precioTurista.Id;
        ReservaRest.ReservaWrapper resultadoReserva = ReservaRest.createReserva(idPrecio, 'Cristian Blazz', 'Aguirre Prueba', 'Cedula de Ciudadania', null, 'blazzito@gmail.com');
        system.assertEquals(false, resultadoReserva.exito);
        system.assert(resultadoReserva.mensaje.contains('Debe Ingresar el Numero de Documento'));
        system.assert(resultadoReserva.reserva != null);
        system.assert(resultadoReserva.tiquete != null);
    }
    
    @isTest
    private static void reservaErrorInesperado(){
        ReservaRest.ReservaWrapper resultadoReserva = ReservaRest.createReserva('aas54654as', 'Cristian Blazz', 'Aguirre Prueba', 'Cedula de Ciudadania', '10409905', 'blazzito@gmail.com');
        system.assertEquals(false, resultadoReserva.exito);
        system.assert(resultadoReserva.mensaje.contains('Se ha producido un error inesperado'));
        system.assert(resultadoReserva.reserva != null);
        system.assert(resultadoReserva.tiquete != null);
    }
    
    @isTest
    private static void vueloGetVuelos(){
        // Set up a test request
        // 
        Date date1 = date.today().addDays(-20);
        Date date2 = date.today().addDays(20);
        
        string fecha1 = date1.day()+'-'+date1.month()+'-'+date1.year();
        string fecha2 = date2.day()+'-'+date2.month()+'-'+date2.year();
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('fechaUno', fecha1);
        request.addParameter('fechaDos', fecha2);
        request.addParameter('ciudadPartida', 'Antioquia');
        request.addParameter('ciudadLlegada', 'Cali');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        VueloRest.VuelosWrapper vueloRestPrueba = VueloRest.getVuelos();
        // Verify results
        //System.assert(vueloRest.vuelo != null);
        system.debug(vueloRestPrueba);
        system.assert(vueloRestPrueba.vuelo!=null);
        system.assertEquals(true, vueloRestPrueba.exito);
        //System.assertEquals('Test record', thisCase.Subject);
    }
    
    @isTest
    private static void vueloFechaPartidaBad(){
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('fechaUno', '02-09-20222');
        request.addParameter('fechaDos', '02-10-2022');
        request.addParameter('ciudadPartida', 'Antioquia');
        request.addParameter('ciudadLlegada', 'Cali');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        VueloRest.VuelosWrapper vueloRestPrueba = VueloRest.getVuelos();
        // Verify results
        //System.assert(vueloRest.vuelo != null);
        system.debug(vueloRestPrueba);
        //system.assert(vueloRestPrueba.vuelo=null);
        system.assertEquals(null, vueloRestPrueba.vuelo);
        system.assertEquals(false, vueloRestPrueba.exito);
        system.assert(vueloRestPrueba.mensaje.contains('La fecha de partida es incorrecta'));
    }
    
    @isTest
    private static void vueloFechaLlegadaBad(){
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('fechaUno', '02-09-2022');
        request.addParameter('fechaDos', '02-10-20222');
        request.addParameter('ciudadPartida', 'Antioquia');
        request.addParameter('ciudadLlegada', 'Cali');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        VueloRest.VuelosWrapper vueloRestPrueba = VueloRest.getVuelos();
        // Verify results
        //System.assert(vueloRest.vuelo != null);
        system.debug(vueloRestPrueba);
        //system.assert(vueloRestPrueba.vuelo=null);
        system.assertEquals(null, vueloRestPrueba.vuelo);
        system.assertEquals(false, vueloRestPrueba.exito);
        system.assert(vueloRestPrueba.mensaje.contains('La fecha de Llegada es incorrecta'));
    }
    
    @isTest
    private static void vueloCiudadPartidaBad(){
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('fechaUno', '02-09-2022');
        request.addParameter('fechaDos', '02-10-2022');
        request.addParameter('ciudadPartida', 'Antioquiaa');
        request.addParameter('ciudadLlegada', 'Cali');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        VueloRest.VuelosWrapper vueloRestPrueba = VueloRest.getVuelos();
        // Verify results
        //System.assert(vueloRest.vuelo != null);
        system.debug(vueloRestPrueba);
        //system.assert(vueloRestPrueba.vuelo=null);
        system.assertEquals(null, vueloRestPrueba.vuelo);
        system.assertEquals(false, vueloRestPrueba.exito);
        system.assert(vueloRestPrueba.mensaje.contains('La ciudad de partida del vuelo es incorrecta o no existe'));
    }
    
    @isTest
    private static void vueloCiudadLlegadaBad(){
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('fechaUno', '02-09-2022');
        request.addParameter('fechaDos', '02-10-2022');
        request.addParameter('ciudadPartida', 'Antioquia');
        request.addParameter('ciudadLlegada', 'Calia');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        VueloRest.VuelosWrapper vueloRestPrueba = VueloRest.getVuelos();
        // Verify results
        //System.assert(vueloRest.vuelo != null);
        system.debug(vueloRestPrueba);
        //system.assert(vueloRestPrueba.vuelo=null);
        system.assertEquals(null, vueloRestPrueba.vuelo);
        system.assertEquals(false, vueloRestPrueba.exito);
        system.assert(vueloRestPrueba.mensaje.contains('La ciudad de llegada del vuelo es incorrecta o no existe'));
    }
    
    @isTest
    private static void vueloErrorMayor(){
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/Product2/';
        request.addParameter('fechaDos', '02-10-2022');
        request.addParameter('ciudadPartida', 'Antioquia');
        request.addParameter('ciudadLlegada', 'Calia');
        
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        VueloRest.VuelosWrapper vueloRestPrueba = VueloRest.getVuelos();
        // Verify results
        //System.assert(vueloRest.vuelo != null);
        system.debug(vueloRestPrueba);
        //system.assert(vueloRestPrueba.vuelo=null);
        system.assertEquals(null, vueloRestPrueba.vuelo);
        system.assertEquals(false, vueloRestPrueba.exito);
        system.assert(vueloRestPrueba.mensaje.contains('desde el catch: '));
    }
    
    @isTest
    private static void vueloPdf(){
        Opportunity reserva = [select id from Opportunity limit 1];
        RestRequest request = new RestRequest();
        request.requestURI = 'https://yourInstance.my.salesforce.com/services/apexrest/Product2/';
        request.httpMethod = 'patch';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = blob.valueOf('{"idReserva: "'+reserva.Id+'","aprobado" : true}');
        RestContext.request = request;
        ReservaRest.pagoWrapper respuesta = ReservaRest.pagarReserva(reserva.Id, true);
        system.debug(respuesta);
        system.assertEquals('La reserva se ha pagado Correctamente', respuesta.mensaje);
    }
    
    @isTest
    private static void vueloPdfSinReserva(){
        Opportunity reserva = new Opportunity();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://yourInstance.my.salesforce.com/services/apexrest/Product2/';
        request.httpMethod = 'patch';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = blob.valueOf('{"idReserva: "'+reserva.Id+'","aprobado" : true}');
        RestContext.request = request;
        ReservaRest.pagoWrapper respuesta = ReservaRest.pagarReserva(reserva.Id, true);
        system.debug(respuesta);
        system.assertEquals('Debe de ingresar el id de la Reserva', respuesta.mensaje);
    }
    
    @isTest
    private static void vueloPdfSinAprobar(){
        Opportunity reserva = [select id from Opportunity limit 1];
        RestRequest request = new RestRequest();
        request.requestURI = 'https://yourInstance.my.salesforce.com/services/apexrest/Product2/';
        request.httpMethod = 'patch';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = blob.valueOf('{"idReserva: "'+reserva.Id+'","aprobado" : null}');
        RestContext.request = request;
        ReservaRest.pagoWrapper respuesta = ReservaRest.pagarReserva(reserva.Id, null);
        system.debug(respuesta);
        system.assertEquals('No se ha podido validar el pago con entidad Bancaria', respuesta.mensaje);
    }
    
    @isTest
    private static void vueloPdfSinFondos(){
        Opportunity reserva = [select id from Opportunity limit 1];
        RestRequest request = new RestRequest();
        request.requestURI = 'https://yourInstance.my.salesforce.com/services/apexrest/Product2/';
        request.httpMethod = 'patch';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = blob.valueOf('{"idReserva: "'+reserva.Id+'","aprobado" : false}');
        RestContext.request = request;
        ReservaRest.pagoWrapper respuesta = ReservaRest.pagarReserva(reserva.Id, false);
        system.debug(respuesta);
        system.assertEquals('Su pago ha sido Rechazado, por favor comuniquese con su entidad bancaria.', respuesta.mensaje);
    }
    
    @isTest
    private static void vueloPdfError(){
        Contact contacto = [select id from Contact where Numero_de_Identificacion__c = '99050903482' limit 1 ];
        Pricebook2 listaTurista = [select id from pricebook2 where Name = 'Turista' limit 1];
        Opportunity reservaContacto = new Opportunity (Titular_de_la_reserva__c= contacto.Id,Name = 'a',CloseDate = Date.today().addDays(1),StageName = 'Pre-venta', Pricebook2Id = listaTurista.Id );
        insert reservaContacto;
        product2 vuelo = [select id from product2 limit 1];
        OpportunityLineItem nuevoTiquete = new OpportunityLineItem(Pasajero__c = contacto.Id, OpportunityId = reservaContacto.Id, Product2Id = vuelo.Id);
        insert nuevoTiquete;
        
        
        RestRequest request = new RestRequest();
        request.requestURI = 'https://yourInstance.my.salesforce.com/services/apexrest/Product2/';
        request.httpMethod = 'patch';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = blob.valueOf('{"idReserva: "'+reservaContacto.Id+'","aprobado" : true}');
        RestContext.request = request;
        ReservaRest.pagoWrapper respuesta = ReservaRest.pagarReserva(reservaContacto.Id, true);
        system.debug(respuesta);
        system.assert(respuesta.mensaje.contains('Error al actualizar la reserva y/o enviar el correo electronico'));
    }
}