public class SchedulableEstadoVuelo implements Schedulable{
	public void execute(SchedulableContext ctx) {
        BatchableEstadoVuelo batchClass = new BatchableEstadoVuelo(); 
        ID batchprocessid = Database.executeBatch(batchClass);
    }
}