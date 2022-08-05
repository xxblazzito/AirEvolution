public class scheduledFuturasCuentas implements Schedulable {
	public void execute(SchedulableContext ctx) {
        futurasCuentas batchClass = new futurasCuentas(); 
        ID batchprocessid = Database.executeBatch(batchClass);
    }
}