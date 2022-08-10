@istest
public class contactoReservaTest {
	
    @testSetup
    static void makeData(){
        Contact contactoSinReserva = new Contact (firstName = 'pablito', lastName = 'josefino', Tipo_de_Identificacion__c = 'Cedula de Ciudadania',
                                                  Numero_de_Identificacion__c= '99050903482', Nacionalidad__c = 'colombiano', ffecha_de_nacimiento__c = Date.newInstance(1999, 05, 09) );
        insert contactoSinReserva;
        
        Pricebook2 listaPrecios = new Pricebook2(Name = 'Standard Price Book');
        insert listaPrecios;
        
        Pricebook2 listaPrecios2 = new Pricebook2(Name = 'Turista');
        insert listaPrecios2;
                           
        Contact contactoConReserva = new Contact (firstName = 'cristian', lastName = 'aguirre', Tipo_de_Identificacion__c = 'Cedula de Ciudadania', 
                                                  Numero_de_Identificacion__c= '1040758632', Nacionalidad__c = 'colombiano', ffecha_de_nacimiento__c = Date.newInstance(1999, 05, 09) );
        insert contactoConReserva;
                           
        Opportunity reservaContacto = new Opportunity (Titular_de_la_reserva__c= contactoConReserva.Id,Name = 'a',CloseDate = Date.today().addDays(1),StageName = 'Pre-venta',
                                                       Pricebook2Id = listaPrecios.Id );
        insert reservaContacto;
        
        list<Aeropuerto__c> aeropuertos = new List<Aeropuerto__c>();
        for(integer i = 0 ; i < 2; i++){
            Aeropuerto__c aeropuerto = new Aeropuerto__c(Name='aeropuerto'+i , Pais__c = 'Colombia', Ciudad__c = 'Antioquia');
            aeropuertos.add(aeropuerto);
        }
        insert aeropuertos;
        
        product2 vuelo = new product2(Name = 'ae56', Aeropuerto_de_partida__c =aeropuertos[0].id, Aeropuerto_de_llegada__c = aeropuertos[1].id,
                                      Fecha_y_hora_de_partida__c = Date.newInstance(2022, 08, 22), Fecha_y_hora_estimada_de_llegada__c = Date.newInstance(2022, 08, 23));
        insert vuelo;
        
        /*List<Pricebook2> standardPriceBook = [
        	SELECT Id
            FROM Pricebook2
            WHERE isStandard = true
        ];
        
        PricebookEntry standardPriceBookEntry = new PricebookEntry(
        Pricebook2Id = standardPriceBook[0].Id,
        Product2Id = vuelo.Id,
        UnitPrice = 4000,
        UseStandardPrice = false,
        IsActive = true
    	);
        insert standardPriceBookEntry;
        
        PricebookEntry entrada = new PricebookEntry(Pricebook2Id = listaPrecios.Id,UnitPrice=5000,Product2Id=vuelo.Id,IsActive = true);
        insert entrada;*/
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
        system.assertEquals(null, contactoReserva.clienteReserva('Cedula de Ciudadania', '101010mmm').oportunidad);
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
        Pricebook2 idlista = [Select Id From Pricebook2 Limit 1];
        system.assert(contactoReserva.obtenerVuelos(idlista.Id).size() ==0);
    }
    
}