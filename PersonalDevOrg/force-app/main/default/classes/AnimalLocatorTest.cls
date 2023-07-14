@isTest
private class AnimalLocatorTest 
{
    @isTest static void testPostCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        String expectedValue = AnimalLocator.getAnimalNameById(5);
        System.debug('expectedValue=' + expectedValue);
        System.assertEquals('Tiger', expectedValue);    
    }
}