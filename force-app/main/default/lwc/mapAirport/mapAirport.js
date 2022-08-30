import { LightningElement, wire, track, api } from 'lwc';
import listaAeropuertos from '@salesforce/apex/geolocalizacion.obtenerUbicacion';

export default class MapAirport extends LightningElement {

    @track mapMarkers = [];
    @track markersTitle = 'Aeropuertos Asociados';

    @wire(listaAeropuertos)aeropuertos({ error, data }){
        if (data) {
            console.log('si entro');
            console.log(data);
            data.forEach(dataItem => {
                this.mapMarkers = [...this.mapMarkers,
                {
                    location: {
                        Latitude: dataItem.Latitude,
                        Longitude: dataItem.Longitude,
                    },
                    icon: 'custom:custom26',
                    title: dataItem.name,
                }
                ];
            });
            this.error = undefined;
            console.log(this.mapMarkers);
        } else if (error) {
            console.log('no trajo nada');
            console.log(result.error);
        }
    }
}