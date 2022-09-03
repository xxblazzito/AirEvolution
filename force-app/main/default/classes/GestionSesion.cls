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
            Sesion__c sesion = [select Id, Name From Sesion__c where Name =: nick Limit 1];
            return sesion;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}