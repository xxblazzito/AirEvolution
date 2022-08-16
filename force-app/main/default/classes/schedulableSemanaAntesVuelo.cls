public class schedulableSemanaAntesVuelo implements Schedulable{
	public void execute(SchedulableContext ctx) {
        BatchableSemanaAntesVuelo batchClass = new BatchableSemanaAntesVuelo(); 
        ID batchprocessid = Database.executeBatch(batchClass);
    }
}