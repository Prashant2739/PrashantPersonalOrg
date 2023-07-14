public class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, LastName, Company, LeadSource ' +
            'FROM Lead'
        );
    }
    public void execute(Database.BatchableContext bc, List<Lead> scope){
        // process each batch of records
        List<Lead> leadsToUpdate = new List<Lead>();
        for (Lead Leads : scope) {
            Leads.LeadSource = 'Dreamforce';
            leadsToUpdate.add(Leads);
            // increment the instance member counter
            recordsProcessed = recordsProcessed + 1;
        }
        update leadsToUpdate;
    }
    public void finish(Database.BatchableContext bc){
        System.debug('records processed. Shazam!'+ recordsProcessed);
    }
}