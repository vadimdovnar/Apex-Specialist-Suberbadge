trigger MaintenanceRequest on Case (before update, after update) {
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
    switch on Trigger.operationType {
        when AFTER_UPDATE {
            MaintenanceRequestHelper.updateWorkOrders(Trigger.New, Trigger.OldMap);
        }
        when BEFORE_UPDATE {
        }
    }
}