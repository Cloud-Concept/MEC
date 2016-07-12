@isTest(seeAllData=true)
public class AddProductController_Test {
    
    static testmethod void testgetSearchCriteriaMethod(){
        
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
        
          Account account2 = new Account(Name='Test Account 2',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='47983793400184398493',
                                       Price_Book__c=customPB2.Id);
         
         insert account2;
         
         Account account = new Account(Name='Test Account 1',
                                       CurrencyIsoCode='SAR',
                                       ParentId=account2.Id,
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
    	AddProductController APController = new AddProductController(sc);
        APController.RelatedAccount = account2;
        
        List<Customer_Category_Classfication__c> CustomerCategoryClassficationS = new List<Customer_Category_Classfication__c>();
        CustomerCategoryClassficationS.add(new Customer_Category_Classfication__c(Account__c=account2.Id));
        
        insert CustomerCategoryClassficationS;
        
        APController.getSearchCriteria();
        account.ParentId=null;
      
        update account;
		O.Contact__c = null;
        update O;
           
        ApexPages.CurrentPage().getparameters().put('id', O.id);
   		sc = new ApexPages.standardController(O);
    	APController = new AddProductController(sc);
        APController.RelatedAccount = account2;
        
        APController.getSearchCriteria();
    }
    
    static testmethod void testsetAddDisabled(){
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
        
         List<Account> accounts = new List<Account>();
        
          Account account2 = new Account(Name='Test Account 2',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='47983793400184398493',
                                       Price_Book__c=customPB2.Id);
        
          Account account = new Account(Name='Test Account 1',
                                       CurrencyIsoCode='SAR',
                                       ParentId=account2.Id,
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='479837934001',
                                       Price_Book__c=customPB.Id);
        
        
        
          Account account3 = new Account(Name='Test Account 3',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='479837934004311231',
                                       Price_Book__c=customPB.Id);
        
          Account account4 = new Account(Name='Test Account 4',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='47983793404343101',
                                       Price_Book__c=customPB.Id);
        
          Account account5 = new Account(Name='Test Account 5',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='4798379340032131',
                                       Price_Book__c=customPB.Id);
        
        accounts.add(account);
        accounts.add(account2);
        accounts.add(account3);
        accounts.add(account4);
        accounts.add(account5);
        
        insert accounts;
        Contact NewContact = new Contact (
						FirstName = 'xyzFirst',
						LastName = 'XyZLast',
						AccountId = account.Id,
						Email = 'xyzmail@mail.com');
        
		insert NewContact;

         Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PO').getRecordTypeId();
         Id devRecordTypeIdRFPO = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RFPO').getRecordTypeId();
        
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
        
        List<Product_Classification__c> classifications = new List<Product_Classification__c>();
        Product_Classification__c prod_class = new Product_Classification__c(Classification_Level__c='A',Product__c=prod.Id);
        Product_Classification__c prod_class2 = new Product_Classification__c(Classification_Level__c='B',Product__c=prod2.Id);
        Product_Classification__c prod_class3 = new Product_Classification__c(Classification_Level__c='C',Product__c=prod.Id);
        Product_Classification__c prod_class4 = new Product_Classification__c(Classification_Level__c='D',Product__c=prod2.Id);
        
        classifications.add(prod_class);
        classifications.add(prod_class2);
        classifications.add(prod_class3);
        classifications.add(prod_class4);
        
        insert classifications;
        
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
        
        Sell_Out__c sellOutObj = new Sell_Out__c(Account__c=account.Id,Product__c=prod.Id,Stock_on_Hand__c=100,Year__c='2016');
        insert sellOutObj;
        Sell_Out__c sellOutObj2 = new Sell_Out__c(Account__c=account2.Id,Product__c=prod2.Id,Stock_on_Hand__c=100,Year__c='2016');
        insert sellOutObj2;
        
        Warehouse__c warehouse = new Warehouse__c(Distribution_Ch__c='nfeinfien',Division__c='nfoienfoie',Sale_Org__c='nfeonfioe');
        insert warehouse;
        
        
        Stock__c stock = new Stock__c(Article__c=prod.Id,Descr_of_Storage_Loc__c='hfdonfoiniof',Site__c=warehouse.Id);
        insert stock;
        List<AddProductController.Wrapper> searchResult = new List<AddProductController.Wrapper>();
        AddProductController.Wrapper wrapper = new AddProductController.Wrapper(false,account,prod,sellOutObj,stock,oppLineItems.get(2),O,customPrice);
        AddProductController.Wrapper wrapper11 = new AddProductController.Wrapper(true,account,prod,sellOutObj,stock,oppLineItems.get(2),O,customPrice);
        AddProductController.Wrapper wrapper2 = new AddProductController.Wrapper(false,account2,prod2,sellOutObj2,stock,oppLineItems.get(3),O,customPrice2);
        AddProductController.Wrapper wrapper22 = new AddProductController.Wrapper(true,account2,prod2,sellOutObj2,stock,oppLineItems.get(3),O,customPrice2);
        
        
        
        AddProductController.Wrapper wrapper222 = new AddProductController.Wrapper(true,account2,prod2,null,stock,oppLineItems.get(1),O,customPrice2);
        AddProductController.Wrapper wrapper223 = new AddProductController.Wrapper(true,account2,prod2,sellOutObj2,stock,oppLineItems.get(1),O,customPrice2);
        
        searchResult.add(wrapper);
        searchResult.add(wrapper11);
        searchResult.add(wrapper2);
        searchResult.add(wrapper22);
        searchResult.add(wrapper222);
        searchResult.add(wrapper223);
        ApexPages.CurrentPage().getparameters().put('id', O.id);
   		ApexPages.StandardController sc = new ApexPages.standardController(O);
    	AddProductController APController = new AddProductController(sc);
        APController.SearchResult = SearchResult;
        APController.SetAddDisabled();
        APController.SetPrevDisabled();
       
        
        
        List<AddProductController.SearchWrapper> searchWrapperResult = new List<AddProductController.SearchWrapper>();
        
        AddProductController.SearchWrapper SearchWrapper1 = new AddProductController.SearchWrapper(true,'Category','Class',account.Id);
        AddProductController.SearchWrapper SearchWrapper2 = new AddProductController.SearchWrapper(false,'Category','Class',account.Id);
        AddProductController.SearchWrapper SearchWrapper3 = new AddProductController.SearchWrapper(true,'Category','Class',account2.Id);
        AddProductController.SearchWrapper SearchWrapper4 = new AddProductController.SearchWrapper(false,'Category','Class',account2.Id);
        
        searchWrapperResult.add(SearchWrapper1);
        searchWrapperResult.add(SearchWrapper2);
        searchWrapperResult.add(SearchWrapper3);
        searchWrapperResult.add(SearchWrapper4);
        
        ApexPages.CurrentPage().getparameters().put('id', O.id);
   		sc = new ApexPages.standardController(O);
    	APController = new AddProductController(sc);
        APController.SearchCriteria = searchWrapperResult;
        APController.SetSearchDisabled();        
        
        ApexPages.CurrentPage().getparameters().put('id', O.id);
   		sc = new ApexPages.standardController(O);
    	APController = new AddProductController(sc);
        APController.SearchCriteria = searchWrapperResult;
        APController.AccountList = accounts;
       
        
        APController.doSearch();
        
        account.ParentId=null;
        update account;
        
        ApexPages.CurrentPage().getparameters().put('id', O.id);
   		sc = new ApexPages.standardController(O);
    	APController = new AddProductController(sc);
        APController.SearchCriteria = searchWrapperResult;
        APController.SearchResult = SearchResult;
        
        APController.doSearch();
        
    }
    
    static testmethod void testNextAndPreviousAccounts(){
        
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
        
        List<Account> accounts = new List<Account>();
        Account account = new Account(Name='Test Account 1',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='4798379380894001',
                                       Price_Book__c=customPB.Id);
        
          Account account2 = new Account(Name='Test Account 2',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='479837934005324141',
                                       Price_Book__c=customPB.Id);
        
          Account account3 = new Account(Name='Test Account 3',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='479837934004311231',
                                       Price_Book__c=customPB.Id);
        
          Account account4 = new Account(Name='Test Account 4',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='47983793404343101',
                                       Price_Book__c=customPB.Id);
        
          Account account5 = new Account(Name='Test Account 5',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='4798379340032131',
                                       Price_Book__c=customPB.Id);
        
        accounts.add(account);
        accounts.add(account2);
        accounts.add(account3);
        accounts.add(account4);
        accounts.add(account5);
        
        insert accounts;
        
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
        
        ApexPages.CurrentPage().getparameters().put('id', O.id);
   		ApexPages.StandardController sc = new ApexPages.standardController(O);
    	AddProductController APController = new AddProductController(sc);
        APController.AccountList = accounts;
        APController.CurrentAccount = account;
        APController.getSearchCriteria();
        APController.getNextAccount();
        APController.getPrevAccount();
        APController.Beginning();
        APController.Next();
        APController.Previous();
        APController.getDisablePrevious();
        APController.getDisableNext();
  /*      APController.AccountList = accounts;
        APController.CurrentAccount = account;
        APController.getSearchCriteria();*/
        
    }
    
    static testMethod void testAddOppLineItem(){
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
        
        Account Parentaccount = new Account(Name='Test Account 1',
                                       CurrencyIsoCode='SAR',
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='4798379380821294001',
                                       Price_Book__c=customPB.Id);
        
        insert ParentAccount;
        
        Account account = new Account(Name='Test Account 1',
                                       CurrencyIsoCode='SAR',
                                      ParentId=ParentAccount.Id,
                                       RecordTypeId=accountRecordRypeDDS,
                                       SAP_ID__c='4798379380894001',
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
        
        Warehouse__c warehouse = new Warehouse__c(Distribution_Ch__c='nfeinfien',Division__c='nfoienfoie',Sale_Org__c='nfeonfioe');
        insert warehouse;
        
        Stock__c stock = new Stock__c(Article__c=prod.Id,Descr_of_Storage_Loc__c='hfdonfoiniof',Site__c=warehouse.Id);
        insert stock;
        
       List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        
		OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID=O.id,PriceBookEntryID=customPrice.id, quantity=4, totalprice=200);
        OpportunityLineItem lineItem2 = new OpportunityLineItem (OpportunityID=O.id,UnitPrice=123.00, Quantity=1,Description=null, Discount=100, PricebookEntryId=customPrice.Id);

        OpportunityLineItem lineItem3 = new OpportunityLineItem (OpportunityID=O.id,UnitPrice=100,RFPO_Qty__c=1000,PriceBookEntryID=customPrice.id, quantity=6);
        OpportunityLineItem lineItem4 = new OpportunityLineItem (OpportunityID=O.id,UnitPrice=300,PO_Qty__c=2000,PriceBookEntryID=customPrice.id, quantity=7);
        OpportunityLineItem lineItem5 = new OpportunityLineItem (OpportunityID=O.id,UnitPrice=100,RFPO_Qty__c=1000,PriceBookEntryID=customPrice.id, quantity=8);
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
        
        List<AddProductController.Wrapper> searchResult = new List<AddProductController.Wrapper>();
        AddProductController.Wrapper wrapper = new AddProductController.Wrapper(false,account,prod,null,stock,oppLineItems.get(2),O,customPrice);
        AddProductController.Wrapper wrapper11 = new AddProductController.Wrapper(true,account,prod,null,stock,oppLineItems.get(2),O,customPrice);
        AddProductController.Wrapper wrapper2 = new AddProductController.Wrapper(false,account,prod,null,stock,oppLineItems.get(3),O,customPrice);
        AddProductController.Wrapper wrapper22 = new AddProductController.Wrapper(true,account,prod,null,stock,oppLineItems.get(3),O,customPrice);
        AddProductController.Wrapper wrapper222 = new AddProductController.Wrapper(true,account,prod,null,stock,oppLineItems.get(1),O,customPrice);
        AddProductController.Wrapper wrapper223 = new AddProductController.Wrapper(true,account,prod,null,stock,oppLineItems.get(1),O,customPrice);
        
        List<AddProductController.SearchWrapper> searchWrapperResult = new List<AddProductController.SearchWrapper>();
        
        AddProductController.SearchWrapper SearchWrapper1 = new AddProductController.SearchWrapper(true,'Category','Class',account.Id);
        AddProductController.SearchWrapper SearchWrapper2 = new AddProductController.SearchWrapper(false,'Category','Class',account.Id);
        
        searchWrapperResult.add(SearchWrapper1);
        searchWrapperResult.add(SearchWrapper2);
        
        searchResult.add(wrapper);
        searchResult.add(wrapper11);
        searchResult.add(wrapper2);
        searchResult.add(wrapper22);
        searchResult.add(wrapper222);
        searchResult.add(wrapper223);
        
        ApexPages.CurrentPage().getparameters().put('id', O.id);
   		ApexPages.StandardController sc = new ApexPages.standardController(O);
    	AddProductController APController = new AddProductController(sc);
        APController.SearchResult = SearchResult;
        APController.SearchCriteria = searchWrapperResult;
        APController.AddOppLineItemsReturn();
        
       
    }
}