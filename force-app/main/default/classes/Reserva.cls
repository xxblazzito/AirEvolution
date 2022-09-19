public with sharing class Reserva {
    
    public static void cancelarReservaNoPagada(List<Opportunity> reservas){

        List<Opportunity> reservaActualizable = new List<Opportunity>();
        try{
            for(Opportunity reserva : reservas){
                long fechaModificacion = reserva.LastModifiedDate.getTime();
                long actual = DateTime.now().getTime();
    
                long horas = actual - fechaModificacion;
                long seconds = horas / 1000;
                long minutes = seconds / 60;
                Long hours = minutes / 60;
    
                if(hours >= 3 ){
                    Opportunity reservita = new Opportunity();
                    reservita.Id = reserva.Id;
                    reservita.StageName = 'No pagado';
                    reservaActualizable.add(reservita);
                }
                
            }
            update reservaActualizable;
    
            Set<Id> idReservas = new Set<Id>();
    
            for(Opportunity reserva : reservaActualizable){
                idReservas.add(reserva.Id);
            }
    
            List<OpportunityLineItem> tiquetesEliminables = [SELECT Id From OpportunityLineItem WHERE OpportunityId = : idReservas];
            delete tiquetesEliminables;
        }catch(exception e){
            throw new MyException(e);
        }
    }
        
    public class MyException extends Exception {}
}