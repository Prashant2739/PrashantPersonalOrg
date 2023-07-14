public class ResponseWrappers {
    
    public class IntegrationSettings {
        @AuraEnabled public String awsBucketRegion;
        @AuraEnabled public String awsBucketName;
        @AuraEnabled public String awsNameCredentials;
        @AuraEnabled public Integer awsCredentialExpiration;
        @AuraEnabled public String awsThumbnailBucketName;
        @AuraEnabled public String awsObjectAPIVersion;
        @AuraEnabled public Integer awsPartSize;
        @AuraEnabled public Integer awsQueueSize;
        @AuraEnabled public Map<String, Object> awsCredentials;
    }

    public class FieldWrapper {
        @AuraEnabled public String fieldPath;
        @AuraEnabled public String fieldType;
        @AuraEnabled public Boolean required;
        @AuraEnabled public String fieldLabel;
        @AuraEnabled public String fieldHelpText;
    }
}