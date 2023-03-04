@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    static List<Product2> listProduct = new List<Product2>();
    static Integer numOfProducts;
    @TestSetup
    static void getEquipments() {
        listProduct = TestDataFactory.getEquipment();
    }
    @isTest
    static void udateProductsTestCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        // Test.startTest();
            // getEquipments();
            // numOfProducts = listProduct.size();
            ID jobID = System.enqueueJob(new WarehouseCalloutService());
        // Test.stopTest();

        // List<Product2> allRecords = [SELECT Id FROM Product2];
        // Product2 product = [SELECT Id FROM Product2 WHERE Warehouse_SKU__c = '55d66226726b611100aaf741'];
        // System.assertEquals(3, allRecords.size());
        // System.assertEquals(true, product.Replacement_Part__c);
        // System.assertEquals(4500, product.Cost__c);
    }
}
