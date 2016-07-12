<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Active_field</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Update Active field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Active_field_2</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Update Active field - 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Product Flag</fullName>
        <actions>
            <name>Update_Active_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.Item_Status__c</field>
            <operation>equals</operation>
            <value>B</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Product Flag - 2</fullName>
        <actions>
            <name>Update_Active_field_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product2.Item_Status__c</field>
            <operation>equals</operation>
            <value>A,C</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
