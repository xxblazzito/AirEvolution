public with sharing class Reserva {
    
    public static void cancelarReservaNoPagada(List<Opportunity> reservas){
        DateTime modificacionPasado = DateTime.now().addHours(-4);
        Datetime modificacionPresente = Datetime.now();

        Datetime modificacion = Datetime.now();
        integer horaActual = modificacion.hour();
        integer horaReserva;

        List<Opportunity> reservaActualizable = new List<Opportunity>();

        for(Opportunity reserva : reservas){
            if(reserva.LastModifiedDate >= modificacionPasado && reserva.LastModifiedDate <= modificacionPresente){
                horaReserva = (reserva.LastModifiedDate).hour();

                if(horaActual - horaReserva >= 3 ){
                    Opportunity reservita = new Opportunity();
                    reservita.Id = reserva.Id;
                    reservita.StageName = 'No pagado';
                    reservaActualizable.add(reservita);
                }
            }
        }
        update reservaActualizable;

        Set<Id> idReservas = new Set<Id>();

        for(Opportunity reserva : reservaActualizable){
            idReservas.add(reserva.Id);
        }

        List<OpportunityLineItem> tiquetesEliminables = [SELECT Id From OpportunityLineItem WHERE OpportunityId = : idReservas];
        delete tiquetesEliminables;
    }
}
