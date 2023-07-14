/**
* **********************************************************************************************************
* Class         :   PhotoGalleryUtility
* Test Classes  :   PhotoGalleryUtilityTest
* ***********************************************************************************************************
* @author       Extentia Information Technology
* @created      2020-June-06
* @version      1.0
* @description  The class "PhotoGalleryUtility" refers to the 'photoGallery', 'photoGalleryInternal', 'photoGalleryConfiguration' lightning web component 
                and associated child components. It provide common utility methods to perform operations related to Photo Gallery and Retrieve AWS Integration setting
                configuration, Updating configuration settings etc.. 
*/
public with sharing class PhotoGalleryUtility {
    /* Custom Setting Constant */
    private static final String AWS_CUSTOM_SETTING = 'AWS_Photo_Gallery_Integration_Setting__c';

    /**
    * @description  The method 'getConfigData' return the custom setting information required for photo gallery AWS services. (Org Wide Settings Only)
    * @return       Returns Custom setting AWS_Photo_Gallery_Integration_Setting__c wrapped in ResponseWrappers.IntegrationSettings wrapper.
    */
    @AuraEnabled(cacheable=true)
    public static ResponseWrappers.IntegrationSettings getConfigData() {
        ResponseWrappers.IntegrationSettings settings = new ResponseWrappers.IntegrationSettings();
        try{
            if (Access_Utility.getObjectReadAccessCheck(AWS_CUSTOM_SETTING)) {
                AWS_Photo_Gallery_Integration_Setting__c orgDefault = AWS_Photo_Gallery_Integration_Setting__c.getOrgDefaults();
                settings.awsBucketRegion = orgDefault.AWS_Bucket_Region__c;
                settings.awsBucketName = orgDefault.AWS_S3_Bucket_Name__c;
                settings.awsNameCredentials = orgDefault.Named_Credential__c;
                settings.awsCredentialExpiration = Integer.valueOf(orgDefault.Credential_Expiration__c);
                settings.awsThumbnailBucketName = orgDefault.AWS_S3_Bucket_Name_For_Thumbnails__c;
                settings.awsObjectAPIVersion = orgDefault.AWS_S3_Object_API_Version__c;
                settings.awsPartSize = (Integer) orgDefault.Upload_Part_Size__c;
                settings.awsQueueSize = (Integer) orgDefault.Upload_Queue_Size__c;
            }
        }catch(Exception exp){
            /*FALSE POSITIVE: This is implemented for exception handling so that debugging gets easier. There isn’t any sensitive information.*/
            throw new AuraHandledException('CONFIGURATION_ACCESS_ERROR');
        }
        return settings;
    }

    /**
    * @description  The method 'getConfigAndIntegrationData' return the custom setting information along with integration credentials.
    * @return       Returns Custom setting AWS_Photo_Gallery_Integration_Setting__c wrapped in ResponseWrappers.IntegrationSettings wrapper.
    */
    @AuraEnabled(cacheable=true)
    public static ResponseWrappers.IntegrationSettings getConfigAndIntegrationData() {
        ResponseWrappers.IntegrationSettings settings = new ResponseWrappers.IntegrationSettings();
        try{
            if (Access_Utility.getObjectReadAccessCheck(AWS_CUSTOM_SETTING)) {
                settings = PhotoGalleryUtility.getConfigData();
                settings.awsCredentials = PhotoGalleryUtility.generateAWSCredentials(settings.awsNameCredentials, settings.awsCredentialExpiration);
            }
        }catch(Exception exp){
            /*FALSE POSITIVE: This is implemented for exception handling so that debugging gets easier. There isn’t any sensitive information.*/
            throw new AuraHandledException('CONFIGURATION_INTEGRATION_ACCESS_ERROR');
        }
        return settings;
    }

    /**
    * @description  The method 'setConfigData' upserts the custom setting information required for photo gallery AWS services. (Org Wide Settings Only)
    * @param        settingsSerialized - serialized configuration settings wrapper in ResponseWrappers.IntegrationSettings wrapper
    * @return       Boolean - result of operation
    */
    @AuraEnabled
    public static Boolean setConfigData(String settingsSerialized) {
        try{
            ResponseWrappers.IntegrationSettings settings = (ResponseWrappers.IntegrationSettings)JSON.deserialize(settingsSerialized, ResponseWrappers.IntegrationSettings.class); //Deserialize JSON into APEX 
            if(Access_Utility.getObjectUpdateAccessCheck(AWS_CUSTOM_SETTING) && Access_Utility.getObjectCreateAccessCheck(AWS_CUSTOM_SETTING)){
                //Fetch common configuration settings (Org default)
                AWS_Photo_Gallery_Integration_Setting__c settingsRecord = AWS_Photo_Gallery_Integration_Setting__c.getOrgDefaults();

                //Map AWS_Photo_Gallery_Integration_Setting__c fields with inputs from user
                settingsRecord.AWS_Bucket_Region__c = settings.awsBucketRegion;
                settingsRecord.Named_Credential__c = settings.awsNameCredentials;
                settingsRecord.Credential_Expiration__c = Integer.valueOf(settings.awsCredentialExpiration);
                settingsRecord.AWS_S3_Bucket_Name__c = settings.awsBucketName;
                settingsRecord.AWS_S3_Bucket_Name_For_Thumbnails__c = settings.awsThumbnailBucketName;
                settingsRecord.AWS_S3_Object_API_Version__c = settings.awsObjectAPIVersion;
                settingsRecord.Upload_Part_Size__c = Integer.valueOf(settings.awsPartSize);
                settingsRecord.Upload_Queue_Size__c = Integer.valueOf(settings.awsQueueSize);

                //Create or update existing AWS_Photo_Gallery_Integration_Setting__c record
                Database.UpsertResult upsertRes = Database.upsert(settingsRecord);
                if(upsertRes.isSuccess()){
                    return true;
                }
            }
        }catch(Exception exp){
            /*FALSE POSITIVE: This is implemented for exception handling so that debugging gets easier. There isn’t any sensitive information.*/
            throw new AuraHandledException('CONFIGURATION_UPDATE_ERROR');
        }
        return false;
    }

    /**
    * @description  The method 'getFieldsFromObject' return list of Fields List<ResponseWrappers.FieldWrapper> from given object api name.
    * @param        sObjectAPIName - API name of the object to retrieve fields from.
    * @return       List<ResponseWrappers.FieldWrapper> - List of fields details Wrapped in ResponseWrappers.FieldWrapper wrapper.
    */
    @AuraEnabled(cacheable=true)
    public static List<ResponseWrappers.FieldWrapper> getFieldsFromObject(String sObjectAPIName) {
        List<ResponseWrappers.FieldWrapper> lstFieldWrapList = new List<ResponseWrappers.FieldWrapper>();
        ResponseWrappers.FieldWrapper eachField;
        try{
            if(String.isNotBlank(sObjectAPIName) && Access_Utility.getObjectReadAccessCheck(sObjectAPIName)){
                for (Schema.SObjectField objField: Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().fields.getMap().values()) {
                    if (objField.getDescribe().isAccessible()) {
                        eachField = new ResponseWrappers.FieldWrapper();
                        eachField.fieldPath = objField.getDescribe().getLocalName();
                        eachField.fieldType = String.valueOf(objField.getDescribe().getType());
                        eachField.required = (objField.getDescribe().isCreateable() && !objField.getDescribe().isNillable() && !objField.getDescribe().isDefaultedOnCreate());
                        eachField.fieldLabel = objField.getDescribe().getLabel();
                        eachField.fieldHelpText = objField.getDescribe().getInlineHelpText();
                        lstFieldWrapList.add(eachField); 
                    }
                }
            }
        }catch(Exception exp){
            /*FALSE POSITIVE: This is implemented for exception handling so that debugging gets easier. There isn’t any sensitive information.*/
            throw new AuraHandledException('CONFIGURATION_OBJECT_ACCESS_ERROR');
        }
        return lstFieldWrapList;
    }

    /**
    * @description  The method 'generateAWSCredentials' return AWS credentials fetched from AWS STS service.
    * @param        namedCredentialName - API name of the named credentials to be used for callout auth.
    * @param        expirationInSeconds - Expiration time for temporary credentials.
    * @return       Map<String, Object> - Contains temporary credentials or error message if failed.
    */
    private static Map<String, Object> generateAWSCredentials(String namedCredentialName, Integer expirationInSeconds) {
        Map<String, Object> mapResponse = new Map<String, Object>();
        try {
            AWSWrappers.AWSCredentials credential = AWSServices.getAWSCredentials(expirationInSeconds, namedCredentialName);
            if (credential!=null) {
                mapResponse.put('result', credential);
            }else{
                mapResponse.put('error', 'AWS_TEMP_CREDS_ERROR');
            }
        } catch (Exception exp) {
            /*FALSE POSITIVE: This is implemented for exception handling so that debugging gets easier. There isn’t any sensitive information.*/
            mapResponse.put('error', 'Error generating AWS credentials. '+exp.getMessage());
        }

        return mapResponse;
    }

    
}