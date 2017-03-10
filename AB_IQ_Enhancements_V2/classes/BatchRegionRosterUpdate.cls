/**====================================================================
 * Appirio, Inc
 * Name: BatchRegionRosterUpdate
 * Description: Batch class to update Account Team from Region Roster
 * Created Date: 1 October 2015
 * Created By: Matt Salpietro (Appirio)
 * 
 * Date Modified                Modified By                  Description of the update
 * 3/11/2016                    bnatarajan                   Enhanced for other groups
 * 6/09/2016                    bnatarajan                   Added ability to fetch correct RR based on CustomGroups and Routes as well
 * 3/8/2017                        BBillings                    Changed batch size from 25 to 1
 *
 =====================================================================*/
global class BatchRegionRosterUpdate implements Database.Batchable<sObject>, Schedulable {
    private static List<AccountTeamMemberService> groupServices = new List<AccountTeamMemberService>();
    static {
        // TODO: Add additional groups for which this should also work
        groupServices.add(new NRSAccountTeamMemberService(AccountTeamMemberService.GROUP_NRS));
        groupServices.add(new AccountTeamMemberService.DefaultAccountTeamMemberService(AccountTeamMemberService.GROUP_LABATT));     
        groupServices.add(new AccountTeamMemberService.DefaultAccountTeamMemberService(AccountTeamMemberService.GROUP_HIEND));
        groupServices.add(new AccountTeamMemberService.DefaultAccountTeamMemberService(AccountTeamMemberService.GROUP_ALLMOBILE));
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // This only fetches records that have changed since yesterday for processing
        // TODO: If the processing needs to be more frequent, this query needs to be updated.

        Set<Id> changedCustomGroups = new Set<Id>();
        // fetch routes that have changed
        List<CG_Account__c> changedRoutes = [SELECT Custom_Group__c FROM CG_Account__c WHERE LastModifiedDate >= YESTERDAY];
        // collect custom groups for those changed routes
        if(!changedRoutes.isEmpty()) {
            for(CG_Account__c route : changedRoutes) {
                changedCustomGroups.add(route.Custom_Group__c);
            }
        }

        // Batch job processes all RRs that have changed since yesterday OR RRs for changed routes
        return Database.getQueryLocator([SELECT Id, Group__c, Region_Roster_Account__c, Region_Roster_User__c, Custom_Group__c,
                                                RRST_DIM_ACTV_FLG_US__c, RRST_POSIT_CD__c, Account_Team_Role__c
                                         FROM Region_Roster__c
                                         WHERE LastModifiedDate >= YESTERDAY OR Custom_Group__c IN :changedCustomGroups]);
    }
    
    //Method to schedule the batch class
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new BatchRegionRosterUpdate(), 1);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        Map<Id, List<CG_Account__c>> changedRoutesByCustomGroup = collectChangedRoutesByCustomGroup(scope);
        for(AccountTeamMemberService service : groupServices) {
            service.run(scope, changedRoutesByCustomGroup);
        }
    }

    global void finish(Database.BatchableContext BC) {

    }

    private Map<Id, List<CG_Account__c>> collectChangedRoutesByCustomGroup(List<sObject> scope) {
        Set<Id> changedCustomGroups = new Set<Id>();
        // collect unique custom groups from RR
        for(SObject sobj : scope) {
            Region_Roster__c rr = (Region_Roster__c)sobj;
            if(null != rr.Custom_Group__c) {
                changedCustomGroups.add(rr.Custom_Group__c);
            }
        }

        // fetch routes for these custom groups and group them by custom-group
        Map<Id, List<CG_Account__c>> changedRoutesByCustomGroup = new Map<Id, List<CG_Account__c>>();
        if(!changedCustomGroups.isEmpty()) {
            List<CG_Account__c> allChangedRoutes = [SELECT Active__c, Account__c, Custom_Group__c from CG_Account__c WHERE Custom_Group__c IN :changedCustomGroups];
            if(!allChangedRoutes.isEmpty()) {
                for(CG_Account__c route : allChangedRoutes) {
                    List<CG_Account__c> changedRoutes = changedRoutesByCustomGroup.get(route.Custom_Group__c);
                    if(null == changedRoutes) {
                        changedRoutes = new List<CG_Account__c>();
                        changedRoutesByCustomGroup.put(route.Custom_Group__c, changedRoutes);
                    }
                    changedRoutes.add(route);
                }
            }
        }

        return changedRoutesByCustomGroup;      
    }

}
/**
Code Snippet to schedule the class to run everyday at 10 PM
    BatchRegionRosterUpdate b = new BatchRegionRosterUpdate();
   String sch = '0 0 22 * * ?';
    system.schedule('BatchRegionRosterUpdate', sch, b);
     **/
    /**
Code snippet to run the batch annonymously
    BatchRegionRosterUpdate addBatch = new BatchRegionRosterUpdate();
    ID batchprocessid = Database.executeBatch(addBatch, 1);
**/