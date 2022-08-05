import { LightningElement, wire} from 'lwc';
import obtenerVuelos from '@salesforce/apex/TripulacionRequerida.obtenerVuelos';


const actions = [
    { label: 'Asignar', name: 'asignar' },
    
];

const columns = [
    { label: 'Código', fieldName: 'codigo' },
    { label: 'Auxiliares Requeridos', fieldName: 'auxiliaresRequeridos', type: 'number' },
    { label: 'Auxiliares Faltantes', fieldName: 'auxiliaresFaltantes', type: 'number' },
    { label: 'Tiene Piloto', fieldName: 'piloto', type: 'boolean' },
    { label: 'Tiene Copiloto', fieldName: 'copiloto', type: 'boolean' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }
];

export default class AsignarTripulacion extends LightningElement {
    Id;
    codigoDeVuelo;
    auxRequeridos;
    auxFaltantes;
    tienePiloto=false;
    tieneCopiloto=false;
    get vueloId(){
        return this.Id;
    }
    _selected = [];
    
    isModalOpen;
    columns = columns;
    @wire(obtenerVuelos)vuelos;

    handlerRowAction(event){
         
        this.isModalOpen = true;
        this.datos = event.detail.row;
        console.log(this.datos);
        this.codigoDeVuelo = this.datos.codigo;
        this.auxFaltantes = this.datos.auxiliaresFaltantes;
        this.auxRequeridos = this.datos.auxiliaresRequeridos;
        this.tienePiloto = this.datos.piloto;
        this.tieneCopiloto = this.datos.copiloto;
        this.Id = this.datos.idVuelo;
    }

    handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }

    closeModal(event){
        this.isModalOpen = false;
    }

    

    get selected() {
        return this._selected.length ? this._selected : 'none';
    }

    handleChange(e) {
        this._selected = e.detail.value;
    }
    
    
}