@IsTest
public class AccountProcessorTest {
    
    @IsTest
    private static void countContactsTest(){
        Test.startTest();
        List<Id> AccIds = new List<Id>();
        Account Acc = new Account(Name='Bloom Farms',ShippingPostalCode__c=673643);
        insert Acc;
        contact con1 = new contact(Lastname='Rupnur',AccountId=Acc.Id);
        insert con1;
        AccIds.add(Acc.Id);
        AccountProcessor.countContacts(AccIds);
        Test.stopTest(); 
        Account Acc1 = [SELECT Id,Name,Number_of_Contacts__c FROM Account WHERE Id=:Acc.Id];
        System.assertEquals(1, Acc1.Number_of_Contacts__c);	
    }
}