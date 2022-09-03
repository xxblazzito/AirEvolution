import { LightningElement } from 'lwc';
import iniciarSesion from '@salesforce/apex/GestionSesion.iniciarSesion';
import nuevaSesion from '@salesforce/apex/GestionSesion.crearSesion';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class IniciarSesion extends LightningElement {
    sesion;
    usuario;
    password;
    datos;
    error;
    creandoSesion=false;
    usuarioC;
    correoC;
    password1C;
    password2C;
    datosNuevaSesion;
    errorNuevaSesion;
    isModalOpen;

    handleChange(event) {
        /* Una declaración de cambio que se usa para determinar qué input se está usando. */
         switch(event.target.name){
             case 'nick':
                 this.usuario = event.detail.value;
                 console.log("usuario-->"+this.usuario);
                 break;
             case 'pass':
                 this.password= event.detail.value;
                 console.log("numero-->"+this.password);
                 break;
            case 'nickC':
                this.usuarioC = event.detail.value;
                break;
            case 'mailC':
                this.correoC = event.detail.value;
                break;
            case 'pass1C':
                this.password1C = event.detail.value;
                break;
            case 'pass2C':
                this.password2C = event.detail.value;
                break;
         }
    }

    iniciar(){
        iniciarSesion({nick: this.usuario , pass: this.password})
            .then((resultado)=> {
                this.datos = resultado;
                this.error = undefined;
                console.log('usuario-->');
                console.log(resultado);
                if(resultado != null){
                    this.sesion = true;
                    this.notificacion('Bienvenid@: '+resultado.Name);
                }
            }).catch((errores) => {
                this.error = errores;
                this.datos = undefined;
                console.log('error:');
                console.log(errores);
            })
    }

    crear(){
        nuevaSesion({nick: this.usuarioC, pass: this.password1C, pass2: this.password2C, correo: this.correoC})
            .then((result)=> {
                this.datosNuevaSesion = result;
                if(result != null){
                    this.creandoSesion = false;
                    console.log('sesion creada con exito');
                    this.notificacion('La cuenta se ha creado exitosamente','bueno');
                }else{
                    console.log('Tu contraseña no coincide');
                    this.notificacionMala('La contraseña no coincide, reintentelo nuevamente');
                }
            }).catch((error)=> {
                this.errorNuevaSesion = error;
                console.log('Ha ocurrido un error al crear la nueva cuenta');
                this.notificacionMala('Error al crear la cuenta, si el error persiste comuniquese con soporte tecnico');
            })
    }

    restorePass(){
        console.log('Recuperando la contraseña');
        this.isModalOpen = true;
    }

    createSesion(){
        console.log('Creanding cuenta');
        this.creandoSesion = true;
    }

    notificacion(mensaje){
        const event = new ShowToastEvent({
            title: 'Accion Exitosa',
            message:
                mensaje,
            variant: 'success',
        });
        this.dispatchEvent(event);
    }

    notificacionMala(mensaje){
        const event = new ShowToastEvent({
            title: 'Error',
            message:
                mensaje,
            variant: 'error',
        });
        this.dispatchEvent(event);
    }

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    
}