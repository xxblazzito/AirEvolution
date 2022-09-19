@RestResource(urlMapping ='/ReservaRest/*')
global with sharing class ReservaRest {

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
    global static pagoWrapper pagarReserva(string idReserva, boolean aprobado){
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
        if(aprobado == null){
            mensaje = 'No se ha podido validar el pago con entidad Bancaria';
            exito = false;
            wrapper = new pagoWrapper(actualizaReserva, mensaje, exito);
            return wrapper;
        }
        try{
            opportunity reserva = [select id,Name,Valor_Total__c, StageName, Titular_de_la_reserva__r.Name, Titular_de_la_reserva__r.Email from opportunity where Id =: idReserva limit 1];
            
            if (aprobado == true){
                actualizaReserva.Id = reserva.Id;
                actualizaReserva.StageName = 'Pagado';
                mensaje = 'La reserva se ha pagado Correctamente';
                exito = true;
            }else{
                mensaje = 'Su pago ha sido Rechazado, por favor comuniquese con su entidad bancaria.';
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
}