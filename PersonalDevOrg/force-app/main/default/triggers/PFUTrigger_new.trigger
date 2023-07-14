trigger PFUTrigger_new on Professional_Follow_up__c (after insert) {
    Set<Id> parentID = new Set<Id>();
    contact con = new contact();
    for(Professional_Follow_up__c pfu : trigger.new){
        
         parentID.add(pfu.Candidate__c);
            
    }
    con = [select ID, Name,validation_score__c,(Select id,Candidate__c,status__c from Professional_Follow_ups__r 
                                               where status__c ='Realized') from contact where ID In : parentID ];
    if (con.Id != NULL)
        {            
            	con.validation_score__c = 10;            	
        }    
    /*List<Professional_Follow_up__c> pfuList = [SELECT id,Candidate__c,status__c FROM Professional_Follow_up__c 
                                               WHERE Candidate__c In : parentID];
    list<Professional_Follow_up__c> realizedPFU = new list<Professional_Follow_up__c>();

    for(Professional_Follow_up__c pfu1 :pfuList){
        if(pfu1.status__c =='Realized'){
           realizedPFU.add(pfu1);
        }
        if(realizedPFU.size() > 0 ){
            if(pfu1.Candidate__r.validation_score__c == null){
            pfu1.Candidate__r.validation_score__c = 10;
            }
        }      
    } */         
}