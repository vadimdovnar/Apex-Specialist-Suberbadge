@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @isTest
    static void udateProductsTestCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
    }
}