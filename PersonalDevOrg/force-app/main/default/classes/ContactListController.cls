public class ContactListController {
	
    @AuraEnabled
    public static List<Contact> getContactList(){
        List<Contact> conList = new List<Contact>([SELECT Id, Name, Email, Phone 
                                                  FROM Contact 
                                                  WHERE Email = 'prashantrupnur@gmail.com']);
        return conList;
    }
}