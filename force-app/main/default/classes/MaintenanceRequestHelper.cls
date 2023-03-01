public with sharing class MaintenanceRequestHelper {
    public static void updateworkOrders(List<Case> updWorkOrders, Map<Id, Case> nonUpdCaseMap) {
        Set<Id> validIds = new Set<Id>();

        for (Case c : updWorkOrders) {
            if (nonUpdCaseMap.get(c.Id).Status != 'Closed' && c.Status == 'Closed') {
                if (c.Type == 'Repair' || c.Type == 'Routine Maintenance') {
                    validIds.add(c.Id);
                }
            }
        }

        if (!validIds.isEmpty()) {
            List<Case> newCases = new List<Case>();
            Map<Id, Case> closedCasesM = new Map<Id, Case>(
                [
                    SELECT
                        Id,
                        Vehicle__c,
                        Equipment__c,
                        Equipment__r.Maintenance_Cycle__c,
                        (SELECT Id, Equipment__c, Quantity__c FROM Equipment_Maintenance_Items__r)
                    FROM Case
                    WHERE Id IN :validIds
                ]
            );
            Map<Id, Decimal> maintenanceCycles = new Map<ID, Decimal>();
            AggregateResult[] results = [
                SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c) cycle
                FROM Equipment_Maintenance_Item__c
                WHERE Maintenance_Request__c IN :ValidIds
                GROUP BY Maintenance_Request__c
            ];

            for (AggregateResult ar : results) {
                maintenanceCycles.put((Id) ar.get('Maintenance_Request__c'), (Decimal) ar.get('cycle'));
            }

            for (Case cc : closedCasesM.values()) {
                Case nc = new Case(
                    ParentId = cc.Id,
                    Status = 'New',
                    Subject = 'Routine Maintenance',
                    Type = 'Routine Maintenance',
                    Vehicle__c = cc.Vehicle__c,
                    Equipment__c = cc.Equipment__c,
                    Origin = 'Web',
                    Date_Reported__c = Date.Today()
                );

                if (maintenanceCycles.containskey(cc.Id)) {
                    nc.Date_Due__c = Date.today().addDays((Integer) maintenanceCycles.get(cc.Id));
                } else {
                    nc.Date_Due__c = Date.today().addDays((Integer) cc.Equipment__r.maintenance_Cycle__c);
                }

                newCases.add(nc);
            }

            insert newCases;

            List<Equipment_Maintenance_Item__c> clonedWPs = new List<Equipment_Maintenance_Item__c>();
            for (Case nc : newCases) {
                for (Equipment_Maintenance_Item__c wp : closedCasesM.get(nc.ParentId).Equipment_Maintenance_Items__r) {
                    Equipment_Maintenance_Item__c wpClone = wp.clone();
                    wpClone.Maintenance_Request__c = nc.Id;
                    ClonedWPs.add(wpClone);
                }
            }
            insert ClonedWPs;
        }
    }
}
// public with sharing class MaintenanceRequestHelper {
//     public static void updateWorkOrders(List<Case> records) {
//         System.debug('/// ' + records);
//         // TODO: Complete the method to update workorders
//         Map<String, Integer> result = getDueDate(records);
//         List<Case> newRecords = new List<Case>();
//         for (Case c : records) {
//             if ((c.Type == 'Routine Maintenance' || c.Type == 'Repair') && c.Status == 'Closed') {
//                 Case maintenaceRequest = new Case();
//                 Equipment_Maintenance_Item__c equipMainttenceItem = new Equipment_Maintenance_Item__c();
//                 String subject = c.Subject;
//                 if (subject == '' || subject == null) {
//                     subject = 'New mantains request';
//                 }
//                 maintenaceRequest.Status = 'New';
//                 maintenaceRequest.Type = 'Routine Maintenance';
//                 maintenaceRequest.Subject = subject;
//                 maintenaceRequest.Vehicle__c = c.Vehicle__c;
//                 maintenaceRequest.Reason = 'Web';
//                 maintenaceRequest.AccountId = c.AccountId;
//                 maintenaceRequest.ContactId = c.ContactId;
//                 maintenaceRequest.Equipment__c = c.Equipment__c;
//                 maintenaceRequest.ProductId = c.ProductId;
//                 maintenaceRequest.Product__c = c.Product__c;
//                 maintenaceRequest.Date_Reported__c = Date.today();
//                 if (result.get(c.Id) != null) {
//                     maintenaceRequest.Date_Due__c = Date.today().addDays(result.get(c.Id));
//                 } else {
//                     maintenaceRequest.Date_Due__c = Date.today();
//                 }
//                 newRecords.add(maintenaceRequest);
//             }
//         }
//         insert newRecords;

