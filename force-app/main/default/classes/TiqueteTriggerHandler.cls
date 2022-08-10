public with sharing class TiqueteTriggerHandler implements triggerHandler {
    
    private boolean triggerIsExecuting;
    private integer triggerSize;

    Public TiqueteTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }
    public void beforeInsert(List<OpportunityLineItem> newAccounts){
        // code here 
        sobreventa(newAccounts);
        asignarequipaje(newAccounts);
        PasajeroDeReserva(newAccounts);
    }
    public void beforeUpdate(List<OpportunityLineItem> oldAccounts,List<OpportunityLineItem> newAccounts,Map<ID,SObject> oldAccountMap,Map<ID,SObject> newAccountMap){
        // code here
        }
    public void beforeDelete(List<OpportunityLineItem> oldAccounts, Map<ID,SObject> oldAccountMap){
        // code here
        }
    public void afterInsert(List<OpportunityLineItem> newAccounts,Map<ID,SObject> newAccountMap){
        
        }
    public void afterUpdate(List<OpportunityLineItem> oldAccounts,List<OpportunityLineItem> newAccounts,Map<ID,SObject> oldAccountMap, Map<ID,SObject> newAccountMap){
        // code here
        }
    public void afterDelete(List<OpportunityLineItem> oldAccounts,Map<ID,SObject> oldAccountMap){
        // code here
        }
    public void afterUndelete(List<OpportunityLineItem> newAccounts,Map<ID,SObject> newAccountMap){
        // code here
        }
    public static void sobreventa(List<OpportunityLineItem> TiqueteNew)
    {
        set <Id> idTiquetes = new set<Id>();
        for (opportunityLineItem Tiquete : tiqueteNew)
        {
            idTiquetes.add(Tiquete.Product2Id);
        }
        map<id , product2> productos = new map<id , product2>([select ID,avion__r.Numero_de_pasajeros_clase_negocios__c,avion__r.Numero_de_pasajeros_clase_turista__c 
                                                                from Product2 where Id IN :idTiquetes]); 
        AggregateResult[] groupedResults = [SELECT Count(Id),Product2Id FROM OpportunityLineItem where Product2Id IN :idTiquetes GROUP BY Product2Id  ];
        List<Product2> vuelos = new List<Product2>();
        for (AggregateResult ar : groupedResults){
            system.debug(ar.get('Product2Id'));
            system.debug(ar.get('expr0'));
            decimal pasajerosTotales =productos.get((string)ar.get('Product2Id')).avion__r.Numero_de_pasajeros_clase_negocios__c+productos.get((string)ar.get('Product2Id')).avion__r.Numero_de_pasajeros_clase_turista__c;
            if ((pasajerosTotales*1.1)<(integer)ar.get('expr0')) {
                vuelos.add(new product2(id=(string)ar.get('Product2Id')));
            }
            
        }
        for(opportunityLineItem a: tiqueteNew){
            for(product2 p: vuelos){
                if (a.Product2Id==p.Id){
                    a.adderror('No es posible sobrevender los tiquetes');
                }
            }
        }
    }

    public static void asignarEquipaje(List<OpportunityLineItem> tiqueteNew)
    {
        Pricebook2 listaPrecio = [Select Id from Pricebook2 where name = 'Negocio' limit 1];
        set<Id> idReserva = new set<Id>();
        for (OpportunityLineItem tiquete: tiqueteNew) {
            idReserva.add(tiquete.OpportunityId);
        }
        List<Opportunity> reservas = [Select Id From Opportunity Where Id IN : idReserva And Pricebook2Id =: listaPrecio.Id ];
        for(OpportunityLineItem t: tiqueteNew){
            for(Opportunity r: reservas){
                if(t.OpportunityId == r.Id){
                    t.Equipaje_Permitido__c = 'Personal;Maleta de Cabina;Maleta de Bodega';
                }
            }
        }
    }

    public static void PasajeroDeReserva (List<OpportunityLineItem> tiqueteNew){
        List <Opportunity> reservas = new List<Opportunity>([Select Id,Titular_de_la_reserva__c from Opportunity where StageName = 'Pre-Venta']);
        for(opportunity reserva : reservas){
            for(opportunityLineItem tiquete : tiqueteNew){
                if (tiquete.OpportunityId == reserva.Id){
                    if(tiquete.Pasajero__c == null){
                        tiquete.Pasajero__c = reserva.Titular_de_la_reserva__c;
                    }
                }       
            }
        }
    }
    
}