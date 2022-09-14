public with sharing class geolocalizacion {
    
    @AuraEnabled(cacheable = true)
    public static List<location> obtenerUbicacion(){
        try {
            list<Aeropuerto__c> aeropuertos = [SELECT Id, Name, Ubicacion__Latitude__s, Ubicacion__Longitude__s FROM Aeropuerto__c Where Ubicacion__Latitude__s != null ];

            List<location> aeropuertico = new List<location>();
            for(Aeropuerto__c a: aeropuertos){
                aeropuertico.add(new location(a.Name , a.Ubicacion__Latitude__s, a.Ubicacion__Longitude__s));
            }
            return aeropuertico;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class location{

        @AuraEnabled 
        public string name {get;set;}
        @AuraEnabled 
        public decimal Latitude {get;set;}
        @AuraEnabled 
        public decimal Longitude {get;set;}

        public location(string nombre, decimal lati, decimal longi){
            name = nombre;
            Latitude = lati;
            Longitude = longi;
        }

    }
}