@isTest
public class OpportunityProductsTrigger_Test {
    static testmethod void testInsertUpdateOpportunityProducts(){
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
        
        Contact NewContact = new Contact (
						FirstName = 'xyzFirst',
						LastName = 'XyZLast',
						AccountId = account.Id,
						Email = 'xyzmail@mail.com');
        
		insert NewContact;

         Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PO').getRecordTypeId();
         Opportunity O = new Opportunity(Approval_Status__c='PO Approved',
                                          AccountId=account.Id,
                                          Name='Opp Test 1',
                                          Contact__c=NewContact.Id,
                                          StageName='new',
                                          RecordTypeId=devRecordTypeId,
                                          CloseDate=date.ValueOf('2007-07-21'),
                                          Amount=100,
                                          Expiry_Date__c=date.ValueOf('2007-07-21'),
                                          Due_Date__c=date.ValueOf('2007-07-21'),
                                          PO_Validity__c=date.ValueOf('2007-07-21'),
                                          Rejection_Reason__c='Overdue Payments');
         
         insert O;
        
        Product_Mapping__c productMappingObj = new Product_Mapping__c(product__c=prod.Id,Account__c=account.Id);
        insert productMappingObj;
        
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        
		OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID=O.id,PriceBookEntryID=customPrice.id, quantity=4, totalprice=200);
        OpportunityLineItem lineItem2 = new OpportunityLineItem (OpportunityID=O.id,UnitPrice=123.00, Quantity=1,Description=null, Discount=100, PricebookEntryId=customPrice.Id);

        OpportunityLineItem lineItem3 = new OpportunityLineItem (OpportunityID=O.id,UnitPrice=100,RFPO_Qty__c=1000,PriceBookEntryID=customPrice.id, quantity=6);
        OpportunityLineItem lineItem4 = new OpportunityLineItem (OpportunityID=O.id,UnitPrice=300,PO_Qty__c=2000,PriceBookEntryID=customPrice.id, quantity=7);
        OpportunityLineItem lineItem6 = new OpportunityLineItem (OpportunityID=O.id,PriceBookEntryID=customPrice.id, quantity=9, totalprice=2005);
        OpportunityLineItem lineItem7 = new OpportunityLineItem (OpportunityID=O.id,PriceBookEntryID=customPrice.id, quantity=10, totalprice=2006);
        
        oppLineItems.add(lineItem1);
        oppLineItems.add(lineItem2);
        oppLineItems.add(lineItem3);
        oppLineItems.add(lineItem4);
        oppLineItems.add(lineItem6);
        oppLineItems.add(lineItem7);
        
 		insert oppLineItems;        
    }
}