public with sharing class ObtenerClima {
    
    public static decimal getClima(string lat,string lon){
        decimal resultado;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.openweathermap.org/data/2.5/weather?lat='+lat+'&lon='+lon+'&lang=es&appid=d238fe303865c859a34f75b34a4f2bed&units=metric');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> clima = (Map<String, Object>) results.get('main');
            resultado = (decimal)clima.get('temp');
            return resultado;
        }
        
        return resultado;
    }
}