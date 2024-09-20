@isTest
public class ProductInfoControllerTest {
    
    @testSetup
    static void setupTestData() {
        // Create a test Contact record with necessary fields
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Product__c = 'Standard', // Ensure it matches with a custom metadata record
            Home__c = 'DE' // Ensure it matches with a custom metadata record
        );
        insert testContact;

        // Create a test Case related to the contact
        Case testCase = new Case(
            Subject = 'Test Case',
            ContactId = testContact.Id
        );
        insert testCase;
    }
    
    @isTest
    static void testGetProductInfoFromMetadata_Success() {
        // Query the test case
        Case testCase = [SELECT Id FROM Case LIMIT 1];

        // Mock the custom metadata in the test context using the standard Apex stub method
        Test.startTest();
        // You can use mocking frameworks or just query the existing metadata for your tests
        Map<String, String> productInfo = ProductInfoController.getProductInfoFromMetadata(testCase.Id);
        Test.stopTest();
        
        // Assertions
        System.assertEquals('€ 0', productInfo.get('Cost'), 'The cost should be €0');
        System.assertEquals('1.7%', productInfo.get('ATMFee'), 'The ATM Fee should be 1.7%');
        System.assertEquals('€ 6', productInfo.get('ReplacementCost'), 'The card replacement cost should be €6');
    }
    
}
