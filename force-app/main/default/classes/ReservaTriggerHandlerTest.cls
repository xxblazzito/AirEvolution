@isTest
public class ReservaTriggerHandlerTest {
	
    @TestSetup
    static void makeData(){
        List<Contact> contactos = new List<Contact>();
        for(integer i = 0 ; i < 50 ; i++){
            integer year = 1900;
            Contact contacto = new Contact (firstName = 'pablito', lastName = 'josefino'+i, Tipo_de_Identificacion__c = 'Cedula de Ciudadania',
                                                  Numero_de_Identificacion__c= '990509034'+i, Nacionalidad__c = 'colombiano', ffecha_de_nacimiento__c = Date.newInstance(year+i, 05, 09) );
            contactos.add(contacto);
        }
        insert contactos;   
        
        Opportunity reservaContacto = new Opportunity (Titular_de_la_reserva__c= contactos[0].Id,Name = 'a',CloseDate = Date.today().addDays(1),StageName = 'Pre-venta');
        insert reservaContacto;
    }
    
    @isTest
    private static void nombreReservas(){
        List<Contact> contactitos = [Select id from Contact];
        List<Opportunity> reservitas = new List<Opportunity>();
        for(Contact c : contactitos){
            Opportunity reservaContacto = new Opportunity (Titular_de_la_reserva__c= c.Id,Name = 'a',CloseDate = Date.today().addDays(1),StageName = 'Pre-venta');
            reservitas.add(reservaContacto);
        }
        insert reservitas;
        
        List<Opportunity> reservaConNuevoNombre = [Select id,Name from Opportunity];
        system.assertEquals(51,reservaConNuevoNombre.size());
        system.assert(reservaConNuevoNombre[0].Name.contains('pablitojosefino'));
    }
    
    @isTest
    private static void reservaPagadaSinVuelo(){
        try{
            Opportunity reservaConNuevoNombre = [Select id,Name,StageName from Opportunity LIMIT 1];
            reservaConNuevoNombre.StageName = 'Pagado';
            update reservaConNuevoNombre;
        }
        catch(exception e){
            system.assert(e.getMessage().contains('Para completar o pagar una reserva, Esta debe de tener por lo menos un vuelo asignado'));
        } 
    }
    
    @isTest
    private static void actFechaPago(){
        Opportunity reservaConNuevoNombre = [Select id,Name,StageName,CloseDate from Opportunity LIMIT 1];
        reservaConNuevoNombre.CloseDate = Date.today().addDays(5);
        update reservaConNuevoNombre;
        
        Opportunity reservaErronea=[Select id,Name,StageName,CloseDate from Opportunity Where id =: reservaConNuevoNombre.Id LIMIT 1];
        system.assert(reservaErronea.CloseDate == Date.today().addDays(5) );
    }
    
    @isTest
    private static void borrarReserva(){
        Opportunity reservaConNuevoNombre = [Select id,Name,StageName,CloseDate from Opportunity LIMIT 1];
        Id idreserva = reservaConNuevoNombre.Id;
        delete reservaConNuevoNombre;
        
        List<Opportunity> reservaCc = [Select id,Name,StageName,CloseDate from Opportunity WHERE Id =: idreserva LIMIT 1];
        system.assertEquals(0, reservaCc.size()); 
        
        Opportunity reservaBorrada = new Opportunity(Id = idreserva);
        undelete reservaBorrada;
        List<Opportunity> reservaCc1 = [Select id,Name,StageName,CloseDate from Opportunity WHERE Id =: idreserva LIMIT 1];
        system.assertEquals(1, reservaCc1.size());
    }
}