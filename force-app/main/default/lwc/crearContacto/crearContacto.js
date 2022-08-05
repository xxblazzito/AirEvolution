import { LightningElement,api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CrearContacto extends LightningElement {
   
    @api tipoId;
    @api numId;
    
    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Contacto creado',
            message: 'Se ha creado un Contacto con ID: ' + event.detail.id,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }
}