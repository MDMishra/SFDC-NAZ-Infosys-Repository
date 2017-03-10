/**====================================================================
 * Appirio, Inc
 * Name: BatchRegionRosterUpdateTest
 * Description: Test Class for BatchRegionRosterUpdate
 * Created Date: 1 October 2015
 * Created By: Matt Salpietro (Appirio)
 * 
 * Date Modified                Modified By                  Description of the update
 * 03/11/2016                   bnatarajan                   Updated for proper testing
 * 
 =====================================================================*/
@isTest @TestVisible
private class BatchRegionRosterUpdateTest {
    @TestVisible
    private static final String SAMPLE_USERNAME = 'sampleuser@sampleNRSUser.anheuserbusch.com';
    @TestVisible
    private static final String SAMPLE_ACCOUNT_NAME = 'Customer Corporate NRS Test';
    @TestVisible
    private static final String ATM_ROLE_1 = 'Test Role 1';
    private static final String ATM_ROLE_2 = 'Test Role 2';
    private static final String POSIT_CODE_1 = 'Test 1';
    private static final String POSIT_CODE_2 = 'Test 2';
    private static final String GROUP_NRS = 'NRS';
//  private static final String GROUP_HiEnd = 'HiEnd';
    private static final String GROUP_AllMobile = 'AllMobile';
    private static final String GROUP_Labatt = 'Labatt';

