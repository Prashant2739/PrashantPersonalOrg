trigger UpdateContactRecord on Case (after update) {
    set<Id> con1Ids = new set<Id>();    
    list<contact> con1 = new list<contact>(); 
    for (Case c1: trigger.new){        
        if (c1.Status == 'Closed'){
            con1Ids.add(c1.ContactId);	    
        }
    }
    
    for (contact con:[select id,DoNotCall from contact where id IN : con1Ids] ){
        con.DoNotCall = true;
        con1.add(con);
    }
    database.update(con1);

}