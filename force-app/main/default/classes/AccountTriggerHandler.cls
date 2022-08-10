public with sharing class AccountTriggerHandler implements triggerHandler {
    private boolean triggerIsExecuting;
    private integer triggerSize;

    public AccountTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Account> newAccounts){
        // code here 
       
    }
    public void beforeUpdate(List<Account> oldAccounts,List<Account> newAccounts,Map<ID,SObject> oldAccountMap,Map<ID,SObject> newAccountMap){
        // code here
        }
    public void beforeDelete(List<Account> oldAccounts, Map<ID,SObject> oldAccountMap){
        // code here
        }
    public void afterInsert(List<Account> newAccounts,Map<ID,SObject> newAccountMap){
        DupeReminder(newAccounts);
        }
    public void afterUpdate(List<Account> oldAccounts,List<Account> newAccounts,Map<ID,SObject> oldAccountMap, Map<ID,SObject> newAccountMap){
        // code here
        }
    public void afterDelete(List<Account> oldAccounts,Map<ID,SObject> oldAccountMap){
        // code here
        }
    public void afterUndelete(List<Account> newAccounts,Map<ID,SObject> newAccountMap){
        // code here
        }
//por cada cuenta creada se crea un caso y se asigna al dueño de la cuenta
    public static void DupeReminder(List<Account> cuenta){
        List<Case> casos = new List<Case>();
        for (Account acc: cuenta){
            Case c = new Case();
            c.subject = 'Dedupe this Account';
            c.OwnerId = acc.OwnerId;
            c.AccountId = acc.Id;
            casos.add(c);
        }
        insert casos;
    }    
}