import {api, LightningElement} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {createRecord} from 'lightning/uiRecordApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import TITULARDERESERVA from '@salesforce/schema/Opportunity.Titular_de_la_reserva__c';
import ESTADO from '@salesforce/schema/Opportunity.StageName';


export default class Createreserva extends LightningElement {
    @api contactId;

    objectApiName= OPPORTUNITY_OBJECT;
    
    estado="Pre-venta";

    createReserva(){
        const fields ={}
        fields[TITULARDERESERVA.fieldApiName] = this.contactId;
        fields[ESTADO.fieldApiName] = this.estado;
        
        const recordInput ={apiName: OPPORTUNITY_OBJECT.objectApiName, fields };
        createRecord(recordInput)

        .then(opportunity =>{
            this.opportunityId=opportunity.id;
            console.log(fields);
            console.log('Cuenta agregada con éxito');
            this.handleSuccess();
        })
        .catch(error => {
            console.error(error);
        })
    
    }
    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Reserva creada',
            message: 'Se ha creado la reserva con Exito',
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }
}