    @isTest
    static void itShouldUpdateATMAndAccountShare() {
        String username = SAMPLE_USERNAME + '.1';
        User testUser1 = [ select Id from User where UserName = :username ];
        System.assert(null != testUser1);
        username = SAMPLE_USERNAME + '.2';
        User testUser2 = [ select Id from User WHERE UserName = :username ];
        System.assert(null != testUser2);
        username = SAMPLE_USERNAME + '.3';
        User testUser3 = [ select Id from User WHERE UserName = :username ];
        System.assert(null != testUser3);
        username = SAMPLE_USERNAME + '.4';
        User testUser4 = [ select Id from User WHERE UserName = :username ];        
        System.assert(null != testUser4);
        username = SAMPLE_USERNAME + '.5';
        User testUser5 = [ select Id from User WHERE UserName = :username ];        
        System.assert(null != testUser5);
        
        String accountname = SAMPLE_ACCOUNT_NAME + '.1';
        Account testAcc1 = [ select Id from Account where Name = :accountname LIMIT 1];
        System.assert(null != testAcc1);
/*      accountname = SAMPLE_ACCOUNT_NAME + '.2';
        Account testAcc2 = [ select Id from Account where Name = :accountname LIMIT 1];
        System.assert(null != testAcc2);
        accountname = SAMPLE_ACCOUNT_NAME + '.3';
        Account testAcc3 = [ select Id from Account where Name = :accountname LIMIT 1];
        System.assert(null != testAcc3);
*/
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser) {

            // RUN BATCH JOB
            Test.startTest();
                BatchRegionRosterUpdate b = new BatchRegionRosterUpdate();
                Database.executeBatch(b);
            Test.stopTest();

            // check ATMs
            // ==========

            // atm-role-1 should be created because of active flag for NRS account
            List<AccountTeamMember> atms = [SELECT AccountId, UserId, TeamMemberRole
                                                   FROM AccountTeamMember
                                                   WHERE AccountId = :testAcc1.Id
                                                   AND UserId = :testUser1.Id
                                                   AND TeamMemberRole = :ATM_ROLE_1
                                                   /*AND AccountAccessLevel = 'Edit'*/];
            System.assertEquals(1, atms.size());
            // atm-role-1 should be created for HiEnd
            atms = [SELECT AccountId, UserId, TeamMemberRole
                           FROM AccountTeamMember
//                         WHERE AccountId = :testAcc2.Id
                           WHERE AccountId = :testAcc1.Id
                           AND UserId = :testUser3.Id
                           AND TeamMemberRole = :ATM_ROLE_1
                           /*AND AccountAccessLevel = 'Edit'*/];
            System.assertEquals(1, atms.size());
            // atm-role-1 should be created for AllMobile
            atms = [SELECT AccountId, UserId, TeamMemberRole
                           FROM AccountTeamMember
//                         WHERE AccountId = :testAcc3.Id
                           WHERE AccountId = :testAcc1.Id
                           AND UserId = :testUser4.Id
                           AND TeamMemberRole = :ATM_ROLE_1
                           /*AND AccountAccessLevel = 'Edit'*/];
            System.assertEquals(1, atms.size());

            // atm-role-2 should be removed because of inactive flag for NRS account
            Integer i = [SELECT COUNT()
                           FROM AccountTeamMember
                           WHERE AccountId = :testAcc1.Id
                           AND UserId = :testUser2.Id
                           AND TeamMemberRole = :ATM_ROLE_2];
            System.assertEquals(i, 0);

            // check AccountShares
            // ===================

            // there should be team account-shares for atm-role-1 with proper access levels for all accounts
            i = [SELECT COUNT() 
                            FROM AccountShare
                            WHERE AccountId = :testAcc1.Id
                            AND UserOrGroupId = :testUser1.Id
                            AND RowCause = 'Team'
                            /*AND AccountAccessLevel = 'Edit'
                            AND OpportunityAccessLevel = 'Edit'*/];
            System.assertEquals(i, 1);
            i = [SELECT COUNT() 
                            FROM AccountShare
//                          WHERE AccountId = :testAcc2.Id
                            WHERE AccountId = :testAcc1.Id
                            AND UserOrGroupId = :testUser3.Id
                            AND RowCause = 'Team'
                            /*AND AccountAccessLevel = 'Edit'
                            AND OpportunityAccessLevel = 'Edit'*/];
            System.assertEquals(i, 1);
            i = [SELECT COUNT() 
                            FROM AccountShare
//                          WHERE AccountId = :testAcc3.Id
                            WHERE AccountId = :testAcc1.Id
                            AND UserOrGroupId = :testUser4.Id
                            AND RowCause = 'Team'
                            /*AND AccountAccessLevel = 'Edit'
                            AND OpportunityAccessLevel = 'Edit'*/];
            System.assertEquals(i, 1);      
            
            //Test additional functionality
            
            accountname = SAMPLE_ACCOUNT_NAME + '.1';
            Account testAcc2 = [ select Id from Account where Name = :'Test Account' LIMIT 1];
            System.assert(null != testAcc1);
            
            atms = [SELECT AccountId, UserId, TeamMemberRole
                           FROM AccountTeamMember
                           WHERE AccountId = :testAcc2.Id
                           AND UserId = :testUser5.Id
                           /*AND AccountAccessLevel = 'Edit'*/];
            System.assertEquals(1, atms.size());
        }
    }

    @testSetup
    private static void setupTestData() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];

        System.runAs(thisUser) {
            Account[] accounts = new Account[] {
                TestUtils.createTestAccount(SAMPLE_ACCOUNT_NAME + '.1', 'Customer', null)
                /*TestUtils.createTestAccount(SAMPLE_ACCOUNT_NAME + '.2', 'Customer', null),
                TestUtils.createTestAccount(SAMPLE_ACCOUNT_NAME + '.3', 'Customer', null)*/
            };
            insert accounts;

            User[] users = new User[] { 
                TestUtils.createTestUserWithProfile(SAMPLE_USERNAME + '.1', 'Standard User', 1),
                TestUtils.createTestUserWithProfile(SAMPLE_USERNAME + '.2', 'Standard User', 2),
                TestUtils.createTestUserWithProfile(SAMPLE_USERNAME + '.3', 'Standard User', 3),
                TestUtils.createTestUserWithProfile(SAMPLE_USERNAME + '.4', 'Standard User', 4),
                TestUtils.createTestUserWithProfile(SAMPLE_USERNAME + '.5', 'Standard User', 5)
            };
            insert users;

            Region_Roster_Mapping__c rrm = new Region_Roster_Mapping__c(Name = POSIT_CODE_1, Account_Team_Role__c = ATM_ROLE_1);
            insert rrm;
            Region_Roster_Mapping__c rrm2 = new Region_Roster_Mapping__c(Name = POSIT_CODE_2, Account_Team_Role__c = ATM_ROLE_2);
            insert rrm2;
            
            AccountTeamMember testATM = new AccountTeamMember();
            testATM.AccountId = accounts[0].Id;
            testATM.UserId = users[0].Id;
            testATM.TeamMemberRole = ATM_ROLE_2;
            insert testATM;
            
            // NRS uses POSIT_CD field for position code that needs to be translated to ATM role
            Region_Roster__c testRR = new Region_Roster__c();
            testRR.Region_Roster_Account__c = accounts[0].Id;
            testRR.Region_Roster_User__c = users[0].Id;
            testRR.RRST_DIM_ACTV_FLG_US__c = true;
            testRR.RRST_POSIT_CD__c = POSIT_CODE_1;
            testRR.Group__c = GROUP_NRS;
            insert testRR;

            // NRS uses POSIT_CD field for position code that needs to be translated to ATM role
            Region_Roster__c testRR2 = new Region_Roster__c();
            testRR2.Region_Roster_Account__c = accounts[0].Id;
            testRR2.Region_Roster_User__c = users[1].Id;
            testRR2.RRST_DIM_ACTV_FLG_US__c = false;
            testRR2.RRST_POSIT_CD__c = POSIT_CODE_2;
            testRR2.Group__c = GROUP_NRS;
            insert testRR2;

            // HiEnd uses POSIT_CD field for ATM role
            Region_Roster__c testRR3 = new Region_Roster__c();
            testRR3.Region_Roster_Account__c = accounts[0].Id;
            testRR3.Region_Roster_User__c = users[2].Id;
            testRR3.RRST_DIM_ACTV_FLG_US__c = true;
            testRR3.Account_Team_Role__c = ATM_ROLE_1;
//          testRR3.Group__c = GROUP_HiEnd;         //Picklist value deactivated.
            testRR3.Group__c = GROUP_Labatt;
            insert testRR3;

            // AllMobile uses POSIT_CD field for ATM role
            Region_Roster__c testRR4 = new Region_Roster__c();
            testRR4.Region_Roster_Account__c = accounts[0].Id;
            testRR4.Region_Roster_User__c = users[3].Id;
            testRR4.RRST_DIM_ACTV_FLG_US__c = true;
            testRR4.Account_Team_Role__c = ATM_ROLE_1;
            testRR4.Group__c = GROUP_Labatt;
            insert testRR4;     
            
            //Create data for Additional functionality (Custom_Group__c) 
            Account acc = HE_TestUtil.createAccount(true);
            Custom_Group__c cgroup = HE_TestUtil.createCustomGroup(true);
            CG_Account__c cAcc = HE_TestUtil.createCGAccount(cgroup.Id, acc.Id, true);
            Region_Roster__c rr = HE_TestUtil.createRegionRoster(cgroup.Id, null, users[4].Id, false);
            rr.RRST_DIM_ACTV_FLG_US__c = true;
            insert rr;
        }
    }
}