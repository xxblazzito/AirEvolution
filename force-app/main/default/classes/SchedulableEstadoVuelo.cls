public class SchedulableEstadoVuelo implements Schedulable{
	public void execute(SchedulableContext ctx) {

        List<Product2> vuelos = [Select id, Estado__c, Fecha_y_hora_de_partida__c, Fecha_y_hora_estimada_de_llegada__c,Aeropuerto_de_Partida__r.Id,
                                Aeropuerto_de_Partida__r.Ubicacion__Longitude__s,Aeropuerto_de_Partida__r.Ubicacion__Latitude__s, Aeropuerto_de_llegada__r.Id,
                                Aeropuerto_de_llegada__r.Ubicacion__Longitude__s,Aeropuerto_de_llegada__r.Ubicacion__Latitude__s from product2]; 

        List<Opportunity> reservas = [Select Id, StageName, LastModifiedDate FROM Opportunity Where StageName NOT IN ('Pagado','No pagado') ];

        List<Clima__c> climasVuelos = Clima.crearClimaLlegada(vuelos);
        List<Product2> vuelosEnVuelo = Vuelo.cambiarEstadoEnVuelo(vuelos);

        insert climasVuelos;
        update vuelosEnVuelo;

        reserva.cancelarReservaNoPagada(reservas);
    }
}