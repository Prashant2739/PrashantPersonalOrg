global class NoteToEnhancedNotes implements Database.Batchable<sObject>,Database.Stateful{
    public string qString;
    string errorDetailsString = 'Parent Record Id ,Attachment Id, Error deatils \n';
    string successRecordString='Parent Record Id ,Attachment Id,ContentVersionId \n';
    long jobStartTime= 0;
    long jobEndTime= 0;
    
    /*public AttachmentsToFilesBatch(string qStr){
qString = qStr;
}*/
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        jobStartTime = system.now().getTime();
        String qString = 'SELECT id, ownerId, owner.isActive, parentId, title, body, isPrivate,createdById, createdDate, lastModifiedById, lastModifiedDate FROM Note';
        return Database.getQueryLocator(qstring);
    }     
    global void execute(Database.batchableContext BC, List<Note> Notes){
                /*List<string> parentRecordIds= new List<string>();
        for(sObject sb:scope){
        parentRecordIds.add(string.valueof(sb.get('Id')));
        }
        if(parentRecordIds.size()>0){*/
        system.debug('Notes'+Notes);
        for(Note Nt:Notes){
            String noteBody = ( String.isBlank( Nt.body ) ? '' : Nt.body )
                .replace('&', 'sfdcAMPERSANDsfdc')
                .escapeXml()
                .replace('sfdcAMPERSANDsfdc', '&amp;')
                .replace('&apos;', '&#39;')
                .replace('©', '&copy;')
                .replace('\r\n', '<br>')
                .replace('\r', '<br>')
                .replace('\n', '<br>')
                ;
            
            if ( String.isBlank( noteBody ) ) {
                noteBody = '<p></p>';
            }
            
            Blob nBody = Blob.valueOf( noteBody );
            
            if(noteBody!=null){
                string resultString = UploadFile(nBody,Nt.parentId,Nt.Title);
                if(resultString.startsWith('SUCCESS')){
                    string noteId=resultString.split('-')[1];
                    successRecordString = successRecordString+ Nt.parentId+','+Nt.Id+','+noteId+'\n';
                }else{
                    errorDetailsString = errorDetailsString + Nt.parentId +','+Nt.Id+','+resultString+' \n';
                }
                
            }
        }
        //}
        
    }
    global void finish(Database.batchableContext BC){ 
        jobEndTime = system.now().getTime();
        long batchJobExecutionTimeInSeconds= (jobEndTime - jobStartTime)/1000;
        long batchJobExecutionTimeInMins= batchJobExecutionTimeInSeconds/60;
        long batchJobExecutionTimeInHours= batchJobExecutionTimeInMins/60;
        
        AsyncApexJob a = [SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :BC.getJobId()];
        string jobConclusion='Your NoteToEnhancedNotes Batch batch job with id-'+BC.getJobId()+' to convert attachments to files is completed';
        jobConclusion = jobConclusion + ' This job took '+ string.valueof(batchJobExecutionTimeInMins)+' minutes to complete';
        jobConclusion =jobConclusion +' It executed ' + a.totalJobItems + ' batches.  Of which, ' + a.jobitemsprocessed + ' processed without any exceptions thrown and ' + a.numberOfErrors + ' batches threw unhandled exceptions.';
        system.debug('*******NoteToEnhancedNotes jobConclusion:'+jobConclusion);
        string instanceURL= URL.getSalesforceBaseUrl().gethost();
        Messaging.EmailFileAttachment csvAttcError = new Messaging.EmailFileAttachment();
        blob errorcsvBlob = Blob.valueOf(errorDetailsString);
        string errorcsvname= instanceURL+'Error deatils for attachments not being processed.csv';
        csvAttcError.setFileName(errorcsvname);
        csvAttcError.setBody(errorcsvBlob);
        
        Messaging.EmailFileAttachment csvAttcSuccess = new Messaging.EmailFileAttachment();
        blob successcsvBlob = Blob.valueOf(successRecordString);
        string successcsvname= instanceURL+'-Successfully processed attachments.csv';
        csvAttcSuccess.setFileName(successcsvname);
        csvAttcSuccess.setBody(successcsvBlob);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        String[] toAddresses = new String[] {a.CreatedBy.Email}; 
            mail.setToAddresses(toAddresses);
        mail.setSubject(instanceURL+'-AttachmentsToFilesBatch job is completed.');  
        mail.setPlainTextBody(jobConclusion);
        mail.setHtmlBody(jobConclusion);  
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttcError,csvAttcSuccess});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
    
    public static  string uploadFile(blob blobData,string parentRecId,string filename){
        string resultString='';
        try{
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S for files used in Salesforce, E for external files
            conVer.PathOnClient = filename + '.snote'; // file name with extension
            conVer.Origin = 'H';
            conVer.Title = filename; // file name to display. Usually specify the extension here also
            conVer.VersionData = blobData;
            insert conVer;
            system.debug('conVer'+conVer);
            
            // query for contentdocument Id from ContentVersion
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            
            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            // Can include Chatter users, groups, records (any that support Chatter feed tracking including custom objects), 
            // and Salesforce CRM Content libraries Ids.
            cDe.LinkedEntityId = parentRecId; 
            cDe.ShareType = 'I';  
            cDe.Visibility = 'AllUsers';
            insert cDe;
            system.debug('cDe'+cDe);
            resultString = 'SUCCESS:Id-'+conVer.Id;
        }catch(exception ex){
            system.debug('***Exception while uploading attachment as files:'+ex.getmessage());
            resultString ='ERROR:'+ex.getmessage();
        }
        return resultString;
    }
}