@isTest(seeAllData=true)
public class POLoadController_Test {

    static testMethod void testUploadExtraFile(){
        //Create your product
        Product2 prod = new Product2(
             Name = 'Product X',
             isActive = true
        );
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbEntryStd = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        insert pbEntryStd;
        
        
        Account accObj = new Account(Name='Extraa', SAP_ID__c ='Test_MEC',Price_Book__c=pricebookId);    
        insert accObj;
        
        Account childAccObj = new Account(Name='KS1', SAP_ID__c ='Test_MEC_2',Price_Book__c=pricebookId,ParentId=accObj.Id);
        insert childAccObj;
        
        Product_Mapping__c pm = new Product_Mapping__c(Account__c=accObj.Id,Product__c=prod.Id,code__c='001787421');
        insert pm;
        
        Test.startTest();
        Test.setCurrentPage(Page.vfPOLoad);
        
        POLoadController ctrl = new POLoadController();
        ctrl.tmpContact.AccountId = accObj.Id;
        
        ctrl.importCSVFile();
        
        String str = 'Oracle No.,ITEM_DESCRIPTION,KS1' +  '\n'
                        + '001787421,"KDL-50W800C--Sony 50"" Android Bravia 3D LED Full HD TV",7';
        
        ctrl.csvFileBody = Blob.valueOf(str);
        ctrl.importCSVFile();
        ctrl.upload();
        System.assertNotEquals(null,ctrl.prodList);
    
        Test.stopTest();
    }
    
    static testMethod void testUploadVirginFile(){
        //Create your product
        Product2 prod = new Product2(
             Name = 'Product X',
             isActive = true
        );
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbEntryStd = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        insert pbEntryStd;
        
        
    
        Account accObj = new Account(Name='Virgin', SAP_ID__c ='Test_MEC',Price_Book__c=pricebookId);    
        insert accObj;
     
        Product_Mapping__c pm = new Product_Mapping__c(Account__c=accObj.Id,Product__c=prod.Id,code__c='302009');
        insert pm;
     
        Test.startTest();
        Test.setCurrentPage(Page.vfPOLoad);
        
        POLoadController ctrl = new POLoadController();
        ctrl.tmpContact.AccountId = accObj.Id;
        
        String str = 'STORE NUMBER,Store Name,VENDOR NUM,Vendor Name,PO NUMBER,SKU NUMBER,Artist Name,Title,Short Name,Vendorss Number,Diffuser,Manuf/Label,UPC CODE,QTY REQUEST,CURRENT COST' +  '\n'
                        + '202,VIRGIN RED SEA MALL           ,302009,SONY MULTIMEDIA KSA FAISALIAH GRP  ,425932,475418,                         ,DS4 CONTROLLER SILVER                             ,ACCESSOR,CUHZCT1SILVER  ,32009,SO.MU,7.1172E+11,10,222';
        
        ctrl.csvFileBody = Blob.valueOf(str);
        ctrl.importCSVFile();
        ctrl.upload();
        
        
        Test.stopTest();
    }
    
    static testMethod void testUploadExtraFile2(){//User selects OPP
        //Create your product
        Product2 prod = new Product2(
             Name = 'Product X',
             isActive = true
        );
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbEntryStd = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        insert pbEntryStd;
        
        
        Account accObj = new Account(Name='Extraa', SAP_ID__c ='Test_MEC',Price_Book__c=pricebookId);    
        insert accObj;
        
        Account childAccObj = new Account(Name='KS1', SAP_ID__c ='Test_MEC_2',Price_Book__c=pricebookId,ParentId=accObj.Id);
        insert childAccObj;
        
        Product_Mapping__c pm = new Product_Mapping__c(Account__c=accObj.Id,Product__c=prod.Id,code__c='001787421');
        insert pm;
        
        
        Id devRecordTypeIdRFPO = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RFPO').getRecordTypeId();
        
        Opportunity O2 = new Opportunity(Approval_Status__c='PO Approved',
                                          AccountId=accObj.Id,
                                          Name='Opp Test 1',
                                          StageName='new',
                                          RecordTypeId=devRecordTypeIdRFPO,
                                          CloseDate=date.ValueOf('2007-07-21'),
                                          Amount=100,
                                          Expiry_Date__c=date.ValueOf('2007-07-21'),
                                          Due_Date__c=date.ValueOf('2007-07-21'),
                                          PO_Validity__c=date.ValueOf('2007-07-21'),
                                          Rejection_Reason__c='Overdue Payments');
         
         insert O2;
         
         OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID=O2.id,PriceBookEntryID=pbEntryStd.id, quantity=4, totalprice=200,outlet__c=accObj.Id);
        insert lineItem1;
        
        Test.startTest();
        Test.setCurrentPage(Page.vfPOLoad);
        
        POLoadController ctrl = new POLoadController();
        ctrl.tmpContact.AccountId = accObj.Id;
        ctrl.tmpObject.Opportunity__c = O2.id;
        
        ctrl.importCSVFile();
        
        String str = 'Oracle No.,ITEM_DESCRIPTION,KS1' +  '\n'
                        + '001787421,"KDL-50W800C--Sony 50"" Android Bravia 3D LED Full HD TV",7';
        
        ctrl.csvFileBody = Blob.valueOf(str);
        ctrl.importCSVFile();
        ctrl.upload();
        System.assertNotEquals(null,ctrl.prodList);
    
        Test.stopTest();
    }
}