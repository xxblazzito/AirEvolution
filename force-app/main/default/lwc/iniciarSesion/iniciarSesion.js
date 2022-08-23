import { LightningElement } from 'lwc';
import iniciarSesion from '@salesforce/apex/GestionSesion.iniciarSesion';

export default class IniciarSesion extends LightningElement {
    sesion;
    usuario;
    password;
    datos;
    error;

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
                }
            }).catch((errores) => {
                this.error = errores;
                this.datos = undefined;
                console.log('error:');
                console.log(errores);
            })
    }

    restorePass(){
        console.log('Recuperando la contraseña');
    }

    createSesion(){
        console.log('Creanding cuenta');
    }
}