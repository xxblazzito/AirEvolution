public with sharing class contactoReserva {
  
    @AuraEnabled
    public static ctoReserva clienteReserva(string tipoId, string numId){
        contact cliente = null;
        Opportunity reserva = null;
        try{
            List<Contact> contacto = [SELECT Id, Name, Numero_de_Identificacion__c,	Numero_de_pasaporte__c 
                                    FROM Contact WHERE Tipo_de_Identificacion__c =: tipoId AND Numero_de_Identificacion__c =: numId LIMIT 1];

        	List<Opportunity> reservaExistente = new List<Opportunity>();

            if(contacto.size() > 0){
                cliente = contacto[0];
                reservaExistente = [SELECT Id, Name, StageName FROM Opportunity WHERE StageName NOT IN ('Pagado', 'No pagado') 
                                    AND Titular_de_la_reserva__c =: cliente.Id LIMIT 1];
            }

            if(reservaExistente.size() > 0){
                reserva = reservaExistente[0];
            }
    
            ctoReserva resultado = new ctoReserva(cliente, reserva);
            return resultado;
        }catch(Exception e){
            return null;
        }               
    }
    
    @AuraEnabled
    public static Opportunity crearReserva(string idContactito, string listaPrecio){
        try{
            List<Pricebook2> listasPrecios = [Select Id, Name from Pricebook2];
            Id idLista;
            for(Pricebook2 a: listasPrecios ){
                if(a.Name == listaPrecio ){
                    idLista = a.Id;
                }
            }
            date fechapagar = Date.today();
            Opportunity nuevaReserva = new Opportunity(Titular_de_la_reserva__c = idContactito, StageName = 'Pre-venta', Name = 'a', CloseDate = fechapagar, Pricebook2Id = idLista);
            insert(nuevaReserva);
            return nuevaReserva;
        }catch(exception e){
            return null;
        } 
    }

    @AuraEnabled(cacheable = true)
    public static List<vuelo> obtenerVuelos(string idListaPrecios){
        try{
            List<Product2> listado = [SELECT Id, Name,Aeropuerto_de_partida__r.Name,Aeropuerto_de_partida__r.Pais__c,  
                                    Aeropuerto_de_llegada__r.Name,Aeropuerto_de_llegada__r.Pais__c,Fecha_y_hora_de_partida__c,Fecha_y_hora_estimada_de_llegada__c,  
                                    (select unitprice from pricebookEntries WHERE Pricebook2Id =: idListaPrecios )FROM Product2 WHERE Estado__c = 'En Venta' AND IsActive = true ];

            List<Vuelo> vuelosRta = new List<Vuelo>();

            for(Product2 a: listado){
                if(a.pricebookEntries.size() > 0){
                    vuelosRta.add(new vuelo((string)a.Id, a.Name, a.Aeropuerto_de_partida__r.Name,a.Aeropuerto_de_partida__r.Pais__c,
                                a.Aeropuerto_de_llegada__r.Name,a.Aeropuerto_de_llegada__r.Pais__c, a.Fecha_y_hora_de_partida__c, a.Fecha_y_hora_estimada_de_llegada__c,
                                a.pricebookEntries[0].unitprice));
                }
                
            }

            return vuelosRta;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        } 
    }

    @auraEnabled(cacheable=true)
    public static List<OpportunityLineItem> obtenerPasajeros(string idReserva, string idTitular){
        List<OpportunityLineItem> tiquetesPasajeros = [Select Id, Pasajero__r.Name, Product2Id, Asiento__c From OpportunityLineItem Where
                                                            OpportunityId =: idReserva And Pasajero__c != :idTitular];

        return tiquetesPasajeros;
    }
    
    @AuraEnabled
    public static List<OpportunityLineItem> crearTiquete(string reserva, List<string> vuelo, string contacto, string equipaje){
        try {
            List<OpportunityLineItem> tiquetes = new List<OpportunityLineItem>();
            integer numeroVuelos = vuelo.size();
            for(string a : vuelo){
                OpportunityLineItem nuevoTiquete = new OpportunityLineItem(Pasajero__c = Contacto, OpportunityId = Reserva, Product2Id = a );
                tiquetes.add(nuevoTiquete);
            }
            insert tiquetes;
            return tiquetes;
        } catch (Exception e) {
            throw new personalizadaException('se ha producido un error: '+e);
        } 
    }

    public class ctoReserva{
        @auraEnabled 
        public Contact contacto;
        @auraEnabled 
        public Opportunity oportunidad;
        
        public ctoReserva(Contact cliente, Opportunity reserva){
            contacto = cliente;
            oportunidad = reserva;
        }
    }

    public class vuelo{
        
        @AuraEnabled 
        public string codigo {get;set;}
        @AuraEnabled 
        public string idVuelo {get;set;}      
        @AuraEnabled 
        public string aeropuertoPartida {get;set;}
        @AuraEnabled 
        public string aeropuertoPartidaPais {get;set;}
        @AuraEnabled
        public string aeropuertoLlegada {get;set;}       
        @AuraEnabled 
        public string aeropuertoLlegadaPais {get;set;} 
        @AuraEnabled 
        public DateTime fechaPartida {get;set;}
        @AuraEnabled 
        public DateTime fechaLlegada {get;set;}
        @AuraEnabled 
        public decimal precioUnitario {get;set;}  

        public Vuelo(string id, string codigoVuelo, string aeropuertoDePartida, string aeroPartidaPais, string aeropuertoDeLlegada, string aeroLlegadaPais, DateTime fechaDePartida, DateTime fechaDeLlegada, decimal precio) {
            idVuelo= id;
            codigo= codigoVuelo;
            aeropuertoPartida= aeropuertoDePartida; 
            aeropuertoPartidaPais = aeroPartidaPais;
            aeropuertoLlegada= aeropuertoDeLlegada;
            aeropuertoLlegadaPais = aeroLlegadaPais;
            fechaPartida= fechaDePartida;
            fechaLlegada= fechaDeLlegada;
            precioUnitario = precio;
        }
    }
    public class personalizadaException extends Exception {}
}