public with sharing class FacetedAccSearchController {
    
    public class getPicklistValuesWrapper {
        @AuraEnabled
        public Map<String,String> getIndustryValues;  
        @AuraEnabled
        public Map<String,String> getRatingValues;  
    }
    
    @AuraEnabled
    public static List<Account> searchAccounts(String accountSearchQuery) {
        return Database.query(accountSearchQuery);
    }
    
    public static getPicklistValuesWrapper getDetailsOnLoad(){
        
        getPicklistValuesWrapper picklistWrapper = new getPicklistValuesWrapper();
        
        Map<String,String> industryOptions = new Map<String,String>();
		Map<String,String> ratingOptions = new Map<String,String>();
        
        for( Schema.PicklistEntry industryPicklist : Account.Industry.getDescribe().getPicklistValues()){
            industryOptions.put(industryPicklist.getValue(), industryPicklist.getLabel());
        } 

		for( Schema.PicklistEntry ratingPicklist : Account.Rating.getDescribe().getPicklistValues()){
            ratingOptions.put(ratingPicklist.getValue(), ratingPicklist.getLabel());
        }
		
        picklistWrapper.getIndustryValues = industryOptions;
		picklistWrapper.getRatingValues = ratingOptions;
        
        return picklistWrapper;
    }
    
}