import {api, LightningElement} from 'lwc';
import {createRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import TITULARDERESERVA from '@salesforce/schema/Opportunity.Titular_de_la_reserva__c';
import ESTADO from '@salesforce/schema/Opportunity.StageName';
import FECHADEPAGO from '@salesforce/schema/Opportunity.CloseDate';
import NOMBREDERESERVA from '@salesforce/schema/Opportunity.Name';

export default class CrearOEditarReserva extends LightningElement {
    @api recordId;

    objectApiName= OPPORTUNITY_OBJECT;
    
    estado="Pre-venta";
    fecha= new Date().toISOString().slice(0,10);
    nombre='a';


        

    createReserva(){
        const fields ={}
        fields[TITULARDERESERVA.fieldApiName] = this.recordId;
        fields[ESTADO.fieldApiName] = this.estado;
        fields[FECHADEPAGO.fieldApiName] = this.fecha;
        fields[NOMBREDERESERVA.fieldApiName] = this.nombre;
        
        const recordInput ={apiName: OPPORTUNITY_OBJECT.objectApiName, fields };
        console.log(recordInput);
        createRecord(recordInput)

        .then(opportunity =>{
            this.opportunityId=opportunity.id;
            console.log(fields);
            console.log('Cuenta agregada con éxito');
            this.dispatchEvent(new ShowToastEvent({
                title: 'Exito',
                message: 'Se ha creado una reserva exitosamente',
                variant: 'success',
            }))
        })
        .catch(error => {
            console.error(error);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Se ha producido un error',
                variant: 'Error',
            }))
        })
    
    }
}