public class iniciarDescuentoMartes implements Schedulable {
	public void execute(SchedulableContext ctx) {
        agregarDescuentoMartes batchClass = new agregarDescuentoMartes(); 
        ID batchprocessid = Database.executeBatch(batchClass) ;
    }
}