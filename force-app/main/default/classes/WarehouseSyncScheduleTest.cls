@isTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    @isTest
    public static void scheduleTest() {
        String CRON_EXP = '0 0 1 * * ?';
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
            WarehouseSyncSchedule m = new WarehouseSyncSchedule();
            String jobID = System.schedule('WarehouseSyncScheduleJob', CRON_EXP, m); // or String jobID = System.schedule('WarehouseSyncScheduleJob', sch, new WarehouseSyncSchedule());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
            System.assertEquals(0, ct.TimesTriggered);
            System.assertEquals('2023-03-05 01:00:00',String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}