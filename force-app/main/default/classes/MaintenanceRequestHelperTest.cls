@isTest
public class MaintenanceRequestHelperTest {
    // implement scheduled code here
    static List<Case> caseList1 = new List<Case>();
    @TestSetup
    static void getData() {
        caseList1 = TestDataFactory.createData(300, 3);
    }
    @isTest
    static void negativeupdateworkOrders() {
        Vehicle__c vc = new Vehicle__c(Name = 'Test vechicle');
        insert vc;
        Product2 pr = new Product2(Cost__c = 300, Lifespan_Months__c = 1, Maintenance_Cycle__c = 30, Name = 'Test product', Replacement_Part__c = true);
        insert pr;
        Case c = new Case();
        c.Date_Reported__c = Date.today();
        c.Subject = 'Test case subject';
        c.Status = 'New';
        c.Type = 'Web';
        c.Equipment__c = pr.Id;
        c.Vehicle__c = vc.Id;
        insert c;
        Equipment_Maintenance_Item__c emi = new Equipment_Maintenance_Item__c();
        emi.Maintenance_Request__c = c.Id;
        emi.Equipment__c = pr.Id;
        insert emi;
        Test.startTest();
            c.Status = 'Working';
            update c;
        Test.stopTest();
        List<Case> caseResult = [SELECT Id FROM Case WHERE Vehicle__c =: c.Vehicle__c AND Equipment__c =: c.Equipment__c];
        Equipment_Maintenance_Item__c emiResult = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c =: c.Id];
        System.assert(caseResult.size() == 1); 
        System.assert(emiResult!= null);
    }
    @isTest
    static void positiveupdateworkOrders() {
        Test.startTest();
            getData();
            for(Case cs : caseList1) {
                cs.Status = 'Closed';
            }
            update caseList1;
        Test.stopTest();
    }
}
