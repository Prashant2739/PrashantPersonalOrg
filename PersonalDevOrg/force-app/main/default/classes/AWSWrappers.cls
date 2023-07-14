public class AWSWrappers {

    public class AWSCredentials {
        @AuraEnabled public String accessKeyId;
        @AuraEnabled public String secretAccessKey;
        @AuraEnabled public String sessionToken;
        @AuraEnabled public Datetime expiration;
    }
}