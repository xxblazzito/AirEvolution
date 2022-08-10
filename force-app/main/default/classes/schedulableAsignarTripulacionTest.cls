@isTest
public class schedulableAsignarTripulacionTest {
	
    @TestSetup
    static void makeData(){
        
    }
    
    @isTest
    private static void creandovuelo(){
        dateTime fechapartida = DateTime.newInstanceGMT(2022, 8, 20, 0, 0, 0);
        Product2 vuelo = new Product2(Name = 'a', isActive = true,Estado__c = 'En Venta', Fecha_y_hora_de_partida__c  = fechapartida);
        insert vuelo;
        Product2 vueloCreado = [Select id,Name,Fecha_y_hora_de_partida__c from Product2];
        Test.startTest();
        	DateTime fecha = (vueloCreado.Fecha_y_hora_de_partida__c).addDays(-7);
            integer segundo = 0;
            integer minuto = 0;
            integer hora = 0;
            integer dia = fecha.day();
            integer mes = fecha.month();
            
            schedulableAsignarTripulacion m = new schedulableAsignarTripulacion(vueloCreado.ID);
            String sch = '0 0 0 '+ dia + ' ' + mes + ' ? *';
            
        
        	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                         	FROM CronTrigger Limit 1];
        
            system.assertEquals(sch, ct.CronExpression);
            
            system.assertEquals(0, ct.TimesTriggered);
            
            system.assertEquals('13/08/2022 12:00:00',String.valueOf(ct.NextFireTime));
        Test.stopTest(); 
    }
    
}