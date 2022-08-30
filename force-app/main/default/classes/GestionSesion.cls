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
}