public class schedulableAsignarTripulacion implements Schedulable {
	Public String idVuelo;
    Public String nameVuelo;
    Messaging.CustomNotification notification = new Messaging.CustomNotification();
    
    public void execute(SchedulableContext ctx) {
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='Asignar_Tripulantes'];
        
        // Create a new custom notification
        List<user> usuarios = [select id, name from user where UserRole.Name = 'Supervisor de vuelo'];
        set<String> ids = new set<String>();
        for(user a: usuarios){
            ids.add(a.Id);
        }

        // Set the contents for the notification
        notification.setTitle('Asignar Tripulacion al Vuelo: '+ nameVuelo);
        notification.setBody('El vuelo esta proximo a salir! no olvide asignar la tripulacion');

        // Set the notification type and target
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(IdVuelo);
        
        // Actually send the notification
        try {
            notification.send(ids);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
    
    public schedulableAsignarTripulacion(string vuelo, string name){
        idVuelo = vuelo;
        nameVuelo = name;
        
    }
}