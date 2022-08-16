public class schedulableDiaAntesVuelo implements Schedulable{
	public void execute(SchedulableContext ctx) {
        BatchableDiaAntesVuelo batchClass = new BatchableDiaAntesVuelo(); 
        ID batchprocessid = Database.executeBatch(batchClass);
        
    }
}