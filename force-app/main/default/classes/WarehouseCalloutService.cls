public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    public void execute(QueueableContext context) {
        HttpResponse response = getHttpResponse();
        System.debug(response.getBody());
        List<Product2> products = getProducts(response);
        System.debug(products);
        if (!products.isEmpty()) {
            upsert products Warehouse_SKU__c;
        }
    }
    // return http response
    public static HttpResponse getHttpResponse() {
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(WAREHOUSE_URL);
        httpRequest.setMethod('GET');
        HttpResponse httpResponse = http.send(httpRequest);
        return httpResponse;
    }
    //return list of product object for upsert
    public static List<Product2> getProducts(HttpResponse response) {
        List<Object> externalProducts = (List<Object>) JSON.deserializeUntyped(response.getBody());
        List<Product2> result = new List<Product2>();
        for (Object extRecord : externalProducts) {
            Map<String, Object> productMap = (Map<String, Object>) extRecord;
            Product2 product = new Product2();
            System.debug(extRecord);
            product.Warehouse_SKU__c = (String) productMap.get('_id');
            product.Cost__c = (Integer) productMap.get('cost');
            product.Lifespan_Months__c = (Integer) productMap.get('lifespan');
            product.Maintenance_Cycle__c = (Integer) productMap.get('maintenanceperiod');
            product.Name = (String) productMap.get('name');
            product.Current_Inventory__c = (Integer) productMap.get('quantity');
            product.Replacement_Part__c = true;
            product.ProductCode = (String) productMap.get('sku');
            
            result.add(product);
        }
        return result;
    }
}
