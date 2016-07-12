<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Record_Type_RS</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Regional_Sales</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type RS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unique_Account_Name</fullName>
        <field>Account_Unique_Name__c</field>
        <formula>Name</formula>
        <name>Unique Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unique_Account_Name1</fullName>
        <field>Account_Unique_Name__c</field>
        <formula>Name</formula>
        <name>Unique Account Name1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>DDS</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_ECommerce</fullName>
        <field>RecordTypeId</field>
        <lookupValue>E_Commerce</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type ECommerce</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Employee_Sales</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Employee_Sales</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Employee Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Exports</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Exports</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Exports</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Game_Dealers</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Game_Dealers</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Game Dealers</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_KeyAccount</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Key_Account</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type KeyAccount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Service_Centers</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Service_Centers</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Service Centers</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_ShowRoom</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Showrooms</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type ShowRoom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SAP_Unique_ID</fullName>
        <field>SAP_Unique_Id__c</field>
        <formula>SAP_Unique_Id_Formula__c</formula>
        <name>Update SAP Unique ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>A01 Account Record Type DDS</fullName>
        <actions>
            <name>Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SGRP__c</field>
            <operation>equals</operation>
            <value>510</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>A01 Account Record Type ECommerce</fullName>
        <actions>
            <name>Update_Record_Type_ECommerce</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SGRP__c</field>
            <operation>equals</operation>
            <value>610</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>A01 Account Record Type Employee Sales</fullName>
        <actions>
            <name>Update_Record_Type_Employee_Sales</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SGRP__c</field>
            <operation>equals</operation>
            <value>620</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>A01 Account Record Type Exports</fullName>
        <actions>
            <name>Update_Record_Type_Exports</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SGRP__c</field>
            <operation>equals</operation>
            <value>630</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>A01 Account Record Type Game Dealers</fullName>
        <actions>
            <name>Update_Record_Type_Game_Dealers</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SGRP__c</field>
            <operation>equals</operation>
            <value>580</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>A01 Account Record Type KeyAccount</fullName>
        <actions>
            <name>Update_Record_Type_KeyAccount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2 or 3 or 4</booleanFilter>
        <criteriaItems>
            <field>Account.SGRP__c</field>
            <operation>equals</operation>
            <value>540</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.SGRP__c</field>
            <operation>equals</operation>
            <value>550</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.SGRP__c</field>
            <operation>equals</operation>
            <value>560</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.SGRP__c</field>
            <operation>equals</operation>
            <value>640</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>A01 Account Record Type Regional Sales</fullName>
        <actions>
            <name>Record_Type_RS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>SGRP__c = &quot;520&quot; || SGRP__c = &quot;570&quot; || SGRP__c = &quot;590&quot; || SGRP__c = &quot;600&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>A01 Account Record Type Service Centers</fullName>
        <actions>
            <name>Update_Record_Type_Service_Centers</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SGRP__c</field>
            <operation>equals</operation>
            <value>990</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>A01 Account Record Type Show Room</fullName>
        <actions>
            <name>Update_Record_Type_ShowRoom</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Account.SGRP__c</field>
            <operation>equals</operation>
            <value>530</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Generate SAP Unique Id</fullName>
        <actions>
            <name>Update_SAP_Unique_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Sales_Org__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Account Information</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Accepts_Partial_Order__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Unique Account Name2</fullName>
        <actions>
            <name>Unique_Account_Name1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISNEW() || ISCHANGED(Name) || ISBLANK( Account_Unique_Name__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
