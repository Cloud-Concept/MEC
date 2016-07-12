<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Rejection_Confirmation</fullName>
        <ccEmails>mec@cloudconceptgroup.com</ccEmails>
        <description>Approval/Rejection Confirmation</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>Sales_Director_and_Support</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RFPO_PO_Automated/RFPO_PO_Approval_Rejection_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>New_RFPO_PO_Approval</fullName>
        <description>New RFPO/PO Approval</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>Sales_Director_and_Support</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RFPO_PO_Automated/New_RFPO_PO_Approval</template>
    </alerts>
    <alerts>
        <fullName>Rejection_Email</fullName>
        <ccEmails>mec@cloudconceptgroup.com</ccEmails>
        <description>Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>Sales_Director_and_Support</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RFPO_PO_Automated/RFPO_PO_Approval_Rejection_Confirmation</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_to_submited</fullName>
        <description>Change Approval Status to &quot;Submitted&quot;</description>
        <field>Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Approval Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Approval_status</fullName>
        <description>- Set Approval Status = &apos;RFPO Approved&apos;</description>
        <field>Approval_Status__c</field>
        <literalValue>RFPO Approved</literalValue>
        <name>Change RFPO Approval status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_PO_Approval_status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>PO Approved</literalValue>
        <name>Change PO Approval status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_type</fullName>
        <description>- Set record type to &apos;PO&apos;</description>
        <field>RecordTypeId</field>
        <lookupValue>PO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PO_Validity</fullName>
        <field>PO_Validity__c</field>
        <formula>TODAY() +  Account.PO_Validity__c</formula>
        <name>PO Validity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Name</fullName>
        <field>Name</field>
        <formula>Opportunity_Number__c</formula>
        <name>Update Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PO Validity</fullName>
        <actions>
            <name>PO_Validity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.PO_Validity__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>Updating the PO Validity on PO based on account standard PO Validity</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Name</fullName>
        <actions>
            <name>Update_Opportunity_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.From_Upload__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Price Book as Account</fullName>
        <active>false</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
