public with sharing class Tiquete {
    
    public static void enviarCorreoCheckIn(List<Product2> vuelos){
        set<String> idVuelos = new set<String>();
        try{
            for (Product2 vuelo: vuelos){
                idVuelos.add(vuelo.id);
            }
            List<OpportunityLineItem> tiquetes = [Select Id, Pasajero__r.Name, Pasajero__r.Email,Asiento__c ,OpportunityId , Product2Id From OpportunityLineItem Where Product2Id =: idVuelos];
    
            for(OpportunityLineItem tiquete: tiquetes){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                // ! Very importante
                String[] toAddresses = new String[] {tiquete.Pasajero__r.Email};
                    mail.setToAddresses(toAddresses);
                
                mail.setReplyTo('blazzwow@gmail.com');
                mail.setSenderDisplayName('Air-Volution Support');
                mail.setSubject('Confirmación de Check-In');
                mail.setPlainTextBody('Señor/a ' + tiquete.Pasajero__r.Name + '. Recuerde realizar el Check In de su vuelo en "https://acortar.link/OuVpNT". Su asiento es el: ' + tiquete.Asiento__c);
                
                mail.setUseSignature(false);
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }catch(exception e){
            throw new MyException(e);
        }
    }

    public class MyException extends Exception {}
}