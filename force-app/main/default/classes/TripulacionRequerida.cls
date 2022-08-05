public class TripulacionRequerida {
    @AuraEnabled(cacheable = true)
    public static List<vuelo> obtenerVuelos(){

        try {
            DateTime limitDate = DateTime.now().addDays(7);

            //obtiene todos los vuelos que acaban en 1 semana o menos
            list<Product2> vuelos = [SELECT Id, Name, Copiloto__c, Piloto__c, Fecha_y_hora_de_partida__c, Avion__r.Auxiliares_de_Vuelo_Requeridos__c,(select id from VueloxContactos__r)
                                FROM Product2 WHERE IsActive = true AND Estado__c = 'En venta' AND Fecha_y_hora_de_partida__c > today AND Fecha_y_hora_de_partida__c <: limitDate];
            
            //Instancia de la clase vuelo (wrapper)
            List<Vuelo> vuelosRta = new List<Vuelo>();

            //agrega los vuelos de la lista a una la lista de la clase wrapper
            for(Product2 a: vuelos  ){
                vuelosRta.add(new vuelo((string)a.Id , a.Name, (integer)a.Avion__r.Auxiliares_de_Vuelo_Requeridos__c, a.Copiloto__c, a.Piloto__c,
                a.VueloxContactos__r.size()));
            }
            system.debug(vuelosRta);
            return vuelosRta;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            
        }  
        /*List<Product2> vuelos = [SELECT Id, Name, Copiloto__c, Piloto__c, Fecha_y_hora_de_partida__c, Avion__r.Auxiliares_de_Vuelo_Requeridos__c,
                                (SELECT id FROM VueloxContactos__r) FROM Product2 WHERE IsActive = true AND Estado__c = 'En venta' AND
                                 Fecha_y_hora_de_partida__c > today And Fecha_y_hora_de_partida__c <: limitDate]; 
        return vuelos;*/
    } 

    @AuraEnabled(cacheable = true)
    public static List<opcion> getAuxiliares(String idVuelo){
        try {
            //Todos los auxiliares de vuelo que hay(solo muestra 20).
            List<Contact> auxiliaresDisponibles = [SELECT Id, Name FROM Contact WHERE RecordType.Name = 'Auxiliar de Vuelo' LIMIT 20];

            //Todos los auxiliares que ya se encuentran asignados como tripulantes a un vuelo.
            List<VueloX__c> Tripulantes = [SELECT id,Contact__c,Contact__r.Name FROM VueloX__c WHERE Product__c =: idVuelo];

            //intancia de la clase opcion(wrapper)
            List<opcion> opciones = new List<opcion>();

            //Agrega los resultados de las anteriores listas a la lista opciones
            for(Contact c: auxiliaresDisponibles){
                opciones.add(new opcion(c.name,c.id,false));
            }
            for(VueloX__c t: Tripulantes){
                opciones.add(new opcion(t.Contact__r.Name ,t.Contact__c,true));
            }
            return opciones;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveAuxiliares(List<string> auxiliares, string idVuelo){
        try {
            //Todos los auxiliares que ya se encuentran asignados como tripulantes a un vuelo.
            List<VueloX__c> Tripulantes = [SELECT id,Contact__c,Contact__r.Name FROM VueloX__c WHERE Product__c =: idVuelo];

            set<string> noEncontrados = new set<string>();

            for(VueloX__c t : Tripulantes){
                for(integer i=0; i < auxiliares.size(); i++){

                    //Removemos los existentes de la lista que llego para no duplicarlos.
                    if(t.Contact__c == auxiliares[i]){
                        auxiliares.remove(i);
                        if(noEncontrados.contains(t.id)){
                            noEncontrados.remove(t.id); //no entra por que es una lista vacia la primera vez
                        }
                    }else {
                        // si no lo encuentra lo agrega a una lista para luego eliminarlos.
                        noEncontrados.add(t.id);
                    }
                }
            }// todo este for valida que no le mande 2 veces el mismo tripulante

            //Creamos los nuevos tripulantes.
            List<VueloX__c> nuevosTripulantes = new List<VueloX__c>();
            for(string a: auxiliares){
                nuevosTripulantes.add(new VueloX__c(Product__c = idVuelo, Contact__c = a));
            }
            system.debug('Nuevos Tripulantes -->'+nuevosTripulantes);
            insert nuevosTripulantes;

            //Eliminar los tripulantes que ya no van.
            system.debug('No encontrados-->'+noEncontrados);
            List<VueloX__c> paraBorrar = new List<VueloX__c>();
            for(string idT : noEncontrados){
                paraBorrar.add(new VueloX__c(id = idT));
            }
            delete paraBorrar;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class vuelo{
        
        @AuraEnabled 
        public string codigo {get;set;}
        @AuraEnabled 
        public string idVuelo {get;set;}      
        @AuraEnabled 
        public decimal auxiliaresRequeridos {get;set;}
        @AuraEnabled
        public Integer auxiliaresFaltantes {get;set;}        
        @AuraEnabled 
        public boolean piloto {get;set;}
        @AuraEnabled 
        public boolean copiloto {get;set;}  

        public Vuelo(string id, string codigoVuelo, integer auxiliares, string copilotoId, string pilotoId, integer sizeTripulante) {
            idVuelo= id;
            codigo= codigoVuelo;
            auxiliaresRequeridos= auxiliares; 
            auxiliaresFaltantes= auxiliares-sizeTripulante;
            piloto= !string.isblank(pilotoId);
            copiloto= !string.isblank(copilotoId);
        }
    }
    
    public class opcion{
        @AuraEnabled 
        public string label;
        @AuraEnabled 
        public string value;
        @AuraEnabled 
        public boolean selected;
        public opcion(string label, string value, boolean selected){
            this.label=label;
            this.value=value;
            this.selected=selected;
        }
    }
}