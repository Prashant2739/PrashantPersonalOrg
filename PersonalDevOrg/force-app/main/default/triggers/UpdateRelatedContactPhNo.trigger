trigger UpdateRelatedContactPhNo on Account (after update) {
    
    Set<ID> setAccId = new Set<ID>();
    for(Account acc : Trigger.new)
    {
        Account oldAcc = trigger.oldMap.get(acc.id);
        if( acc.phone != oldAcc.phone )
        {
            setAccId.add(acc.id);
        }
    }
    if(setAccId.size() > 0 )
    {
        Map<Id,Account> mapAccount = new Map<Id,Account> ([select id,phone, (select id,phone from contacts) from account where id in :setAccId ]);
        List<Contact> lstContactToUpdate = new List<Contact>();
        
        for(Account acc : Trigger.new)
        {
            Account oldAcc = trigger.oldMap.get(acc.id);
            if( acc.phone != oldAcc.phone )
            {
                if(mapAccount.containsKey(acc.id))
                {
                    Account accObj = mapAccount.get(acc.id);
                    List<Contact> lstCont = accObj.contacts;
                    system.debug('######Related Contacts'+lstCont);
                    for(Contact cont : lstCont)
                    {
                        cont.phone = acc.phone;
                        lstContactToUpdate.add(cont);
                    }
                }
            }
        }
        
        if(lstContactToUpdate.size() > 0 )
        {
            update lstContactToUpdate;
        }
    }
}