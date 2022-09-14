trigger nickUnico on Sesion__c (before insert) {
    List<Sesion__c> sesiones = [select id, Name From Sesion__c];
    for(sesion__c a: trigger.new){
        for(sesion__c b: sesiones){
            if( a.Name == b.Name){
                a.Name.addError('Este nombre de usuario no se encuentra disponibles');
            }
        }
    }
}