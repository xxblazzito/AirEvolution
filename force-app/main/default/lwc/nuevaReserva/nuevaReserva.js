/* importa todo lo necesario para el componente. */
import { LightningElement, wire, track, api } from 'lwc';
import comprobarContacto from '@salesforce/apex/contactoReserva.clienteReserva'; 
import crearteReserva from '@salesforce/apex/contactoReserva.crearReserva';

export default class NuevaReserva extends LightningElement {
    value = 'Cedula de Ciudadania';
    contactito;
    error;
    idContacto;
    numeroIdent;
    crearReserva;
    reserva;
    erro2;
    

    //valores de la reserva creada
    reservaNuevaInfo;
    erroresReserva;
    creardaReservita;
    precioSeleccionado;

    // Booleans para activar y desactivar secciones
    existeContacto;
    noExisteContacto;
    reservaExiste;
    reservaNoExiste;
    openModal;
    
    get options() {
        return [
            { label: 'Cedula de Ciudadania', value: 'Cedula de Ciudadania' },
            { label: 'Cedula de Extranjeria', value: 'Cedula de Extranjeria' },
            { label: 'Tarjeta de Identidad', value: 'Tarjeta de Identidad' },
        ];
    }

    get listadoPrecios() {
        return [
            { label: 'Clase Turista', value: 'Turista'},
            { label: 'Clase Negocios', value: 'Negocio'},
        ];
    }

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.openModal = false;
    }

    handleChange(event) {
        
        switch(event.target.name){
            case 'tipoId':
                this.value = event.detail.value;
                console.log("lista-->"+this.value);
                break;
            case 'nroId':
                this.numeroIdent= event.detail.value;
                console.log("numero-->"+this.numeroIdent);
                break;
            case 'listaPrecio':
                this.precioSeleccionado = event.detail.value;
                console.log("lista de precios seleccionada-->"+ this.precioSeleccionado);
                break;
            
        }
    }

    get idcontact(){
        if(this.contactito != null){
            return this.contactito.Id;
        }else{
            return '';
        }
    }

    get namecontact(){
        if(this.contactito != null){
            return this.contactito.Name;
        }else{
            return '';
        }
    }
    get numidcontact(){
        if(this.contactito != null){
            return this.contactito.Numero_de_Identificacion__c;
        }else{
            return '';
        }
    }
    get pasaportecontact(){
        if(this.contactito != null){
            return this.contactito.Numero_de_pasaporte__c;
        }else{
            return '';
        }
    }

    get reservaName(){
        if(this.reservaNuevaInfo != null){
            return this.reservaNuevaInfo.Name;
        }else{
            return '';
        }
    }

    get reservaEstado(){
        if(this.reservaNuevaInfo != null){
            return this.reservaNuevaInfo.StageName;
        }else{
            return '';
        }
    }

    get reservaId(){
        if(this.reservaNuevaInfo != null){
            return this.reservaNuevaInfo.Id;
        }else{
            return '';
        }
    }

    get reservaListaPrecio(){
        if(this.reservaNuevaInfo != null){
            return this.reservaNuevaInfo.Pricebook2Id;
        }else{
            return '';
        }
    }

    buscarContacto(event){
        console.log(this.numeroIdent + this.value);
        comprobarContacto({tipoId: this.value, numId: this.numeroIdent})
            .then((result) => {
                this.contactito= result.contacto;
                this.reserva = result.oportunidad;
                console.log('contacto-->'+this.contactito);
                console.log('oportunidad-->'+this.reserva);
                if(this.contactito == undefined){
                    this.noExisteContacto = true;
                    this.existeContacto = false;
                }else{
                    this.existeContacto = true;
                    this.noExisteContacto = false;
                    if(this.reserva == undefined){
                        this.openModal = true;
                        this.reservaNoExiste = true;
                        this.reservaExiste = false;

                    }else{
                        this.openModal = true;
                        this.reservaExiste = true;
                        this.creardaReservita = false; 
                        this.reservaNoExiste = false;
                    }
                }
                this.error = undefined;
                
            }).catch((error) => {
                this.error = error;
                this.contactito = undefined;
                this.reserva = undefined;
            });

    }
   
    createReserva(event){
        console.log('se va a crear la reserva');
        crearteReserva({idContactito: String(this.contactito.Id),listaPrecio: this.precioSeleccionado})
                        .then((result) => {
                            console.log('resultado-->'+result);
                            this.erroresReserva = undefined;
                            this.reservaNuevaInfo = result;
                            this.creardaReservita = true;
                        }).catch((error)=>{
                            this.erroresReserva = error;
                            console.log(error);
                            this.reservaNuevaInfo = undefined;
                        })
    }
}