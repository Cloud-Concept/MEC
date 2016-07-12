<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_Sales_Org_Set_FDC</fullName>
        <field>Sales_Org__c</field>
        <literalValue>FDC</literalValue>
        <name>Contact Sales Org Set FDC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Sales_Org_Set_MEC</fullName>
        <field>Sales_Org__c</field>
        <literalValue>MEC</literalValue>
        <name>Contact Sales Org Set MEC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Subscribe_to_Anniversary_Email</fullName>
        <field>Send_Anniversary_Email__c</field>
        <literalValue>1</literalValue>
        <name>Subscribe to Anniversary Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Subscribe_to_birthday</fullName>
        <field>Send_Birthday_Email__c</field>
        <literalValue>1</literalValue>
        <name>Subscribe to birthday</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>01C_Set_Send_Birthday_Email</fullName>
        <actions>
            <name>Subscribe_to_birthday</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>set Send Birthday Email when birthday is entered</description>
        <formula>!ISBLANK(Birth_Date__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>01C_Set_Send_Wedding_Email</fullName>
        <actions>
            <name>Subscribe_to_Anniversary_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>!ISNULL(Wedding_Anniversary_Date__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Birthday Email</fullName>
        <active>false</active>
        <formula>Birthdate = TODAY()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact Sales Org Set FDC</fullName>
        <actions>
            <name>Contact_Sales_Org_Set_FDC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Sales_Org__c</field>
            <operation>equals</operation>
            <value>5700</value>
        </criteriaItems>
        <description>set contact as account</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact Sales Org Set MEC</fullName>
        <actions>
            <name>Contact_Sales_Org_Set_MEC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Sales_Org__c</field>
            <operation>equals</operation>
            <value>3000</value>
        </criteriaItems>
        <description>set contact Sales Org</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales Category Populating</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Sales_Category__c</field>
            <operation>equals</operation>
            <value>Category 1</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Org Set</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Sales_Org__c</field>
            <operation>notEqual</operation>
            <value>MEC,FDC</value>
        </criteriaItems>
        <description>Contact Sales Org to be inherited from the account Sales Org</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
