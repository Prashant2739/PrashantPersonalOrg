trigger UpdateOpportunityRecord on Account (after insert, after update) {
    list<opportunity> opp = new list<opportunity>();
    list<opportunity> opp2 = new list<opportunity>();
    for(account acc:trigger.new){
        if(acc.Phone == '8149060647'){
            opp = [select id from opportunity where AccountId =: acc.id];
            system.debug('Size of List'+opp.size());
        }
    }
    for(opportunity opp1: opp){
        opp1.Delivery_Schedule_Date__c = system.today();
        opp2.add(opp1);
    }
    database.update(opp2);
}