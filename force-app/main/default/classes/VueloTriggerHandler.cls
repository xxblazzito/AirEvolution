public with sharing class VueloTriggerHandler implements triggerHandler {
    
    private boolean triggerIsExecuting;
    private integer triggerSize;

    Public VueloTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }
    public void beforeInsert(List<Product2> newAccounts){
      	NombreVuelo(newAccounts);
        }
    public void beforeUpdate(List<Product2> oldAccounts,List<Product2> newAccounts,Map<ID,SObject> oldAccountMap,Map<ID,SObject> newAccountMap){
        desactivarVuelos(newAccounts);
        }
    public void beforeDelete(List<Product2> oldAccounts, Map<ID,SObject> oldAccountMap){
        // code here
        }
    public void afterInsert(List<Product2> newAccounts,Map<ID,SObject> newAccountMap){
        AsignarTripulacion(newAccounts);
        }
    public void afterUpdate(List<Product2> oldAccounts,List<Product2> newAccounts,Map<ID,SObject> oldAccountMap, Map<ID,SObject> newAccountMap){
        // code here
        }
    public void afterDelete(List<Product2> oldAccounts,Map<ID,SObject> oldAccountMap){
        // code here
        }
    public void afterUndelete(List<Product2> newAccounts,Map<ID,SObject> newAccountMap){
        // code here
        }

    public void desactivarVuelos(List<Product2> vuelos){
        for(Product2 v : vuelos){
            if(v.IsActive != false && (v.Estado__c == 'Terminado' || v.Estado__c == 'Cancelado')){
                v.IsActive = false;
                if(v.Estado__c == 'Cancelado' && String.isNotEmpty(v.Motivo_de_cancelacion__c)){
                    date fecha = date.today();
                    v.Fecha_de_cancelacion__c = fecha;
                }else if(v.estado__c=='Cancelado'){
                    v.Motivo_de_cancelacion__c.addError('Debe agregar un motivo de cancelación');
                }     
            }
        }
    } 
    public void NombreVuelo(List<Product2> vuelos){
        for(Product2 v : vuelos){
            String numeroRandom = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 6);
            v.Name = 'AE-'+numeroRandom;
        }
    }

    public void AsignarTripulacion(List<Product2> vuelos){
        for(Product2 v : vuelos){
            DateTime fecha = (v.Fecha_y_hora_de_partida__c).addDays(-7);
            integer segundo = 0;
            integer minuto = 0;
            integer hora = 0;
            integer dia = fecha.day();
            integer mes = fecha.month();
            
            schedulableAsignarTripulacion m = new schedulableAsignarTripulacion(v.ID,v.Name);
            String sch = '0 0 0 '+ dia + ' ' + mes + ' ? *';
            String jobID = system.schedule('Asignar Tripulacion: '+v.Name, sch, m);
        }
    }

    public void notificacionTripulacion(List<Product2> vuelos){
        for(Product2 v : vuelos){
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='Asignar_Tripulantes'];
        
            // Create a new custom notification
            List<user> usuarios = [select id, name from user where UserRole.Name = 'Administrador del sistema'];
            set<String> ids = new set<String>();
            for(user a: usuarios){
                ids.add(a.Id);
            }

            // Set the contents for the notification
            notification.setTitle('Asignar Tripulacion al vuelo:  '+ v.Name);
            notification.setBody('El vuelo esta proximo a salir! no olvide asignar la tripulacion');

            // Set the notification type and target
            notification.setNotificationTypeId(notificationType.Id);
            notification.setTargetId(v.Id);
            
            // Actually send the notification
            try {
                notification.send(ids);
            }
            catch (Exception e) {
                System.debug('Problem sending notification: ' + e.getMessage());
            }
        }
    }
}