public class TiquetesDeReserva {
    public List<OpportunityLineItem> lineItems { get; set; }
    public List<Product2> vueloInfo {get;set;}
    
    Public TiquetesDeReserva( ApexPages.StandardController std )
    {
        if( std.getRecord().Id != null )
        {
            string idReserva = std.getRecord().Id;
            lineItems = [ Select Id, Name, Pasajero__r.Name, UnitPrice, Equipaje_Permitido__c, Asiento__c, Product2Id from OpportunityLineItem where Opportunityid =: idReserva ];
            set<string> idVuelos = new set<string>();
            for(OpportunityLineItem oli: lineItems){
                idVuelos.add(oli.Product2Id);
            }
            vueloInfo = [select Id, Name,Aeropuerto_de_partida__r.Name,Fecha_y_hora_de_partida__c, Aeropuerto_de_llegada__r.Name,Fecha_y_hora_estimada_de_llegada__c   From Product2 Where ID IN: idVuelos ];
        }
    }   
}