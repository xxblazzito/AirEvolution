public with sharing class GestionSesion {
    
    @AuraEnabled
    public static Sesion__c iniciarSesion(string nick, string pass){
        try {
            Sesion__c login = [select id, Name , Correo_Electronico__c, password__c from Sesion__c where Name =: nick Limit 1];
            if(login != null){
                if(login.password__c == pass){
                    return login;
                }
                else{
                    return null;
                }
            }
            else{
                return null;
            }
        } catch (Exception e) {
            return null;
        }
    }

    @AuraEnabled
    public static Sesion__c crearSesion(string nick, string pass, string pass2, string correo){
        try {
            if(pass == pass2){
                Sesion__c newSesion = new Sesion__c(Name = nick, Correo_Electronico__c = correo , password__c = pass);
                insert newSesion;
                return newSesion;
            }else{
                return null;
            }
        } catch (Exception e) {
            return null;
        }
    }

    @AuraEnabled
    public static Sesion__c enviarRecuperacion(string nick){
        try {
            Sesion__c sesion = [select Id, Name, Correo_Electronico__c From Sesion__c where Name =: nick Limit 1];
            if(sesion != null){
                String numeroRandom = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 10);
                Sesion__c generarCodigo = new Sesion__c();
                generarCodigo.Id = sesion.Id;
                generarCodigo.validacion__c = numeroRandom;

                update generarCodigo;

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                // ! Very importante
                String[] toAddresses = new String[] {sesion.Correo_Electronico__c};
                mail.setToAddresses(toAddresses);
    
                mail.setReplyTo('cristiancamilo.aguirrerestrepo@gmail.com');
                mail.setSenderDisplayName('Air-Volution Support');
                mail.setSubject('Restablecer Contraseña');
                mail.setPlainTextBody('Querid@ '+sesion.Name+' su codigo de validacion es: '+numeroRandom);

                mail.setUseSignature(false);

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                return sesion;
            }
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static boolean validarVerificacion(string nick, string codigo){
        try {
            Sesion__c sesion = [select Id, Name, Correo_Electronico__c, validacion__c From Sesion__c where Name =: nick Limit 1];
            if(sesion != null){
                if(sesion.validacion__c == codigo){
                    return true;
                }
                return false;
            }
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Sesion__c cambiarPass(string nick, string pass1, string pass2){
        try {
            Sesion__c sesion = [select Id, Name, Correo_Electronico__c, validacion__c From Sesion__c where Name =: nick Limit 1];
            if(sesion != null){
                if(pass1 == pass2){
                    Sesion__c recuperarSesion = new Sesion__c();
                    recuperarSesion.Id = sesion.Id;
                    recuperarSesion.password__c = pass1;

                    update recuperarSesion;
                    return recuperarSesion;
                }else{
                    return null;
                }
            }
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}