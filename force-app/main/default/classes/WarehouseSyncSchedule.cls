public with sharing class WarehouseSyncSchedule implements Schedulable {
    // implement scheduled code here
    // 
    // WarehouseSyncSchedule m = new WarehouseSyncSchedule();
    // String sch = '0 0 1 * * ?';
    // String jobID = System.schedule('WarehouseSyncScheduleJob', sch, m);
    public void execute(SchedulableContext sc) {
        // call Queueable apex work
        ID jobID = System.enqueueJob(new WarehouseCalloutService());
    }
}
