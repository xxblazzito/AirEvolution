import { LightningElement } from 'lwc';
import iniciarSesion from '@salesforce/apex/GestionSesion.iniciarSesion';
import nuevaSesion from '@salesforce/apex/GestionSesion.crearSesion';
import codigoVerificar from '@salesforce/apex/GestionSesion.enviarRecuperacion';
import comprobarCodigo from '@salesforce/apex/GestionSesion.validarVerificacion';
import cambiarPassword from '@salesforce/apex/GestionSesion.cambiarPass';
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
    nickR;
    datosRestore;
    restaurando;
    codigoR;
    codigoValidado;
    validando;
    passR1;
    passR2;

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
                console.log("usuario creado-->"+this.usuarioC);
                break;
            case 'mailC':
                this.correoC = event.detail.value;
                console.log("correo creado-->"+this.correoC);
                break;
            case 'pass1C':
                this.password1C = event.detail.value;
                break;
            case 'pass2C':
                this.password2C = event.detail.value;
                break;

            case 'nickR':
                this.nickR = event.detail.value;
                console.log("nick recuperacion-->"+this.nickR);
                break;

            case 'codigoR':
                this.codigoR = event.detail.value;
                console.log("codigo de validacion-->"+this.codigoR);
                break;

            case 'passR1':
                this.passR1 = event.detail.value;
                break;

            case 'passR2':
                this.passR2 = event.detail.value;
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

    solicitarCodigo(){
        codigoVerificar({nick: this.nickR})
            .then((resultado)=> {
                this.datosRestore = resultado;
                if(resultado != null){
                    console.log('Codigo de verificacion enviado con exito!');
                    this.restaurando = true;
                }
                else{
                    console.log('El usuario digitado no se ha encontrado');
                }
            }).catch((error)=> {
                console.log('Ha ocurrido un error al intentar recuperar la cuenta');
                console.log(error);
            })
    }

    validarCodigo(){
        comprobarCodigo({nick: this.nickR, codigo: this.codigoR})
            .then((resultado)=> {
                if(resultado != null){
                    if(resultado = true){
                        console.log('Codigo Correcto');
                        this.codigoValidado = true;
                        this.notificacion('Codigo de Verificacion validado Correctamente');
                        this.validando = true;
                    }else{
                        console.log('Codigo Invalido');
                        this.codigoValidado = false;
                        this.notificacionMala('Codigo de Verificacion invalido');
                    }
                }else{
                    console.log('se ha producido un error validando el codigo');
                }
            }).catch((error)=>{
                this.notificacionMala('error inesperado al validar el codigo');
                console.log('error validar codigo->');
                console.log(error);
            })
    }

    cambiarPass(){
        cambiarPassword({nick: this.nickR, pass1: this.passR1 , pass2: this.passR2})
            .then((resultado)=> {
                if(resultado != null){
                    console.log('la contraseña fue actualizada exitosamente');
                    console.log('Contraseña nueva-->');
                    console.log(resultado);
                    this.notificacion('Contraseña actualizada correctamente');
                }else{
                    console.log('Las contraseñas no coinciden');
                    console.log(resultado);
                    this.notificacionMala('Las contraseñas no coinciden');
                }
            }).catch((error)=>{
                this.notificacionMala('se ha producido un error al intentar actualizar la contraseña');
            })
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