@RestResource(urlMapping ='/Product2/*')
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
    
    @HttpPost
    global static ReservaWrapper createReserva(String idEntradaPrecio, String nombre,String apellido, String tipoDocumento, String numeroDocumento, String Correo){
        String idContacto;
        String idReserva;
        String mensaje;
        Boolean exito;
        Opportunity reservaCreada = new Opportunity();
        OpportunityLineItem tiqueteCreado = new OpportunityLineItem();
        ReservaWrapper wrapper;
        if(idEntradaPrecio == null){
            exito = false;
            mensaje = 'Falta el ID de la Entrada de Lista de Precios';
            wrapper = new ReservaWrapper(reservaCreada,tiqueteCreado,mensaje,exito);
            return wrapper;
        }
        if(nombre == null || apellido == null){
            exito = false;
            mensaje = 'Debe Ingresar el Nombre Completo del Contacto';
            wrapper = new ReservaWrapper(reservaCreada,tiqueteCreado,mensaje,exito);
            return wrapper;
        }
        if(tipoDocumento == null){
            exito = false;
            mensaje = 'Debe Ingresar el Tipo de Documento';
            wrapper = new ReservaWrapper(reservaCreada,tiqueteCreado,mensaje,exito);
            return wrapper;
        }
        if(numeroDocumento == null){
            exito = false;
            mensaje = 'Debe Ingresar el Numero de Documento';
            wrapper = new ReservaWrapper(reservaCreada,tiqueteCreado,mensaje,exito);
            return wrapper;
        }
        
        try{
            PricebookEntry precioLista = [Select Id, UnitPrice, Pricebook2Id, Product2Id From PricebookEntry Where Id =: idEntradaPrecio Limit 1];
            
            List<Contact> contacto = [Select id From Contact where Tipo_de_Identificacion__c =: tipoDocumento AND Numero_de_Identificacion__c =: numeroDocumento Limit 1];
            
            if(contacto.size() == 1){
                idContacto = contacto[0].Id;
            }Else{
                Contact nuevoContacto = new Contact(firstName=nombre, lastName = apellido, Tipo_de_Identificacion__c= tipoDocumento, Numero_de_Identificacion__c= numeroDocumento, Email =Correo);
                insert nuevoContacto;
                idContacto = nuevoContacto.Id;
            }
            
            List<Opportunity> reserva = [Select Id,Name From Opportunity where Titular_de_la_reserva__c =: idContacto AND (StageName = 'Pre-venta' OR StageName = 'Completado') Limit 1];
            
            if(reserva.size() == 1){
                List<OpportunityLineItem> tiquete = [select id, name from OpportunityLineItem Where OpportunityId =: reserva[0].Id AND Product2Id =: precioLista.Product2Id Limit 1];
                reservaCreada = reserva[0];
                if(tiquete.size() == 1){
                    mensaje = 'El pasajero ya tiene asignada una reserva con dicho vuelo, no es posible asignarlo nuevamente';
                    exito = false;
                }else{
                    OpportunityLineItem nuevoTiquete = new OpportunityLineItem(Pasajero__c = idContacto, OpportunityId = reserva[0].Id, Product2Id = precioLista.Product2Id);
                    insert nuevoTiquete;
                    tiqueteCreado = nuevoTiquete;
                    mensaje = 'La reserva se actualizo y se agrego el vuelo correctamente';
                    exito = True;
                }
            }Else{
                Opportunity nuevaReserva = new Opportunity(Name = 'a',StageName ='Pre-Venta',Pricebook2Id = precioLista.Pricebook2Id, Titular_de_la_reserva__c = idContacto, CloseDate = Date.today());
                Insert nuevaReserva;
                reservaCreada = nuevaReserva;
                OpportunityLineItem nuevoTiquete = new OpportunityLineItem(Pasajero__c = idContacto, OpportunityId = nuevaReserva.Id, Product2Id = precioLista.Product2Id);
                Insert nuevoTiquete;
                tiqueteCreado = nuevoTiquete;
                mensaje = 'La reserva y el vuelo fueron Creados correctamente';
                exito = True;
                
            }
            wrapper = new ReservaWrapper(reservaCreada,tiqueteCreado,mensaje,exito);
            return wrapper;
        }catch (exception e){
            if(mensaje == null){
                mensaje = 'Se ha producido un error inesperado'+e;
            }
            exito = false;
            wrapper = new ReservaWrapper(reservaCreada,tiqueteCreado,mensaje,exito);
            return wrapper;
        }
    }
    
    @HttpPatch
    global static pagoWrapper pagarReserva(string idReserva, decimal Amount){
        String mensaje;
        Boolean exito;
        pagoWrapper wrapper;
        Opportunity actualizaReserva = new Opportunity();
        if(idReserva == null){
            mensaje = 'Debe de ingresar el id de la Reserva';
            exito = false;
            wrapper = new pagoWrapper(actualizaReserva, mensaje, exito);
            return wrapper;
        }
        if(Amount == null){
            mensaje = 'Debe de ingresar la cantidad de dinero';
            exito = false;
            wrapper = new pagoWrapper(actualizaReserva, mensaje, exito);
            return wrapper;
        }
        try{
            opportunity reserva = [select id,Name,Valor_Total__c, StageName, Titular_de_la_reserva__r.Name, Titular_de_la_reserva__r.Email from opportunity where Id =: idReserva limit 1];
            
            if (Amount >= reserva.Valor_Total__c){
                actualizaReserva.Id = reserva.Id;
                actualizaReserva.StageName = 'Pagado';
                mensaje = 'La reserva se ha pagado Correctamente';
                exito = true;
            }else{
                mensaje = 'fondos insuficientes para realizar el Pago';
                exito = false;
                opportunity reservaMala = null;
                wrapper = new pagoWrapper(reservaMala,mensaje,exito);
                return wrapper;
            }
            try{
                enviarCorreo.enviarCorreos(reserva);
                update actualizaReserva;
            }catch(exception e){
                mensaje = 'Error al actualizar la reserva y/o enviar el correo electronico' + e;
                exito = false;
                opportunity reservaMala = null;
                wrapper = new pagoWrapper(reservaMala,mensaje,exito);
                return wrapper;
            }
            wrapper = new pagoWrapper(actualizaReserva,mensaje,exito);
            return wrapper;
        }catch(exception e){
            exito = false;
            if(mensaje == null){
                mensaje= 'ha ocurrido un error inesperado: '+ e;
            }
            wrapper = new pagoWrapper(actualizaReserva,mensaje,exito);
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
    
    global class ReservaWrapper{
        public Opportunity reserva;
        public OpportunityLineItem tiquete;
        public string mensaje;
        public boolean exito;
        
        public ReservaWrapper(Opportunity reservita,OpportunityLineitem tiquetito, string mensajito, boolean exitoso){
            reserva = reservita;
            tiquete = tiquetito;
            mensaje = mensajito;
            exito = exitoso;
        }
    }
    
    global class pagoWrapper{
        public Opportunity reserva;
        public string mensaje;
        public boolean exito;
        
        public pagoWrapper(Opportunity reservita, string mensajito, boolean exitoso){
            reserva = reservita;
            mensaje = mensajito;
            exito = exitoso;
        }
    }
    
    public class MyException extends Exception {}
}