//         // List<Equipment_Maintenance_Item__c> newEmiList = new List<Equipment_Maintenance_Item__c>();
//         // Map<String, List<String>> equipmentsMap = getEquipments(records);
//         // System.debug('//// ' + equipmentsMap);
//         // System.debug('//// ' + records);
//         // for (Case oldRecord : records) {
//         //     List<String> requestEquipments = equipmentsMap.get(oldRecord.Id);
//         //     System.debug('//// ' + requestEquipments);
//         //     for (Case newRecord : newRecords) {
//         //         if (
//         //             oldRecord.Vehicle__c == newRecord.Vehicle__c ||
//         //             oldRecord.Subject == newRecord.Subject
//         //         ) {
//         //             for (String equipment : requestEquipments) {
//         //                 System.debug('eq ' + equipment);
//         //                 System.debug('eq ' + newRecord.Id);
//         //                 newEmiList.add(
//         //                     new Equipment_Maintenance_Item__c(
//         //                         Maintenance_Request__c = newRecord.Id,
//         //                         Equipment__c = equipment
//         //                     )
//         //                 );
//         //             }
//         //         }
//         //     }
//         // }
//         // insert newEmiList;
//         // System.debug('new emi list ' + newEmiList);
//     }
//     public static Map<String, Integer> getDueDate(List<Case> caseList) {
//         Map<String, Integer> result = new Map<String, Integer>();
//         Map<Id, Case> caseKeys = new Map<Id, Case>(caseList);
//         List<AggregateResult> wpc = [
//             SELECT
//                 Maintenance_Request__r.Id maintReqID,
//                 MIN(Equipment__r.Maintenance_Cycle__c) cycle
//             FROM Equipment_Maintenance_Item__c
//             WHERE Maintenance_Request__r.Id IN :caseKeys.keySet()
//             GROUP BY Maintenance_Request__r.Id
//         ];
//         for (AggregateResult res : wpc) {
//             Integer addDays = 0;
//             if (res.get('cycle') != null) {
//                 addDays += Integer.valueOf(res.get('cycle'));
//                 result.put((String) res.get('maintReqID'), addDays);
//             }
//         }
//         return result;
//     }

//     // public static Map<String, List<String>> getEquipments(List<Case> caseList) {
//     //     Map<Id, Case> caseKeys = new Map<Id, Case>(caseList);
//     //     List<Equipment_Maintenance_Item__c> result = [
//     //         SELECT Maintenance_Request__c, Equipment__c
//     //         FROM Equipment_Maintenance_Item__c
//     //         WHERE Maintenance_Request__c IN :caseKeys.keySet()
//     //     ];
//     //     Map<String, List<String>> equipments = new Map<String, List<String>>();
//     //     for (Equipment_Maintenance_Item__c rec : result) {
//     //         String maintId = (String) rec.Maintenance_Request__c;
//     //         String equipmentId = (String) rec.Equipment__c;
//     //         if (!equipments.containsKey(maintId)) {
//     //             equipments.put(maintId, new List<String>());
//     //         }
//     //         equipments.get(maintId).add(equipmentId);
//     //     }
//     //     return equipments;
//     // }
// }
