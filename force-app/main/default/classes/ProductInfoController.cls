public with sharing class ProductInfoController {
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getProductInfoFromMetadata(Id caseId) {
        Case caseRecord = [SELECT Contact.Product__c, Contact.Home__c 
                           FROM Case WHERE Id = :caseId LIMIT 1];
        
        
        String product = caseRecord.Contact.Product__c;
        String country = caseRecord.Contact.Home__c;

        // Query the custom metadata
        ProductInformation__mdt productInfo = [
            SELECT Cost_Per_Calendar_Month__c, 	ATM_Fee_in_other_currencies__c, Card_Replacement_Cost__c
            FROM ProductInformation__mdt
            WHERE Product__c = :product AND CountryCode__c = :country
            LIMIT 1
        ];

        // Return the product data as a map
        Map<String, String> productData = new Map<String, String>();
        productData.put('Cost', productInfo.Cost_Per_Calendar_Month__c);
        productData.put('ATMFee', productInfo.ATM_Fee_in_other_currencies__c);
        productData.put('ReplacementCost', productInfo.Card_Replacement_Cost__c);

        return productData;
    }
}
