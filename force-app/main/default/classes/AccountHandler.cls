public class AccountHandler {
    public static Account insertNewAccount (String nombre)
    {
        if(nombre=='')
        {
            Return null;
        }
        else
        {
            
        }
        Account acct = new Account(Name=nombre);
        Insert acct;
        Return acct;
    }
    public static void insertAccount (integer numeroCuentas )
    {
        List<Account> addAccounts = new List<Account>();
        Integer N = 0 ;
        
        while(N <= numeroCuentas)
        {
            Account cuenta = new Account();
            cuenta.Name = 'Acme Inc '+N;
            cuenta.AccountNumber = 'A000'+N;
            N++;
            addAccounts.add(cuenta );
        }
        
        Insert addAccounts;
        system.debug(addAccounts);
    }
}