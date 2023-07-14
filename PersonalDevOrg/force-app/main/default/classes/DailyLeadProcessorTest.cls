@isTest
private class DailyLeadProcessorTest {
    
    
    @testSetup
    static void initialize() {
        List<Lead> testLeads = new List<Lead>();
        for(Integer i=0; i<200; i++) {
            testLeads.add(new Lead(lastname = 'Smith'+i, company = 'Acme'+i));
        }
        insert testLeads;
        
        System.assertEquals(200, testLeads.size());
        
        for(Lead l : testLeads) {
            System.assertNotEquals(null, l.Id);
            System.assertEquals(null, l.LeadSource);
        }
    }
    
    static testMethod void testSchedulableDailyLeadProcessor() {
        List<Lead> testLeads = [ SELECT Id FROM Lead ];     
        System.assertEquals(200, testLeads.size());
        
        //[seconds][minutes][hours][Day_of_Month][Month][Day_of_Week][Optional_Year]
        String sch = '0 0 0 15 3 ? 2022';
        
        List<Lead> leadsBefore = [SELECT Id FROM Lead WHERE LeadSource = null AND Id in: testLeads];
        System.assertEquals( 200, leadsBefore.size() );
        
        test.startTest();
        
        Id jobId = System.schedule('LeadSchedulerTest', sch, new DailyLeadProcessor());
    }
}