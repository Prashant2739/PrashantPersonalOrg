trigger PFUTrigger on Professional_Follow_up__c (before insert) {

    List<Professional_Follow_up__c> List1 = new List<Professional_Follow_up__c>();
    for (Professional_Follow_up__c prof :trigger.new )
    {
        /*If(prof.status__c=='Realized')  {
            followup = true;             
        }*/
       List<Professional_Follow_up__c> List1 = new List<Professional_Follow_up__c>(); 
        List1 = [select Name,candidate__r.Name,candidate__r.Validation_Score__c,status__c from Professional_Follow_up__c
                 where status__c= 'Realized' and candidate__r.Name ='Arthur Song'];
        if (List1!= Null ){
            for (Professional_Follow_up__c pf : List1){
           pf.candidate__r.Validation_Score__c = 10;
            }
        }
    }     
}