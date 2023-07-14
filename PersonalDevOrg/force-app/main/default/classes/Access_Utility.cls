/**
 * @class name         : Access_Utility.cls
 * @test Class         : Access_Utility_Test.cls
 * @description        : Provide utility methods to check accessibility check methods of objects. 
 * @author             : Extentia Information Technology
 * Ver       Date            Author      		    Modification
 * 1.0    10/6/2020   Extentia Information Technology     Initial Version
**/
public with sharing class Access_Utility {

    /**
    * @description  The method "getObjectReadAccessCheck" perform read access check for given sObject name.
    * @param        objectName - api name of sObject for which check is being performed
    * @return       Boolean - access check result.
    */
    public static boolean getObjectReadAccessCheck(String objectName){
        try{
            Schema.DescribeSObjectResult[] lstDescResult = Schema.describeSObjects( new String[]{objectName});
            if(lstDescResult.get(0) != null && lstDescResult.get(0).isAccessible()){
                return true;
            }
        }catch(Exception exp){
            return false;
        }
        return false;
    }

    /**
    * @description  The method "getObjectUpdateAccessCheck" perform update access check for given sObject name.
    * @param        objectName - api name of sObject for which check is being performed
    * @return       Boolean - access check result.
    */
    public static boolean getObjectUpdateAccessCheck(String objectName){
        try{
            Schema.DescribeSObjectResult[] lstDescResult = Schema.describeSObjects( new String[]{objectName});
            if(lstDescResult.get(0) != null && lstDescResult.get(0).isUpdateable()){
                return true;
            }
        }catch(Exception exp){
            return false;
        }
        return false;
    }

    /**
    * @description  The method "getObjectCreateAccessCheck" perform create access check for given sObject name.
    * @param        objectName - api name of sObject for which check is being performed.
    * @return       Boolean - access check result.
    */
    public static boolean getObjectCreateAccessCheck(String objectName){
        try{
            Schema.DescribeSObjectResult[] lstDescResult = Schema.describeSObjects( new String[]{objectName});
            if(lstDescResult.get(0) != null && lstDescResult.get(0).isCreateable()){
                return true;
            }
        }catch(Exception exp){
            return false;
        }
        return false;
    }

    /**
    * @description  The method "getObjectDeleteAccessCheck" perform delete access check for given sObject name.
    * @param        objectName - api name of sObject for which check is being performed.
    * @return       Boolean - access check result.
    */
    public static boolean getObjectDeleteAccessCheck(String objectName){
        try{
            Schema.DescribeSObjectResult[] lstDescResult = Schema.describeSObjects( new String[]{objectName});
            if(lstDescResult.get(0) != null && lstDescResult.get(0).isDeletable()){
                return true;
            }
        }catch(Exception exp){
            return false;
        }
        return false;
    }
}