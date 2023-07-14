global class UpdateAccountBatch implements Database.Batchable<sobject> {
    string query;
    
    global Database.querylocator start (Database.BatchableContext BC){
        Query = 'Select Id,Name, Description from account';
        return database.getQueryLocator(query);    
    }
	
    global void execute(Database.BatchableContext BC ,List<Account> scope){
        List<Account> Acclist = new List<Account>();
        for (account s : scope){
            s.description = 'Updated from the batch Class';
            s.ShippingPostalCode__c = 411057;
            Acclist.add(s);
        }
        database.update(Acclist); 
    }
    
    global void finish (database.batchableContext BC){
        
    }
}