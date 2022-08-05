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
        system.debug(tiqueteNew[0].opportunity.Pricebook2Id);
        //Select Pricebook2Id from Opportunity where  
        set<Id> idVuelo = new set<Id>();
        for (OpportunityLineItem tiquete: tiqueteNew) {
            idVuelo.add(tiquete.Product2Id);
        }
        string idPrecioNegocios = [Select id From Pricebook2 where name = 'Negocio' limit 1].id;
        set<Id> OpIdNegocios = new set<Id>();
        List<PricebookEntry> entradaListaPrecio = [Select Id,Product2Id from pricebookEntry where Pricebook2Id =: idPrecioNegocios AND Product2Id IN : idvuelo ];
        
        for(PricebookEntry ListEntrada : entradaListaPrecio){
            for(opportunityLineItem tiquete : tiqueteNew){
                
                if (tiquete.Product2Id == ListEntrada.Product2Id){
                    tiquete.Equipaje_Permitido__c = 'Personal;Maleta de Cabina;Maleta de Bodega';
                }
                    
            }
        }
        
        
        //map<Id, Product2> tiquetes = new map<Id, Product2>([Select Id from Product2 where Id =: idTiquetes]);

        
    }

    public static void PasajeroDeReserva (List<OpportunityLineItem> tiqueteNew){
        List <Opportunity> reservas = new List<Opportunity>([Select Id,Titular_de_la_reserva__c from Opportunity where StageName = 'Pre-Venta']);
        for(opportunity reserva : reservas){
            for(opportunityLineItem tiquete : tiqueteNew){
                if (tiquete.OpportunityId == reserva.Id){
                    tiquete.Pasajero__c = reserva.Titular_de_la_reserva__c;
                }
                    
            }
        }
    }
    
}