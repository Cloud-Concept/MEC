@isTest
public class DetailsPage_Test {
    
	static testMethod void testDetailsPage() {
        
        Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware');
        insert prod;
        
        Product2 prod2 = new Product2(Name = 'Laptop X300', 
            Family = 'Hardware',Sell_In_Qty__c=100);
        insert prod2;
       
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
         PricebookEntry standardPrice2 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod2.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice2;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        Pricebook2 customPB2 = new Pricebook2(Name='Custom Pricebook2', isActive=true);
        insert customPB2;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice2 = new PricebookEntry(
            Pricebook2Id = customPB2.Id, Product2Id = prod2.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice2;
         
         string idd;
         Id accountRecordRypeDDS = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('DDS').getRecordTypeId();
         
         Account account = new Account(Name='Test Account 1',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='479837934001',
                                       Price_Book__c=customPB.Id);
         
         insert account;
        
         Account account2 = new Account(Name='Test Account 2',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='47983793400184398493',
                                       Price_Book__c=customPB2.Id);
         
         insert account2;
         
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
        
         Opportunity O2 = new Opportunity(Approval_Status__c='PO Approved',
                                          AccountId=account2.Id,
                                          Name='Opp Test 1',
                                          StageName='new',
                                          RecordTypeId=devRecordTypeId,
                                          CloseDate=date.ValueOf('2007-07-21'),
                                          Amount=100,
                                          Expiry_Date__c=date.ValueOf('2007-07-21'),
                                          Due_Date__c=date.ValueOf('2007-07-21'),
                                          PO_Validity__c=date.ValueOf('2007-07-21'),
                                          Rejection_Reason__c='Overdue Payments');
         
         insert O2;
        
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        
		OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID=O.id,PriceBookEntryID=customPrice.id, quantity=4, totalprice=200);
        OpportunityLineItem lineItem2 = new OpportunityLineItem (OpportunityID=O.id,UnitPrice=123.00, Quantity=1,Description=null, Discount=100, PricebookEntryId=customPrice.Id);

        OpportunityLineItem lineItem3 = new OpportunityLineItem (OpportunityID=O.id,UnitPrice=100,RFPO_Qty__c=1000,PriceBookEntryID=customPrice.id, quantity=6);
        OpportunityLineItem lineItem4 = new OpportunityLineItem (OpportunityID=O.id,UnitPrice=300,PO_Qty__c=2000,PriceBookEntryID=customPrice.id, quantity=7);
        OpportunityLineItem lineItem5 = new OpportunityLineItem (OpportunityID=O2.id,UnitPrice=100,RFPO_Qty__c=1000,PriceBookEntryID=customPrice2.id, quantity=8);
        OpportunityLineItem lineItem6 = new OpportunityLineItem (OpportunityID=O.id,PriceBookEntryID=customPrice.id, quantity=9, totalprice=2005);
        OpportunityLineItem lineItem7 = new OpportunityLineItem (OpportunityID=O.id,PriceBookEntryID=customPrice.id, quantity=10, totalprice=2006);
        
        oppLineItems.add(lineItem1);
        oppLineItems.add(lineItem2);
        oppLineItems.add(lineItem3);
        oppLineItems.add(lineItem4);
        oppLineItems.add(lineItem6);
        oppLineItems.add(lineItem7);
        
 		insert oppLineItems;        
        insert lineItem5;
        
        ApexPages.CurrentPage().getparameters().put('id', O.id);
   		ApexPages.StandardController sc = new ApexPages.standardController(O);
    	DetailsPage sic = new DetailsPage(sc);
       	Test.startTest();
    }
}