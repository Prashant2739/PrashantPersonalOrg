public with sharing class MyRecordsController {
    @AuraEnabled
    public static List<Map<String, String>> getAllObjectsLabel(List<String> objApiList) {
        List<Map<String, String>> items = new List<Map<String, String>>();
        List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(objApiList); 
        for(Schema.DescribeSObjectResult sd: describeSobjectsResult){
            items.add(new Map<String, String>{'value' => sd.getName(), 'label' => sd.getLabel()});
        }        
        return items;
    }
}