public with sharing class BatchableSemanaAntesVuelo implements Database.Batchable<sObject>{
        
    public Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select id, Name, Estado__c, Fecha_y_hora_de_partida__c from Product2 where IsActive  = True AND Estado__c != \'Terminado\' ';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Product2> Vuelos){
        try{
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            CustomNotificationType notificationType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='Asignar_Tripulantes'];
            List<user> usuarios = [select id, name from user where UserRole.Name = 'Administrador del sistema'];
            List<Product2> updateVuelo = new list<Product2>();
            set<String> ids = new set<String>();
            for(user a: usuarios){
                ids.add(a.Id);
            }
            for(Product2 vuelo: Vuelos){
                Date fechaPartida = vuelo.Fecha_y_hora_de_partida__c.Date();
                Date actual = Date.today();
                Integer diasRestantes = actual.daysBetween(fechaPartida);
                
                if(diasRestantes <= 7 && diasRestantes > 0 && vuelo.Estado__c == 'En Venta'){
                    // Contenido de la Notificacion.
                    notification.setTitle('Asignar Tripulacion al vuelo:  '+ vuelo.Name);
                    notification.setBody('El vuelo esta proximo a salir! no olvide asignar la tripulacion');
                    
                    // Tipo de la notificacion y a que registro va dirigida.
                    notification.setNotificationTypeId(notificationType.Id);
                    notification.setTargetId(vuelo.Id);
                    
                    // se envia la notificacion.
                    try {
                        notification.send(ids);
                    }
                    catch (Exception e) {
                        System.debug('Problem sending notification: ' + e.getMessage());
                    }
                }
                if(diasRestantes <= 0 && (vuelo.Estado__c == 'En Venta' || vuelo.Estado__c == 'Check In') ){
                    system.debug('entro a terminado');
                    vuelo.Estado__c = 'Terminado';
                    updateVuelo.add(vuelo);
                }
            }
            update updateVuelo;
            

        }catch (exception e){
            throw new personalizadaException('se ha producido un error: '+e);
        }
        
    }
    
    public void finish(Database.BatchableContext BC){
        // notificar acerca del proceso
    }
    
    public class personalizadaException extends Exception {}
}