import { api, LightningElement, wire } from 'lwc';
import {createRecord} from 'lightning/uiRecordApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME from '@salesforce/schema/Contact.FirstName';
import LASTNAME from '@salesforce/schema/Contact.LastName';
import TIPOIDENTIFICACION from '@salesforce/schema/Contact.Tipo_de_Identificacion__c';
import NUMEROIDENTIFICACION from '@salesforce/schema/Contact.Numero_de_Identificacion__c';
import NUMEROPASAPORTE from '@salesforce/schema/Contact.Numero_de_pasaporte__c';
import FECHANACIMIENTO from '@salesforce/schema/Contact.ffecha_de_nacimiento__c';
import CORREOELECTRONICO from '@salesforce/schema/Contact.Email';
import NACIONALIDAD from '@salesforce/schema/Contact.Nacionalidad__c';



export default class Upsertcliente extends LightningElement {
    objectApiName = CONTACT_OBJECT;
    contactId;
    firstName='';
    lastName='';
    tipoDeIdentificacion=''; 
    numeroDePasaporte='';
    fechaDeNacimiento='';
    correoElectronico='';
    nacionalidad='';

    handleContactChange(event) {
        switch(event.target.name){
            case 'firstName':
                this.firstName = event.target.value;
                break;
            case 'lastName':
                this.lastName = event.target.value;
                break;
            case 'tipoDeIdentificacion':
                this.tipoDeIdentificacion = event.target.value;
                break;
            case 'numeroDeIdentificacion':
                this.numeroDeIdentificacion = event.target.value;
                break;  
            case 'numeroDePasaporte':
                this.numeroDePasaporte = event.target.value;
                break;
            case 'fechaDeNacimiento':
                this.fechaDeNacimiento = event.target.value;
                break;
            case 'correoElectronico':
                this.correoElectronico = event.target.value;
                break;
            case 'nacionalidad':
                this.nacionalidad = event.target.value;
                break;
        }
    }

    createContact(){
        const fields = {}
        fields[FIRSTNAME.fieldApiName] = this.firstName;
        fields[LASTNAME.fieldApiName] = this.lastName;
        fields[TIPOIDENTIFICACION.fieldApiName] = this.tipoDeIdentificacion;
        fields[NUMEROIDENTIFICACION.fieldApiName] = this.numeroDeIdentificacion;
        fields[NUMEROPASAPORTE.fieldApiName] = this.numeroDePasaporte;
        fields[FECHANACIMIENTO.fieldApiName] = this.fechaDeNacimiento;
        fields[CORREOELECTRONICO.fieldApiName] = this.correoElectronico;
        fields[NACIONALIDAD.fieldApiName] = this.nacionalidad;
        //console.log(fields);
        const recordInput ={apiName: CONTACT_OBJECT.objectApiName, fields };
        createRecord(recordInput)
        .then(contact => {
            this.contactId = contact.id;
            console.log(fields);
            console.log('Cuenta agregada con éxito');
        })
        .catch(error => {
            
            console.error(error);
        })
    }
}