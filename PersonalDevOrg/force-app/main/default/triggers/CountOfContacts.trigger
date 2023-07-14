trigger CountOfContacts on Contact (after insert,after delete,after undelete) {
    set<id> accid=new set<id>();
    list<contact> contactlist =new list<contact>();    
    list<contact> listcon=new list<contact>();   
    list<account> acclist=new list<account>();
    list<account> listAcc=new list<account>();
    map<id,integer> mapCount=new map<id,integer>();
    
    if(trigger.isinsert || trigger.isUndelete){        
        for(contact con:trigger.new){
            accid.add(con.accountid);            
        }
    }
    if(trigger.isdelete){        
        for(contact con:trigger.old){            
            accid.add(con.accountid);            
        }
    }
    
    Map<Id,Account> mapAccount = new Map<Id,Account> ([select id, (select id,name,accountid from contacts) from account where id in :accid ]);
  	
    acclist = mapAccount.values();
  
    for(account acc:acclist){
        Account accObj = mapAccount.get(acc.id);
        contactlist = accObj.contacts;
        listcon.clear();
        mapCount.put(acc.id,contactlist.size());
        acc.Number_of_Contacts__c = contactlist.size();
        listAcc.add(acc);
    }
    
    /*if(acclist.size()>0){        
        for(Account a:acclist){
            if(mapCount.get(a.id)==null){
                a.Number_of_Contacts__c=0;
            }
            else{
                a.Number_of_Contacts__c=mapCount.get(a.id);
            }
            listAcc.add(a);
        }
    }*/
    if(listAcc.size()>0)
        update listAcc;
}