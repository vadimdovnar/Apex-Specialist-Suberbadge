@isTest
public class WarehouseCalloutServiceMock implements HttpCalloutMock{
    // implement http mock callout
    public HttpResponse respond(HttpRequest request) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"_id": "55d66226726b611100aaf741","replacement": false,"quantity": 5,"name": "Generator 1000 kW","maintenanceperiod": 310,"lifespan": 100,"cost": 4500,"sku": "100003"},{"_id": "55d66226726b611100aaf742","replacement": false,"quantity": 183,"name": "Cooling Fan","maintenanceperiod": 30,"lifespan": 10,"cost": 500,"sku": "100004"},{"_id": "55d66226726b611100aaf743","replacement": true,"quantity": 143,"name": "Fuse 20A","maintenanceperiod": 0,"lifespan": 0,"cost": 22,"sku": "100005"}]');
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        return res;
    }
}