@isTest
public class ObtenerClimaTest {
	
    @isTest
    private static void testGet(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetClimaResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        decimal result = ObtenerClima.getClima('6.2180499','-76.6526787');
		system.assert(result != null);
        system.assertEquals(22.82, result);
    }
}