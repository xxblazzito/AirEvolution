import { LightningElement, api ,wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Product2.Name';
import PILOTO from '@salesforce/schema/Product2.Piloto__c';
import COPILOTO from '@salesforce/schema/Product2.Copiloto__c';
import obtenerAuxiliares from '@salesforce/apex/TripulacionRequerida.getAuxiliares';
import guardarAuxiliares from '@salesforce/apex/TripulacionRequerida.saveAuxiliares';

export default class EditarVuelo extends LightningElement {
    @api vueloId;
    nameField = NAME_FIELD;
    piloto = PILOTO;
    copiloto = COPILOTO;
    options = [];
    values = [];
    _selected = [];
    
    @wire(obtenerAuxiliares, {idVuelo : '$vueloId'})
    tripulantes({error,data}) {
        if (data){
            this.options = data.map(key => ({value: key.value, label: key.label}));
            this.values = data.filter(element => element.selected == true).map (key => key.value); // no entendo
        } else if(error){
            console.log('error-->'+JSON.stringify(error));
        }
    }

    handleChange(e){
        this._selected = e.detail.value;
    }

    handleSuccess(event){
        if(this._selected.length == 0){
            this._selected = this.values;
        }
        guardarAuxiliares({auxiliares : this._selected, idVuelo : this.vueloId})
        .then((result)=> {
            console.log('success');
            this.error = undefined;
        })
        .catch((error)=> {
            this.error = error;
            console.log(error);
        });

    }

}