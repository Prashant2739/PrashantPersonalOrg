global class DailyLeadProcessor implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<Lead> leads = [SELECT Id, LastName, Company, LeadSource
                            FROM Lead
                            WHERE LeadSource = null
                            LIMIT 200];
        List<Lead> leadsToUpdate = new List<Lead>();
        for(lead ld: leads ){
            ld.LeadSource = 'Dreamforce';
            leadsToUpdate.add(ld);
        }
        update leadsToUpdate;
    }
}