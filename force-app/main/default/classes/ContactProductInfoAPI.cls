@RestResource(urlMapping='/contactProductInfo/*')
global with sharing class ContactProductInfoAPI {

    @HttpGet
    global static Map<String, String> getContactProductInfo() {
        Map<String, String> result = new Map<String, String>();

        try {
            // Get the UUID from the request URL
            RestRequest req = RestContext.request;
            String uuid = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

            // Query Contact based on UUID
            Contact contact = [SELECT Id, Product__c, Home__c FROM Contact WHERE UUID__c = :uuid LIMIT 1];
            
            // Check if the contact exists
            if (contact == null) {
                throw new AuraHandledException('No contact found for the given UUID.');
            }

            // Query Product Information custom metadata based on the contact's product and country
            ProductInformation__mdt productInfo = [
                SELECT Cost_per_Calendar_Month__c, ATM_Fee_in_other_currencies__c, Card_Replacement_Cost__c
                FROM ProductInformation__mdt
                WHERE Product__c = :contact.Product__c AND CountryCode__c = :contact.Home__c
                LIMIT 1
            ];

            // Check if the product information exists
            if (productInfo == null) {
                throw new AuraHandledException('No product information found for the given contact.');
            }

            // Add product information to the result map
            result.put('CostPerMonth', productInfo.Cost_per_Calendar_Month__c);
            result.put('ATMFee', productInfo.ATM_Fee_in_other_currencies__c);
            result.put('CardReplacementCost', productInfo.Card_Replacement_Cost__c);}

     catch (Exception e) {
            // Catch any other general exceptions
            throw new AuraHandledException('An unexpected error occurred: ' + e.getMessage());
        }

        // Return the result map containing the product information
        return result;
    }
}
