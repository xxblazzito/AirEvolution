import { LightningElement, wire, track, api } from 'lwc';
 import listaVuelos from '@salesforce/apex/contactoReserva.obtenerVuelos';

const columns = [
    { label: 'Nombre del Vuelo', fieldName: 'codigo', sortable: "true" },
    { label: 'Aeropuerto de Partida', fieldName: 'aeropuertoPartida',wrapText: true, sortable: "true"},
    { label: 'Pais de Partida', fieldName: 'aeropuertoPartidaPais',wrapText: true, sortable: "true"},
    { label: 'Aeropuerto de Llegada', fieldName: 'aeropuertoLlegada',wrapText: true, sortable: "true"},
    { label: 'Pais de Llegada', fieldName: 'aeropuertoLlegadaPais',wrapText: true, sortable: "true"},
    { label: 'Precio de Venta', fieldName: 'precioUnitario', wrapText: true, sortable: "true"},
    { label: 'Fecha y Hora de Partida', fieldName: 'fechaPartida',wrapText: true, type: "date",
    typeAttributes:{
        year: "numeric",
        month: "long",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit"
    } },
    { label: 'fecha y Hora de Llegada', fieldName: 'fechaLlegada',wrapText: true, type: "date",
    typeAttributes:{
        year: "numeric",
        month: "long",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit"
    } },
];

export default class ListarVuelos extends LightningElement {
    @track columns = columns;
    @track data;
    @track sortBy;
    @track sortDirection;
    @track isModalOpen = false;
    @api idPrecio;

    @wire(listaVuelos,{idListaPrecios: '$idPrecio'})vuelos(result){
        console.log(this.idPrecio);
        console.log(result);
        if (result.data) {
            console.log('si trajo algo');
            this.data = result.data;
            this.error = undefined;
        } else if (result.error) {
            console.log('no trajo nada');
            console.log(result.error);
            this.error = result.error;
            this.data = undefined;
        }
    }

    getSelectedRec() {
        this.isModalOpen = true;
        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();
        if(selectedRecords.length > 0){
            console.log('selectedRecords are ', selectedRecords);
            console.log('id precio'+ this.idPrecio );
   
            let ids = '';
            selectedRecords.forEach(currentItem => {
                ids = ids + ',' + currentItem.idVuelo;
            });
            this.selectedIds = ids.replace(/^,/, '');
            this.lstSelectedRecords = selectedRecords;
            console.log(this.selectedIds);
        }   
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction
        let isReverse = direction === 'asc' ? 1: -1;
        // sorting data
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    } 

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
}