@isTest
public class ConvertToSalesOrder_Test {
    
    static testMethod void insertOrder() {
        
      Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
         
         string idd;
         Id accountRecordRypeDDS = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('DDS').getRecordTypeId();
         
         Account account = new Account(Name='Test Account 1',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='479837934001',
                                       Price_Book__c=customPB.Id);
         
         insert account;
         
         Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PO').getRecordTypeId();
         
         Opportunity O = new Opportunity(Approval_Status__c='PO Approved',
                                          AccountId=account.Id,
                                          Name='Opp Test 1',
                                          StageName='new',
                                          RecordTypeId=devRecordTypeId,
                                          CloseDate=date.ValueOf('2007-07-21'),
                                          Amount=100,
                                          Expiry_Date__c=date.ValueOf('2007-07-21'),
                                          Due_Date__c=date.ValueOf('2007-07-21'),
                                          PO_Validity__c=date.ValueOf('2007-07-21'),
                                          Rejection_Reason__c='Overdue Payments');
         
         insert O;
         
		 OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID=O.id,PriceBookEntryID=customPrice.id, quantity=4, totalprice=200);
         insert lineItem1;
         
         ConvertToSalesOrder.Convert(O.Id);
     }
    
    static testMethod void insertOrder2(){
        
         Id accountRecordRypeDDS = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('DDS').getRecordTypeId();
         
         Account account = new Account(Name='Test Account 1',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='479837934001');
        
        insert account;
       
         Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RFPO').getRecordTypeId();
        
         Opportunity O = new Opportunity(Approval_Status__c='Not Approved',
                                          AccountId=account.Id,
                                          Name='Opp Test 1',
                                          StageName='new',
                                          RecordTypeId=devRecordTypeId,
                                          CloseDate=date.ValueOf('2007-07-21'),
                                          Amount=100,
                                          Expiry_Date__c=date.ValueOf('2007-07-21'),
                                          Due_Date__c=date.ValueOf('2007-07-21'),
                                          PO_Validity__c=date.ValueOf('2007-07-21'),
                                          Rejection_Reason__c='Overdue Payments');
         
         insert O;
         
         ConvertToSalesOrder.Convert(O.Id);
    }
    
}