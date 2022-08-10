public class detenerDescuentoMartes implements Schedulable {
	public void execute(SchedulableContext ctx) {
        quitarDescuentoMartes batchClass = new quitarDescuentoMartes(); 
        ID batchprocessid = Database.executeBatch(batchClass) ;
    }
}