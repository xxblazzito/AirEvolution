public class BatchableReservaNoPagada implements Database.Batchable<sObject>{
    DateTime modificacion = DateTime.now().addHours(-3);
    public Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select id, StageName, LastModifiedDate from Opportunity';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Opportunity> reservas){
        List<String> idReservas = new list<String>();
        try{
            for(Opportunity reserva: reservas){
                if(reserva.LastModifiedDate <= modificacion && (reserva.StageName == 'Pre-venta' || reserva.StageName == 'Completado')){
                    reserva.StageName = 'No pagado';
                    idReservas.add(reserva.Id);
                }
            }
            update reservas;
            
            List<OpportunityLineItem> eliminar = [Select Id From OpportunityLineItem Where OpportunityId IN : idReservas];
            delete eliminar;
        }catch(exception e){
            system.debug(e.getMessage());
        }
    }
    
    public void finish(Database.BatchableContext BC){
        // notificar acerca del proceso
    }

}