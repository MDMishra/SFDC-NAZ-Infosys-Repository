<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Budget_Plan_Approval_Notification</fullName>
        <description>Budget Plan Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>POC_Planning/POC_Planning_Budget_Approved</template>
    </alerts>
    <alerts>
        <fullName>Budget_Plan_Rejection_Notification</fullName>
        <description>Budget Plan Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>POC_Planning/POC_Planning_Budget_Rejected</template>
    </alerts>
    <alerts>
        <fullName>POC_Planning_Budget_Updated</fullName>
        <description>POC Planning Budget Updated</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>POC_Planning/POC_Planning_Budget_Updated</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_Approved</fullName>
        <description>Update Approval Status to Approved</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Approval Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_Rejected</fullName>
        <description>Update Approval Status to Rejected</description>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Approval Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_Required</fullName>
        <description>Update Approval Status to Required if Discretionary or Drivers Budget is updated</description>
        <field>Approval_Status__c</field>
        <literalValue>Required</literalValue>
        <name>Update Approval Status to Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_Submitted</fullName>
        <description>Update Approval Status to Submitted for Approval</description>
        <field>Approval_Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Update Approval Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Approval Status to Required when updated</fullName>
        <actions>
            <name>POC_Planning_Budget_Updated</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Approval_Status_to_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Approval Status to Required when Discretionary or Driver Budget is updated</description>
        <formula>And (

 ISPICKVAL( Approval_Status__c , &quot;Approved&quot;) ,

OR(
 ISCHANGED( Discretionary_Budget__c ) ,
ISCHANGED(  Drivers_Budget__c  )

)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
