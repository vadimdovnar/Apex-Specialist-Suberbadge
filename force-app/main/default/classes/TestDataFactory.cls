@isTest
public class TestDataFactory {
    public static List<Case> createData(Integer numOfCase, Integer numOfProduct) {
        List<Case> caseList = new List<Case>();
        // create Vechicle
        Vehicle__c vechicle = new Vehicle__c(Name = 'Vechicle');
        insert vechicle;
        //create Product
        List<Product2> listProduct = new List<Product2>();
        for (Integer i = 0; i < numOfProduct; i++) {
            Product2 product = new Product2();
            product.Cost__c = i + 100;
            product.Lifespan_Months__c = i + 1;
            product.Maintenance_Cycle__c = i + 50;
            product.Name = 'Equipment ' + i;
            product.Replacement_Part__c = true;
            listProduct.add(product);
        }
        insert listProduct;
        // create Case
        for (Integer i = 0; i < numOfCase; i++) {
            Case newCase = new Case();
            newCase.Status = 'New';
            newCase.Origin = 'Web';
            if (Math.mod(i, 2) == 0) {
                newCase.Type = 'Repair';
            } else {
                newCase.Type = 'Routine Maintenance';
            }
            if (i < numOfProduct) {
                newCase.Equipment__c = listProduct.get(i).Id;
            } else {
                newCase.Equipment__c = listProduct.get(0).Id;
            }
            caseList.add(newCase);
        }
        insert caseList;
        // create Equipment Maintenance Item
        List<Equipment_Maintenance_Item__c> newEquipmentMaintenanceItems = new List<Equipment_Maintenance_Item__c>();
        for (Integer i = 0; i < numOfProduct; i++) {
            Equipment_Maintenance_Item__c newEquipmentMaintenanceItem = new Equipment_Maintenance_Item__c();
            newEquipmentMaintenanceItem.Equipment__c = caseList.get(i).Equipment__c;
            newEquipmentMaintenanceItem.Maintenance_Request__c = caseList.get(i).Id;
            newEquipmentMaintenanceItems.add(newEquipmentMaintenanceItem);
        }
        insert newEquipmentMaintenanceItems;
        return caseList;
    }
    public static List<Product2> getEquipment() {
        List<Product2> listProduct = new List<Product2>();
        Product2 product1 = new Product2(Name = 'Generator 1000 kW', ProductCode = '100003', Warehouse_SKU__c = '55d66226726b611100aaf741', Cost__c = 5000, Lifespan_Months__c = 120, Maintenance_Cycle__c = 365, Current_Inventory__c = 5, Replacement_Part__c = false);
        Product2 product2 = new Product2(Name = 'Cooling Fan', ProductCode = '100004', Warehouse_SKU__c = '55d66226726b611100aaf742', Cost__c = 300, Lifespan_Months__c = 0, Maintenance_Cycle__c = 0, Current_Inventory__c = 183, Replacement_Part__c = false);
        listProduct.add(product1);
        listProduct.add(product2);
        insert listProduct;
        return listProduct;
    }
}
