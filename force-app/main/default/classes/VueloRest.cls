@RestResource(urlMapping ='/Product2/*')
global with sharing class VueloRest {
   @HttpGet
   global static List<Product2> getVuelos(){
        String fechaUno;
        String fechaDos;
        String ciudadPartida;
        String ciudadLlegada;
        List<Product2> vuelos;
        RestRequest restReq = RestContext.request;
        RestResponse restRes = RestContext.response;

        fechaUno = (restReq.params.get('fechaUno')).replace('-','/');
        fechaDos = (restReq.params.get('fechaDos')).replace('-','/');
        ciudadPartida = restReq.params.get('ciudadPartida');
        ciudadLlegada = restReq.params.get('ciudadLlegada');

        Date fUno = Date.parse(fechaUno);
        Date fDos = Date.parse(fechaDos);
        Datetime tUno = datetime.newInstance(fUno.year(), fUno.month(),fUno.day());
        Datetime tDos = datetime.newInstance(fDos.year(), fDos.month(),fDos.day());

        vuelos = [Select id, Name, Aeropuerto_de_partida__r.Name,Aeropuerto_de_llegada__r.Name From Product2 Where Fecha_y_hora_de_partida__c >=: tUno
                             AND Fecha_y_hora_de_partida__c <=: tDos AND Aeropuerto_de_partida__r.Ciudad__c =: ciudadPartida
                             AND Aeropuerto_de_llegada__r.Ciudad__c =: ciudadLlegada];
    return vuelos;
    }
}
