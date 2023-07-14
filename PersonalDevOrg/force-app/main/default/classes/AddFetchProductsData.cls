public class AddFetchProductsData {

    
    @AuraEnabled
    public static list<OpportunityLineItem> fetchDataFromServer(string OppId){
        
        List<OpportunityLineItem> fetchedProducts = [SELECT Id, OpportunityId, Name, Quantity, TotalPrice 
                                                     FROM OpportunityLineItem
                                                     WHERE OpportunityId=:OppId];
        return fetchedProducts;
    }
    
}