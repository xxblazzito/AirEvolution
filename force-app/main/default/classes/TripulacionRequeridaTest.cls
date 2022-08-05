@isTest
public with sharing class TripulacionRequeridaTest {
   
    @TestSetup
    static void makeData(){
        avion__c avion = new avion__c(	Numero_de_pasajeros_clase_negocios__c=0,Numero_de_pasajeros_clase_turista__c=150,Tipo__c='superMegaVoladoraMaquina');

        insert avion;
        avion__c avionsito = [SELECT Id FROM Avion__c LIMIT 1];

        product2 vuelo = new Product2(Name = 'AV-0001', Avion__c = avionsito.Id , Fecha_y_hora_de_partida__c = DateTime.now()+8/7,
                                    Fecha_y_hora_estimada_de_llegada__c = (DateTime.now()+8/7).addHours(1), IsActive = true, Estado__c = 'En Venta');

        insert vuelo;

        Contact auxiliar = new Contact(firstName='josefino', lastName='pan y vino', RecordTypeId='0128a0000017rhWAAQ',
                                        Numero_de_pasaporte__c='12312345',Nacionalidad__c='colombiano',
                                        ffecha_de_nacimiento__c=Date.newInstance(1999,05,09));

        insert auxiliar;

        List<Contact> contactito = new List<Contact>();
        for(integer i = 0; i < 1;i++){
            Contact auxiliar1 = new Contact(firstName='josefino'+i, lastName='pan y vino'+i, RecordTypeId='0128a0000017rhWAAQ',
                                        Numero_de_pasaporte__c='1231234522+i',Nacionalidad__c='argentino',
                                        ffecha_de_nacimiento__c=Date.newInstance(1999,05,09));
            contactito.add(auxiliar1);
        }
        
        insert contactito;

        product2 vuelito = [SELECT Id from Product2 LIMIT 1];
        Contact auxiliarsito = [SELECT Id FROM Contact LIMIT 1];

        VueloX__c junction = new VueloX__c(Contact__c = auxiliarsito.Id,Product__c = vuelito.Id);
        insert junction;
        
    }

    @isTest
    private static void obtienenUnVuelo(){
        List<TripulacionRequerida.vuelo> vuelos = TripulacionRequerida.obtenerVuelos();
        system.assertEquals(1, vuelos.size());
    }

    @isTest
    private static void errorObtienenUnVuelo(){
        avion__c avionsin = [SELECT Id FROM avion__c LIMIT 1];
        delete avionsin;
        
        try {
            List<TripulacionRequerida.vuelo> vuelos = TripulacionRequerida.obtenerVuelos();
        }
        catch (Exception e) {
            system.assert(e.getMessage().contains('Script-thrown exception'));
        }
        
    }

    @isTest
    private static void auxiliares(){
        
        Product2 vuelos = [SELECT Id FROM product2 LIMIT 1];
        
        List<TripulacionRequerida.opcion> auxiliares = TripulacionRequerida.getAuxiliares(vuelos.id);
        system.assertEquals(3, auxiliares.size());
        
    }
    // Validar el metodo getAuxiliares con error
    @isTest
    private static void auxiliaresConError(){
        
        List<TripulacionRequerida.opcion> auxiliares = TripulacionRequerida.getAuxiliares('1231sdd');
        
    }

    @isTest
    private static void guardarAuxiliares(){
        Product2 vuelos = [SELECT Id FROM product2 LIMIT 1];
        
        

        List<Contact> obtenidoAuxiliar = [SELECT Id FROM Contact];
        List<string> ids = new List<string>();
        for(Contact a: obtenidoAuxiliar){
            ids.add(a.Id);
        }
        

        TripulacionRequerida.saveAuxiliares(ids,vuelos.id);

        List<TripulacionRequerida.opcion> auxiliares = TripulacionRequerida.getAuxiliares(vuelos.id);
        system.assertEquals(4, auxiliares.size());
    }
}