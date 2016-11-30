<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_mail_to_AB_support</fullName>
        <description>Send mail to AB support team when a case created</description>
        <protected>false</protected>
        <recipients>
            <recipient>cait.marshall@anheuser-busch.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt.schuett@nuvemconsulting.com.naz.prod</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_Email_To_AB_Support</template>
    </alerts>
    <rules>
        <fullName>Send Mail To AB Support from IOS</fullName>
        <actions>
            <name>Send_mail_to_AB_support</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ONTAP__Case_Force__c.ONTAP__Subject__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ONTAP__Case_Force__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Mobility360_Cases</value>
        </criteriaItems>
        <description>send mail to AB support team when a case logged</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
