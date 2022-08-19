/* Importando los módulos necesarios para que el componente funcione. */
import { LightningElement, wire, track, api } from 'lwc';
import listaVuelos from '@salesforce/apex/contactoReserva.obtenerVuelos';
import listaPasajeros from '@salesforce/apex/contactoReserva.obtenerPasajeros';
import creacionTiquete from '@salesforce/apex/contactoReserva.crearTiquete';
import comprobarContacto from '@salesforce/apex/contactoReserva.clienteReserva'; 
import creacionPasajero from '@salesforce/apex/contactoReserva.crearTiquete';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

/* Definición de las columnas de la tabla. */
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

/* Declarar las columnas de la tabla que se utilizarán para mostrar los pasajeros. */
const columnas = [
    {label: 'Nombre del pasajero', fieldName: 'nombre'},
    {label: 'Asiento', fieldName: 'asiento'},
    {label: 'Vuelo', fieldName: 'vueloName'},
]

export default class ListarVuelos extends LightningElement {
   /* Declarar las variables que se utilizarán en el componente. */
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
    masPasajeros;
    @track tiquetesPrincipal;
    value = 'Cedula de Ciudadania';
    contactito;
    existeContacto = false;
    noExisteContacto = false;
    tiqueteExitoso = false;

    //tabla de pasajeros
    @track columnas = columnas;
    @track datos;

    /**
     * La función devuelve una matriz de objetos, cada objeto tiene una etiqueta y una propiedad de
     * valor
     * @returns Una matriz de objetos.
     */
    get options() {
        return [
            { label: 'Cedula de Ciudadania', value: 'Cedula de Ciudadania' },
            { label: 'Cedula de Extranjeria', value: 'Cedula de Extranjeria' },
            { label: 'Tarjeta de Identidad', value: 'Tarjeta de Identidad' },
        ];
    }

    handleChange(event) {
        
       /* Una declaración de cambio que se usa para determinar qué input se está usando. */
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

    listadoPasajeros(){
        console.log('Entro a lista pasajeros');
       /* Llamar al método listaPasajeros desde la clase de Apex contactoReserva. */
        listaPasajeros({idReserva: this.idReserva , idTitular: this.idContacto})
            .then((resultado)=> {
                this.datos = resultado;
                this.masPasajeros = true;
                console.log('lista pasajeros');
                console.log(resultado);
            }).catch((errores) => {
                console.log('error:');
                console.log(errores);
            })
    }

   /**
    * Obtiene la ista de vuelos por el metodo Wire.
    */
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
       /* Obtener las filas seleccionadas de la tabla de datos y luego está insertando la
       identificación de las filas seleccionadas en una matriz. */
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
        /* Llamando al método creacionTiquete desde la clase de Apex contactoReserva. */
        creacionTiquete({reserva: this.idReserva, vuelo: this.ids, contacto: this.idContacto})
            .then((resultado)=> {
                this.tiquetesPrincipal = this.resultado;
                console.log('se ha creado exitosamente los tiquetes');
                this.tiqueteExitoso = true;
                this.error= undefined;
                this.notificacion('Se han creado exitosamente los tiquetes');
            }).catch((errores) => {
                console.log('error: '+this.errores);
            })
        } 
    } 

    /**
     * La función toma el objeto de evento del evento de ordenación de lightning-datatable y luego
     * establece los atributos sortBy y sortDirection en las propiedades fieldName y sortDirection del
     * objeto de evento.
     * @param evento - El objeto de evento que se pasa al controlador de eventos.
     */
    doSorting(evento) {
        this.sortBy = evento.detail.fieldName;
        this.sortDirection = evento.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    /**
     * Toma los datos y los ordena según el nombre del campo y la dirección.
     * @param fieldname - El nombre del campo por el que ordenar.
     * @param direction - La dirección del género. Puede ser 'asc' o 'desc'.
     */
    sortData(fieldname, direction) {
        /* Creación de una copia de la matriz de datos. */
        let parseData = JSON.parse(JSON.stringify(this.data));
        // Retorna los valores almacenados en el campo.
        let keyValue = (a) => {
            return a[fieldname];
        };
        // verifica la direccion.
        let isReverse = direction === 'asc' ? 1: -1;
        // organiza los datos.
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
        /* Este es un método que está llamando al método de Apex `comprobarContacto` y pasando los
        parámetros `tipoId` y `numId`. para validar si el contacto existe.*/
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

    /**
     * Borra el campo de entrada y la variable numeroIdent.
     */
    limpiar(){
        this.value = '';
        this.numeroIdent = '';
        this.existeContacto = false;
    }

    crearPasajero(){
        console.log('crear pasajero');
        /* Este es un método que llama al método Apex `creacionPasajero` y le pasa los parámetros
        `reserva`, `vuelo` y `contacto`. Crea el Tiquete de los demas Pasajeros. */
        creacionPasajero({reserva: this.idReserva, vuelo: this.ids, contacto: this.idcontact})
            .then((resultado)=> {
                this.tiquetesPrincipal = resultado;
                console.log('se ha creado exitosamente los tiquetes');
                this.tiqueteExitoso = true;
                this.error= undefined;
                this.notificacion('Se ha agregado correctamente el pasajero');
                this.listadoPasajeros();
            }).catch((errores) => {
                console.log('error: ');
                console.log(errores);
            })
    }

    /**
     * Muestra una notificación en la pantalla.
     * @param mensaje - El mensaje que desea mostrar.
     */
    notificacion(mensaje){
        const event = new ShowToastEvent({
            title: 'Accion Exitosa',
            message:
                mensaje,
            variant: 'success',
        });
        this.dispatchEvent(event);
    }
    
}