public class queueableFuturasCuentas implements Queueable {
    
    public void execute(QueueableContext context){
        List<Account> cuentas = [Select Id from Account WHERE SLASerialNumber__c = null];
        for(Account a: cuentas){
            String numeroRandom = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 9);
            a.SLASerialNumber__c = numeroRandom;
        }
        update cuentas;
        
    }

}