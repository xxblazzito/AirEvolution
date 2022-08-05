import {api, LightningElement, wire } from 'lwc';
import { updateRecord,createRecord,getFieldValue, getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account'
import NAME_FIELD from '@salesforce/schema/Account.Name';
import ID_FIELD from '@salesforce/schema/Account.Id';

export default class Helloword extends LightningElement {
    @api recordId = '0018a00001pTnVIAA0';
    accountId;
    name = '';
    @wire(getRecord, {recordId:  '$recordId', fields:[NAME_FIELD]})
    record;

    get acctName(){
        return this.record.data ? getFieldValue(this.record.data, NAME_FIELD): '';
    }
    handleNameChange(event){
        this.accountId = undefined;
        this.name = event.target.value;
    }
    createAccount(){
        const fields = {}
        fields[NAME_FIELD.fieldApiName] = this.name;
        const recordInput ={apiName: ACCOUNT_OBJECT.objectApiName, fields };
        createRecord(recordInput)
        .then(account => {
            this.accountId = account.id;
            console.log('Cuenta agregada con éxito');
        })
        .catch(error => {
            console.error(error);
        })
    }

    updateAccount(){
        const fields = {}
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[NAME_FIELD.fieldApiName] = this.name;
        const recordInput ={ fields };
        updateRecord(recordInput)
        .then(() => {
            
            console.log('Cuenta actualizada con éxito');
        })
        .catch(error => {
            console.error(error);
        })
    }
    


}