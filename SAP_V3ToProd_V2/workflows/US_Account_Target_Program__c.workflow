<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Core_Away</fullName>
        <field>Core_Away__c</field>
        <formula>Program_Target_Level__c-Achieved_Targets__c</formula>
        <name>Core Away</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMB_Away</fullName>
        <field>FMB_Away__c</field>
        <formula>Program_Target_Level__c-Achieved_Targets__c</formula>
        <name>FMB Away</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HE_Away</fullName>
        <field>HE_Away__c</field>
        <formula>Program_Target_Level__c-Achieved_Targets__c</formula>
        <name>HE Away</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Core Away</fullName>
        <actions>
            <name>Core_Away</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>US_Account_Target_Program__c.Brand_Category__c</field>
            <operation>equals</operation>
            <value>CORE</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FMB Away</fullName>
        <actions>
            <name>FMB_Away</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>US_Account_Target_Program__c.Brand_Category__c</field>
            <operation>equals</operation>
            <value>FMB</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HE Away</fullName>
        <actions>
            <name>HE_Away</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>US_Account_Target_Program__c.Brand_Category__c</field>
            <operation>equals</operation>
            <value>HE</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
