public class BatchableReservaNoPagada implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
    	DateTime modificacionPasado = DateTime.now().addHours(-4);
        Datetime modificacionPresente = Datetime.now();
        return Database.getQueryLocator('SELECT Id, StageName, LastModifiedDate FROM Opportunity WHERE  (LastModifiedDate >=: modificacionPasado AND LastModifiedDate <=: modificacionPresente) AND StageName IN (\'Pre-venta\', \'Completado\')');
    }
    
    public void execute(Database.BatchableContext BC, List<Opportunity> reservas){
       	Datetime modificacion = Datetime.now();
        integer horaActual = modificacion.hour();
        integer horaReserva;
        Set<Id> idReservas = new Set<Id>();
        try {
            //Valido las horas que han transcurrido desde la ultima actualización de la reserva
            for (opportunity reserva : reservas) {
                    horaReserva = (reserva.LastModifiedDate).hour();
                    if(horaActual - horaReserva >= 3){
                        reserva.StageName = 'No pagado';
                        idReservas.add(reserva.Id);
                    }
                    
            }
            update reservas;
            //Busco los tiquetes que tiene la reserva para eliminarlos
            List<OpportunityLineItem> eliminar = [SELECT Id From OpportunityLineItem 
            WHERE OpportunityId =: idReservas];
            delete eliminar;

        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
    }
    
    public void finish(Database.BatchableContext BC){
        // notificar acerca del proceso
    }

}