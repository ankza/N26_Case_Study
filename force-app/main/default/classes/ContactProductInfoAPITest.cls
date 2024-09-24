@isTest
public class ContactProductInfoAPITest {

    // Utility method to create test Contact record
    private static Contact createTestContact(String product, String homeCountry) {
        Contact contact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Product__c = product,
            Home__c = homeCountry
        );
        insert contact;
        return contact;
    }


    @isTest
    static void testGetContactProductInfo_Success() {
        // Setup test data
      
        Contact testContact = createTestContact( 'Standard', 'DE');
        testContact= [Select UUID__c from Contact where id=:testContact.id limit 1];
        // Simulate RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/contactProductInfo/' + testContact.UUID__c;
        RestContext.response = res;

        // Call the method and assert results
        Test.startTest();
        Map<String, String> result = ContactProductInfoAPI.getContactProductInfo();
        Test.stopTest();
        System.debug(result)

        System.assertEquals('€ 0', result.get('CostPerMonth'), 'Cost per month should match');
        System.assertEquals('1.7%', result.get('ATMFee'), 'ATM fee should match');
        System.assertEquals('€ 6', result.get('CardReplacementCost'), 'Card replacement cost should match');
    }

    @isTest
    static void testGetContactProductInfo_NoContact() {
        // Simulate RestRequest with invalid UUID
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/contactProductInfo/InvalidUUID';
        RestContext.request = req;
        RestContext.response = res;

        // Call the method and expect an exception
        try {
            Test.startTest();
            ContactProductInfoAPI.getContactProductInfo();
            Test.stopTest();
            System.assert(false, 'Expected AuraHandledException to be thrown');
        } catch (AuraHandledException e) {
            System.assertEquals('No contact found for the given UUID.', e.getMessage(), 'Exception message should match');
        }
    }

    @isTest
    static void testGetContactProductInfo_NoProductInfo() {
        // Setup test data with no corresponding product information
      
       Contact testRecordContact= createTestContact('Standard', 'FR');
        testRecordContact = [Select UUID__c from Contact where id=:testRecordContact.id limit 1];
        // Simulate RestRequest and RestResponse
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/contactProductInfo/' + testRecordContact.UUID__c;
        RestContext.request = req;
        RestContext.response = res;

        // Call the method and expect an exception
        try {
            Test.startTest();
            ContactProductInfoAPI.getContactProductInfo();
            Test.stopTest();
            System.assert(false, 'Expected AuraHandledException to be thrown');
        } catch (AuraHandledException e) {
            System.assertEquals('No product information found for the given contact.', e.getMessage(), 'Exception message should match');
        }
    }

    @isTest
    static void testGetContactProductInfo_UnexpectedError() {
        // Simulate RestRequest but force an unexpected error
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/contactProductInfo/ErrorTrigger';
        RestContext.request = req;
        RestContext.response = res;

        // Mock an exception by using a non-existent product field
        try {
            Test.startTest();
            ContactProductInfoAPI.getContactProductInfo();
            Test.stopTest();
            System.assert(false, 'Expected AuraHandledException for an unexpected error');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('An unexpected error occurred'), 'Should catch an unexpected error');
        }
    }
}
