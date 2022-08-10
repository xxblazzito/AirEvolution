import { LightningElement, wire, track, api } from 'lwc';
import listaVuelos from '@salesforce/apex/contactoReserva.obtenerVuelos';
import creacionTiquete from '@salesforce/apex/contactoReserva.crearTiquete';
import comprobarContacto from '@salesforce/apex/contactoReserva.clienteReserva'; 

const columns = [
    { label: 'Nombre del Vuelo', fieldName: 'codigo', sortable: "true" },
    { label: 'Aeropuerto de Partida', fieldName: 'aeropuertoPartida',wrapText: true, sortable: "true"},
    { label: 'Pais de Partida', fieldName: 'aeropuertoPartidaPais',wrapText: true, sortable: "true"},
    { label: 'Aeropuerto de Llegada', fieldName: 'aeropuertoLlegada',wrapText: true, sortable: "true"},
    { label: 'Pais de Llegada', fieldName: 'aeropuertoLlegadaPais',wrapText: true, sortable: "true"},
    { label: 'Precio de Venta', fieldName: 'precioUnitario', wrapText: true, sortable: "true", type:"currency"},
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
    @track idsVuelos;
    @api idPrecio;
    @api idContacto;
    @api idReserva;
    ids= [];
    idVueloSolito;
    @track tiquetesPrincipal;
    value = 'Cedula de Ciudadania';
    contactito;
    existeContacto = false;
    noExisteContacto = false;
    tiqueteExitoso = false;

    get options() {
        return [
            { label: 'Cedula de Ciudadania', value: 'Cedula de Ciudadania' },
            { label: 'Cedula de Extranjeria', value: 'Cedula de Extranjeria' },
            { label: 'Tarjeta de Identidad', value: 'Tarjeta de Identidad' },
        ];
    }

    handleChange(event) {
        
        switch(event.target.name){
            case 'tipoId':
                this.value = event.detail.value;
                console.log("lista-->"+this.value);
                break;
            case 'nroId':
                this.numeroIdent= event.detail.value;
                console.log("numero-->"+this.numeroIdent);
                break;
        }
    }

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
        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();
        if(selectedRecords.length > 0){
            console.log('selectedRecords are ', selectedRecords);
            console.log('id precio'+ this.idPrecio );
            selectedRecords.forEach(currentItem => {
                //ids = ids + ',' + currentItem.idVuelo;
                this.idVueloSolito= currentItem.idVuelo;
                console.log('vuelo actual: '+ this.idVueloSolito);
                this.ids.push(this.idVueloSolito);
        });
        console.log('array vuelos'+ this.ids.length);
        console.log(this.ids);
        creacionTiquete({reserva: this.idReserva, vuelo: this.ids, contacto: this.idContacto})
            .then((resultado)=> {
                this.tiquetesPrincipal = this.resultado;
                console.log('se ha creado exitosamente los tiquetes');
                this.tiqueteExitoso = true;
                this.error= undefined;
            }).catch((errores) => {
                console.log('error: '+this.errores);
            })
        } 
    } 

    doSorting(evento) {
        this.sortBy = evento.detail.fieldName;
        this.sortDirection = evento.detail.sortDirection;
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

    get idcontact(){
        if(this.contactito != null){
            return this.contactito.Id;
        }else{
            return '';
        }
    }

    get namecontact(){
        if(this.contactito != null){
            return this.contactito.Name;
        }else{
            return '';
        }
    }

    get numidcontact(){
        if(this.contactito != null){
            return this.contactito.Numero_de_Identificacion__c;
        }else{
            return '';
        }
    }

    get pasaportecontact(){
        if(this.contactito != null){
            return this.contactito.Numero_de_pasaporte__c;
        }else{
            return '';
        }
    }

    buscarContacto(event){
        console.log(this.numeroIdent + this.value);
        comprobarContacto({tipoId: this.value, numId: this.numeroIdent})
            .then((result) => {
                this.contactito= result.contacto;
                console.log('contacto-->'+this.contactito);
                if(this.contactito == undefined){
                    this.noExisteContacto = true;
                    this.existeContacto = false;
                }else{
                    this.existeContacto = true;
                    this.noExisteContacto = false;
                }
                this.error = undefined;
                
            }).catch((error) => {
                this.error = error;
                this.contactito = undefined;
            });

    }

    notificacion(mensaje){
        
    }
    
}