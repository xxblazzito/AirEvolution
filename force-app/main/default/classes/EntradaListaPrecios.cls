public with sharing class EntradaListaPrecios {
    public static void aplicarDescuentoCincuenta(list<Product2> vuelos){
        set<string> idVuelos = new set<string>();
        try{
            for(Product2 vuelo : vuelos){
                idVuelos.add(vuelo.Id);
            }
    
            List<PricebookEntry> entradaListaPrecios = [Select Id, UnitPrice, Descuento_Por_Vencer__c, Product2Id, Descuento_Martes__c  from PricebookEntry where Product2Id =: idVuelos];
            List<PricebookEntry> PEActualizable = new List<PricebookEntry>();
            for(PricebookEntry listaPrecio : entradaListaPrecios){
                Decimal valor = listaPrecio.UnitPrice;
                if(listaPrecio.Descuento_Martes__c == true && listaPrecio.Descuento_Por_Vencer__c == false){
                    valor = valor / 0.65;
                    listaPrecio.UnitPrice = valor * 0.5;
                    listaPrecio.Descuento_Martes__c = false;
                    listaPrecio.Descuento_Por_Vencer__c= true;
                    PEActualizable.add(listaPrecio);
                } 
                if(listaPrecio.Descuento_Por_Vencer__c == false && listaPrecio.Descuento_Martes__c == false){
                    listaPrecio.UnitPrice = valor * 0.5;
                    listaPrecio.Descuento_Martes__c = false;
                    listaPrecio.Descuento_Por_Vencer__c= true;
                    PEActualizable.add(listaPrecio);
                }
            }
            update PEActualizable;
        }catch(exception e){
            throw new MyException(e);
        }
    }

    public class MyException extends Exception {}
}