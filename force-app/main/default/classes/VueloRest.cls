@RestResource(urlMapping ='/VueloRest/*')
global with sharing class VueloRest {
    @HttpGet
    global static VuelosWrapper getVuelos(){
        //Variables vacias para el wrapper
        List<Product2> vuelos;
        List<Sobject> precios;
        List<Pricebook2> lista;
        String mensaje;
        Boolean exito;
        VuelosWrapper wrapper;
        
        Schema.DescribeFieldResult objFieldDescribe = Aeropuerto__c.Ciudad__c.getDescribe();
        List<Schema.PicklistEntry> ciudadesDispo = objFieldDescribe.getPickListValues();
        
        List<String> ciudades = new list<String>();
        for (Schema.PicklistEntry c : ciudadesDispo) {
            ciudades.add(c.getValue());
        }
        
        try{
            String fechaUno;
            String fechaDos;
            String ciudadPartida;
            String ciudadLlegada;
            Date fUno;
            Date fDos;
            RestRequest restReq = RestContext.request;
            RestResponse restRes = RestContext.response;
            
            fechaUno = (restReq.params.get('fechaUno')).replace('-','/');
            fechaDos = (restReq.params.get('fechaDos')).replace('-','/');
            ciudadPartida = restReq.params.get('ciudadPartida');
            ciudadLlegada = restReq.params.get('ciudadLlegada');
            
            //Validacion 
            try{
                fUno = Date.parse(fechaUno);
            }catch(exception e){
                mensaje = 'La fecha de partida es incorrecta: ' + e.getMessage() + '. El formato correcto es Dia-Mes-Año';
            }
            try{
                fDos = Date.parse(fechaDos);
            }catch(exception e){
                mensaje = 'La fecha de Llegada es incorrecta: ' + e.getMessage() + '. El formato correcto es Dia-Mes-Año';
            }
            
            
            
            if(!ciudades.contains(ciudadPartida)){
                exito = false;
                mensaje = 'La ciudad de partida del vuelo es incorrecta o no existe';
                wrapper = new VuelosWrapper(vuelos,mensaje,exito, precios);
                return wrapper;
            }
            if(!ciudades.contains(ciudadLlegada)){
                exito = false;
                mensaje = 'La ciudad de llegada del vuelo es incorrecta o no existe';
                wrapper = new VuelosWrapper(vuelos,mensaje,exito, precios);
                return wrapper;
            }
            
            Datetime tUno = datetime.newInstance(fUno.year(), fUno.month(),fUno.day());
            Datetime tDos = datetime.newInstance(fDos.year(), fDos.month(),fDos.day());
            
            vuelos = [Select id, Name, Aeropuerto_de_partida__r.Name,Aeropuerto_de_llegada__r.Name From Product2 Where Fecha_y_hora_de_partida__c >=: tUno
                      AND Fecha_y_hora_de_partida__c <=: tDos AND Aeropuerto_de_partida__r.Ciudad__c =: ciudadPartida
                      AND Aeropuerto_de_llegada__r.Ciudad__c =: ciudadLlegada];
            list<String> idVuelos = new List<String>();
            For(Product2 a: vuelos){
                idVuelos.add(a.Id);
            }
            //precios = [select ID, UnitPrice, Pricebook2Id ,Product2Id From PricebookEntry Where Product2Id In :idVuelos AND IsActive = true];
            Precios = [Select Name,(select ID, UnitPrice, Pricebook2Id ,Product2Id From PricebookEntries Where Product2Id In :idVuelos AND IsActive = true) From Pricebook2];
            mensaje = 'La operacion se realizo correctamente';
            exito = true;
            wrapper = new VuelosWrapper(vuelos,mensaje,exito,precios);
            return wrapper;
        }catch(exception e){
            if(mensaje == null){
                mensaje = 'desde el catch: '+e; 
            }
            exito = false;
            wrapper = new VuelosWrapper(vuelos,mensaje,exito, precios);
            return wrapper;
        }
    }

    global class VuelosWrapper{
        public list<Product2> vuelo;
        public string mensaje;
        public boolean exito;
        public List<Sobject> precio;
        
        public VuelosWrapper(List<Product2> vuelos, string mensajito, boolean exitoso, List<Sobject> precios){
            vuelo = vuelos;
            mensaje = mensajito;
            exito = exitoso;
            precio = Precios;
        }
    }
}