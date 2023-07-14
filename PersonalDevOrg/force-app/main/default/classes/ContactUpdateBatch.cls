global class ContactUpdateBatch implements database.Batchable<sobject>, database.stateful{
    global Integer Total_size = 0;
    global Integer Fail_size = 0;
    global Integer Sucess_size = 0;
    
    global database.QueryLocator start (database.BatchableContext bc){        
        string query = 'select id, name ,mobilephone, fax , email, description, account.name, account.phone,'+
            'account.fax, account.industry from contact';
        return database.getQueryLocator(query);     
    }
    
    global void execute(database.BatchableContext bc , list<contact> contactList){
        integer conSize = contactList.size();
        Total_size += conSize;
        for (integer i=0;i<conSize;i++){
            Contact con = contactList.get(i);
            if (con.fax == null || con.fax =='' ){
                con.fax = con.Account.fax;    
            }
            
            if (con.mobilephone == null || con.mobilephone =='' ){
                con.mobilephone = con.Account.phone;    
            }
            con.email= 'prashantrupnur@gmail.com';
            con.description = con.Account.Name+' '+con.account.industry+' '+con.account.name+' '+con.email;
        }
        //Use of stateful Interface
        database.SaveResult [] result = database.update(contactList,false);
        Integer ResultSize = result.size();
        for (integer i=0; i<ResultSize; i++){
            database.SaveResult sr = result.get(i);
            if (sr.isSuccess()){
            	Sucess_size += 1;    
            }
            else{
            	Fail_size += 1;    
            }
        }
    }
    
    global void finish(database.BatchableContext bc){
        Messaging.SingleEmailMessage emailtoSend = new Messaging.SingleEmailMessage();
        emailtoSend.setSubject('Status of BatchClass: ContactUpdateBatch');
        emailtoSend.setSenderDisplayName('Demo Contact Update');
        emailtoSend.setHtmlBody('Dear User, Batch Processed Sucessfully <br/>'+
                               'Please find the stats below:<br/>'+
                                ' Total Records Processed '+Total_size +
                                '<br/> Total Records Sucess Records '+Sucess_size +
                                '<br/> Total Failed Records '+Fail_size);
        List<string> emailTo = new List<string>();
        emailTo.add('prashantrupnur@gmail.com');
        emailtoSend.setToAddresses(emailTo);        
        Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();		       
        emailList.add(emailtoSend);
        Messaging.sendEmail(emailList, false);
    }
}