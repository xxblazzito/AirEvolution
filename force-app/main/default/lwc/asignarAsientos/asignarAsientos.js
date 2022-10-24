import { LightningElement, api, wire, track } from 'lwc';
import listaAsiento from '@salesforce/apex/asientos.listarAsientos';
import asignarAsiento from '@salesforce/apex/asientos.asignarAsiento';
import { refreshApex } from '@salesforce/apex';

const columns = [
    { label: 'Numero de Asiento', fieldName: 'Name', wrapText: true},
    { label: 'Tipo de Asiento', fieldName: 'Tipo__c',wrapText: true},
    { type: "button", typeAttributes: {  
        label: 'Asignar',  
        name: 'Asignar',  
        title: 'Asignar',  
        disabled: false,  
        value: 'Asignar',  
        iconPosition: 'left'  
    } }
];

export default class AsignarAsientos extends LightningElement {
    @api recordId;
    @track data;
    @track columns = columns;
    @track asignado;
    info;
    @track asientoSelected;
    @track creado;
    asientosResultado;
    nombreAsiento;
    tipoAsiento;

    @wire(listaAsiento,{idTiquete: '$recordId'})asientos(result){
        console.log(result);
        this.asientosResultado = result;
        if (result.data) {
            console.log('si trajo algo');
            this.asignado = result.data.asignado;
            if(this.asignado === false){
                this.data = result.data.disponibles;
            }else{
                this.info = result.data.asiento;
                this.nombreAsiento = result.data.asiento.Name;
                this.tipoAsiento = result.data.asiento.Tipo__c;
            }
            
            this.error = undefined;
            console.log(this.data);
        } else if (result.error) {
            console.log('no trajo nada');
            console.log(result.error);
            this.error = result.error;
            this.data = undefined;
        }
    }

    Asignacion(event){ 
        const actionName = event.detail.action.name; 

        if( actionName === 'Asignar'){
            this.asientoSelected = event.detail.row.Id;
            console.log(this.asientoSelected);
            console.log(event.detail.row.Name);
            this.asignarAsiento();
        }
    }

    asignarAsiento(){
        asignarAsiento({idTiquete: this.recordId , idAsiento: this.asientoSelected})
            .then((resultado)=> {
                this.creado = resultado;
                console.log(resultado);
                eval("$A.get('e.force:refreshView').fire();");
                refreshApex(this.asientosResultado);
                refreshApex(this.info);
            }).catch((errores) => {
                console.log('error:');
                console.log(errores);
            })
    }
}