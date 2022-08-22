public class BatchableDiaAntesVuelo implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select id, Name, Fecha_y_hora_de_partida__c  from Product2 where Estado__c = \'En Venta\' AND IsActive  = True';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Product2> Vuelos){
        try{
            set<String> idVuelos = new set<String>();
            for(Product2 a: vuelos){
                idVuelos.add(a.Id);
            }
            List<String> vuelosCumplen = new List<String>();
            List<OpportunityLineItem> tiquetes = [Select Id, Pasajero__r.Name, Pasajero__r.Email,Asiento__c ,OpportunityId , Product2Id From OpportunityLineItem Where Product2Id =: idVuelos];
            List<PricebookEntry> entradaListaPrecios = [Select Id, UnitPrice, Descuento_Por_Vencer__c, Product2Id, Descuento_Martes__c  from PricebookEntry where Product2Id =: idVuelos];
            for(Product2 vuelo: Vuelos){
                double fechaPartida = vuelo.Fecha_y_hora_de_partida__c.getTime();
                double actual = DateTime.now().getTime();
                double milliseconds = fechaPartida - actual;
                double seconds = milliseconds / 1000;
                double minutes = seconds / 60;
                double hours = minutes / 60;
                
                if(hours <= 24){
                    for(PricebookEntry listaPrecio: entradaListaPrecios){
                        if(vuelo.Id == listaPrecio.Product2Id){
                            Decimal valor = listaPrecio.UnitPrice;
                            if(listaPrecio.Descuento_Martes__c == true){
                                valor = valor / 0.65;
                                listaPrecio.UnitPrice = valor * 0.5;
                                listaPrecio.Descuento_Martes__c = false;
                                listaPrecio.Descuento_Por_Vencer__c= true;
                            }else if(listaPrecio.Descuento_Por_Vencer__c == true){
                                
                            }else{
                                listaPrecio.UnitPrice = valor * 0.5;
                                listaPrecio.Descuento_Martes__c = false;
                                listaPrecio.Descuento_Por_Vencer__c= true;
                            }
                        }
                    }
                    vuelosCumplen.add(vuelo.Id);
                    vuelo.Estado__c = 'Check In';
                }
            }
            system.debug('vamoh a darle');
            update vuelos;
            update entradaListaPrecios;
            for(integer i=0; i < vuelosCumplen.size();i++){
                for(OpportunityLineItem tiquete: tiquetes){
                    if(vuelosCumplen[i] == tiquete.Product2Id){
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
                }
            }
        }
        catch(exception e){
            system.debug('error!');
        }
    }
    
    public void finish(Database.BatchableContext BC){
        // notificar acerca del proceso
    }
}