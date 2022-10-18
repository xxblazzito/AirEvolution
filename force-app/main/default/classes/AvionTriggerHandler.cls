public with sharing class AvionTriggerHandler implements triggerHandler{

    private boolean triggerIsExecuting;
    private integer triggerSize;

    Public AvionTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Avion__c> newAccounts){
        // code here
    }
    public void beforeUpdate(List<Avion__c> oldAccounts,List<Avion__c> newAccounts,Map<ID,SObject> oldAccountMap,Map<ID,SObject> newAccountMap){
        // code here
    }
    public void beforeDelete(List<Avion__c> oldAccounts, Map<ID,SObject> oldAccountMap){
        // code here
    }
    public void afterInsert(List<Avion__c> newAccounts,Map<ID,SObject> newAccountMap){
        // code here
        crearAsientos(newAccounts);
    }
    public void afterUpdate(List<Avion__c> oldAccounts,List<Avion__c> newAccounts,Map<ID,SObject> oldAccountMap, Map<ID,SObject> newAccountMap){
        // code here
    }
    public void afterDelete(List<Avion__c> oldAccounts,Map<ID,SObject> oldAccountMap){
        // code here
    }
    public void afterUndelete(List<Avion__c> newAccounts,Map<ID,SObject> newAccountMap){
        // code here
    }

    public static void crearAsientos(List<Avion__c> aviones){

        List<Asiento__c> asientos = new List<Asiento__c>();
        For(Avion__c avion : aviones){
            decimal Turistas = avion.Numero_de_pasajeros_clase_turista__c;
            decimal Negocios = avion.Numero_de_pasajeros_clase_negocios__c;

            if (Turistas != 0){
                integer fila = 1;
                integer columna = 1;
                for(integer i = 0 ; i < Turistas; i++){
                    if(fila > 26){
                        avion.addError('Ya no es posible vender mas');
                    }
                    if(columna > 20){
                        fila ++;
                        columna = 1;
                        string asiento = convertLetras.convertirLetra(fila);
                        Asiento__c asientoNuevo = new Asiento__c(Avion__c = avion.ID , Tipo__c = 'Turista',Name = avion.Name + '-T-' + asiento + columna);
                        asientos.add(asientoNuevo);
                    }else{
                        string asiento = convertLetras.convertirLetra(fila);
                        Asiento__c asientoNuevo = new Asiento__c(Avion__c = avion.ID , Tipo__c = 'Turista',Name = avion.Name + '-T-' + asiento + columna);
                        asientos.add(asientoNuevo);
                        columna ++;
                    }
                    
                }
            } 
            if (Negocios != 0){
                integer fila = 1;
                integer columna = 1;
                for(integer i = 0 ; i < Negocios; i++){
                    if(fila > 26){
                        avion.addError('Ya no es posible vender mas');
                    }
                    if(columna > 20){
                        fila ++;
                        columna = 1;
                        string asiento = convertLetras.convertirLetra(fila);
                        Asiento__c asientoNuevo = new Asiento__c(Avion__c = avion.ID , Tipo__c = 'Negocio',Name = avion.Name + '-N-' + asiento + columna);
                        asientos.add(asientoNuevo);
                    }else{
                        string asiento = convertLetras.convertirLetra(fila);
                        Asiento__c asientoNuevo = new Asiento__c(Avion__c = avion.ID , Tipo__c = 'Negocio',Name = avion.Name + '-N-' + asiento + columna);
                        asientos.add(asientoNuevo);
                        columna ++;
                    }
                    
                }
            } 
            insert asientos;
        }
    }
}
