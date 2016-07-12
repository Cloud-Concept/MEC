@isTest
public class SellOutTrigger_Test {
    static testmethod void testInsertUpdateSellOutObject(){
        
        Product2 prod = new Product2(Name = 'Laptop X300', 
            Family = 'Hardware',Sell_In_Qty__c=100);
        insert prod;
       
        Id pricebookId = Test.getStandardPricebookId();
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
      
        
          
        Account account = new Account(Name='Test Account 1',
                                       CurrencyIsoCode='SAR',
                                       SAP_ID__c='479837934001',
                                       Price_Book__c=customPB.Id);
        
        insert account;
        
        Sell_Out__c sellOutObj = new Sell_Out__c();
        sellOutObj.Account__c = account.Id;
        sellOutObj.Product__c = prod.Id;
        sellOutObj.Week__c = '1';
        sellOutObj.Stock_on_Hand__c = 10;
        
        insert sellOutObj;
        
        sellOutObj.Week__c='4';
        
        update sellOutObj;
    }
}