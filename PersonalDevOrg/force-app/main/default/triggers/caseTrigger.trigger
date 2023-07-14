trigger caseTrigger on Case (before insert,before update) {
    
    set<ID> conIds = new set<ID>();  
    List<String> subList = new List<String>();
    List<Case> caseList = new List<Case>();
    for(Case cse:trigger.new){
        conIds.add(cse.ContactId); 
        subList.add(cse.Subject);
    }
    
    caseList = [SELECT ID, ContactId, Duplicate_Case__c, Subject 
                FROM Case 
                WHERE ContactId in :conIds 
                AND Subject in:subList];
    
    for(Case c:trigger.new){
        if(caseList.size()>0){
        	c.Duplicate_Case__c = true;    
        }
        else{
            c.Duplicate_Case__c = false;
        }
    }
}