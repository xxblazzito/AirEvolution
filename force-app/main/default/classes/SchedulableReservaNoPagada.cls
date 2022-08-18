public class SchedulableReservaNoPagada implements Schedulable{
    public void execute(SchedulableContext ctx) {
        BatchableReservaNoPagada batchClass = new BatchableReservaNoPagada(); 
        ID batchprocessid = Database.executeBatch(batchClass);  
    }
}