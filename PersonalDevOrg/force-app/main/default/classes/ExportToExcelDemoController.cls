public with sharing class ExportToExcelDemoController { 
    public class ContactWrapper{  
      @AuraEnabled  
      public string contactName;  
      @AuraEnabled  
      public string contactEmail;  
      public ContactWrapper(Contact contactObj){  
        this.contactName = contactObj.Name;  
        this.contactEmail = contactObj.Email;  
      }  
    }  
    @AuraEnabled  
    public static List<ContactWrapper> getContacts(){  
      List<ContactWrapper> contactWrapperList = new List<ContactWrapper>();  
      for(Contact cwObj : [select id, Name, Email from Contact limit 5]){  
        contactWrapperList.add(new ContactWrapper(cwObj));  
      }  
      return contactWrapperList;  
    }  
  }