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
}
