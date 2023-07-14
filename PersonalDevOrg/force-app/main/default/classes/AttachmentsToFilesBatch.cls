public class AttachmentsToFilesBatch implements Database.Batchable<sObject>,Database.Stateful{
    public string qString;
    string errorDetailsString = 'Parent Record Id ,Attachment Id, Error deatils \n';
    string successRecordString='Parent Record Id ,Attachment Id,ContentVersionId \n';
    long jobStartTime= 0;
    long jobEndTime= 0;
    
    public AttachmentsToFilesBatch(string qStr){
        qString = qStr;
    }
    public Database.QueryLocator start(Database.BatchableContext BC) {
        jobStartTime = system.now().getTime();
        return Database.getQueryLocator(qstring);
    }     
    public void execute(Database.batchableContext BC, List<sObject> scope){
        List<string> parentRecordIds= new List<string>();
        for(sObject sb:scope){
            parentRecordIds.add(string.valueof(sb.get('Id')));
        }
        if(parentRecordIds.size()>0){
            for(attachment att:[select id,name,parentId,body from Attachment where parentId IN:parentRecordIds]){
                if(att.body!=null && att.body.size()>0){
                    string resultString = UploadFile(att.body,att.parentId,att.Name);
                    if(resultString.startsWith('SUCCESS')){
                        string fileId=resultString.split('-')[1];
                        successRecordString = successRecordString+ att.parentId+','+att.Id+','+fileId+'\n';
                    }else{
                        errorDetailsString = errorDetailsString + att.parentId +','+att.Id+','+resultString+' \n';
                    }
                    
                }
            }
        }
        
    }
    public void finish(Database.batchableContext BC){ 
        jobEndTime = system.now().getTime();
        long batchJobExecutionTimeInSeconds= (jobEndTime - jobStartTime)/1000;
        long batchJobExecutionTimeInMins= batchJobExecutionTimeInSeconds/60;
        long batchJobExecutionTimeInHours= batchJobExecutionTimeInMins/60;
        
        AsyncApexJob a = [SELECT id, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :BC.getJobId()];
        string jobConclusion='Your AttachmentsToFilesBatch batch job with id-'+BC.getJobId()+' to convert attachments to files is completed';
        jobConclusion = jobConclusion + ' This job took '+ string.valueof(batchJobExecutionTimeInMins)+' minutes to complete';
        jobConclusion =jobConclusion +' It executed ' + a.totalJobItems + ' batches.  Of which, ' + a.jobitemsprocessed + ' processed without any exceptions thrown and ' + a.numberOfErrors + ' batches threw unhandled exceptions.';
        system.debug('*******AttachmentsToFilesBatch jobConclusion:'+jobConclusion);
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
            conVer.PathOnClient = filename; // file name with extension
            conVer.Title = filename; // file name to display. Usually specify the extension here also
            conVer.VersionData = blobData;
            insert conVer;
            
            // query for contentdocument Id from ContentVersion
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            
            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            // Can include Chatter users, groups, records (any that support Chatter feed tracking including custom objects), 
            // and Salesforce CRM Content libraries Ids.
            cDe.LinkedEntityId = parentRecId; 
            //I- The user’s permission is determined by the related record. For library, it is defined by user library permission.
            //V - Viewer permission. The user can explicitly view but not edit the shared file.
            //C -Collaborator permission. The user can explicitly view and edit the shared file.
            cDe.ShareType = 'I';  
            insert cDe;
            resultString = 'SUCCESS:Id-'+conVer.Id;
        }catch(exception ex){
            system.debug('***Exception while uploading attachment as files:'+ex.getmessage());
            resultString ='ERROR:'+ex.getmessage();
        }
        return resultString;
    }
}