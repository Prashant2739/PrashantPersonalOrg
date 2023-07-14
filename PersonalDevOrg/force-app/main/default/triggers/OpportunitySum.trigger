trigger OpportunitySum on Opportunity (After insert, After delete, After undelete) {
    
    set<Id> parentIDs = new set<Id>();
    List<Account> accountListToUpdate = new List<Account>();
    Integer existingAcc;
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            for(opportunity opp: trigger.new){
                if(opp.AccountId!=NULL){
                	parentIDs.add(opp.AccountId);    
                }
            }
        }
        if(trigger.isDelete){
            for(opportunity opp: trigger.old){
            	if(opp.AccountId!=NULL){
                	parentIDs.add(opp.AccountId);    
                }    
            }    
        }
    }

    list<account> acclist = new list<account>([SELECT Id, name, 
                                               (SELECT id,StageName FROM Opportunities WHERE StageName = 'Closed Won') 
                                               FROM account 
                                               WHERE Id in:parentIDs]);
    for(account acc: acclist){
        list<opportunity> oppList = acc.Opportunities;
        acc.Number_of_Opportunity__c = oppList.size();
        accountListToUpdate.add(acc);
    }
    database.update(accountListToUpdate);
}