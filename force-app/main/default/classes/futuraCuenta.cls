public class futuraCuenta {
    
    @future
    public static void updateCuenta( Id idCuenta){
        String numeroRandom = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 9);
        Account cuenta = new Account(Id = idCuenta,	SLA__c = 'Gold',SLASerialNumber__c = numeroRandom);
        update cuenta;
    } 
}