trigger CreateContacts on Account (after insert) {
    
    List<Contact> conList = new List<Contact>();
    map<id,Decimal> accMap = new map<id,Decimal>();
    
    for(Account acc: trigger.new){
        accMap.put(acc.id, acc.NumberofLocations__c);
    } 
    
    if(accMap.size()>0 && accMap!=NULL){      
        for(id accId:accMap.keyset()){
            for(Integer i=0;i<accMap.get(accId);i++){ 
                contact newContact = new contact();
                newContact.AccountId = accId;
                newContact.lastname='contact'+i;
                conList.add(newContact);
            }
        }
    }
    database.insert(conList);
}