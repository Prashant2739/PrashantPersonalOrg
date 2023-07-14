public with sharing class fetchAccounts {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        return [SELECT Name, Type, Rating,Phone, Website  
                FROM Account
                WHERE Type!=Null];
    }

}