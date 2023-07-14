public class AccountProcessor {
    
    @future
    public static void countContacts(List<Id> accountIds) {
        List<Account> accounts = [Select Id, Name,Number_of_Contacts__c, (SELECT id FROM Contacts) from Account Where Id IN :accountIds];
        List<Account> accountsToUpdate = new List<Account>();
        for(Account Acc: accounts){
            Acc.Number_of_Contacts__c =  Acc.Contacts.size();
            accountsToUpdate.add(Acc);
        }
        database.update(accountsToUpdate);
    }
}