global class ConvertToSalesOrder{
    
    webservice static String Convert(string OppID)
    {                  
        Opportunity O = [SELECT ID,
                         Approval_Status__c,
                         Stage__c,
                         Amount,
                         name,
                         Pricebook2Id,
                         Due_Date__c,
                         PO_Validity__c,
                         Rejection_Reason__c,
                         Expiry_Date__c,
                         ContractId,
                         AccountId, Account.name from Opportunity Where ID=:OppID];  
                                        
        if(O.Approval_Status__c=='PO Approved')
        {
            if(O.Stage__c=='PO- Partial Filled' || O.Stage__c=='PO-Filled')
            {
                
                try{
                
                    Map<Id, Quote> quotes = new Map<Id, Quote>();
                    Map<Id, List<QuoteLineItem>> quoteItems = new Map<Id, List<QuoteLineItem>>();
                    
                    List<OpportunityLineItem> POList =[select Id,Outlet__c,Outlet__r.name,Product2Id,ListPrice,UnitPrice,Quantity,pricebookentryId from OpportunityLineItem where OpportunityId=:OppID];
                    
                    for(OpportunityLineItem OL : POList)
                    {
                         if(quotes.get(OL.Outlet__c)==null){
                             Quote q = new Quote();
                             q.name = 'Quote-'+OL.Outlet__r.name+'-' + o.name;
                             q.opportunityId = o.id;
                             q.Pricebook2Id = o.Pricebook2Id;
                             q.integration_status__c = 'Pending'; 
                             q.ExpirationDate = System.today().addDays(7);
                             quotes.put(OL.Outlet__c,q);    
                         }
                         if(quoteItems.get(OL.Outlet__c)==null){
                             quoteItems.put(OL.Outlet__c, new List<QuoteLineItem>());
                         }
                         QuoteLineItem qutlineitem = new QuoteLineItem(Product2Id = OL.Product2Id,
                             Quantity = OL.Quantity , UnitPrice = OL.UnitPrice , PricebookEntryId = OL.pricebookentryId,
                             Outlet__c = OL.Outlet__c);
                         quoteItems.get(OL.Outlet__c).add(qutlineitem);
                    }
                    
                    insert quotes.values();
                    
                    for(Id key : quotes.keySet()){
                        for(integer j=0;j<quoteItems.get(key).size();j++){
                            quoteItems.get(key)[j].quoteId = quotes.get(key).id;
                        }
                        insert quoteItems.get(key);    
                    }
                    
                    return 'Quotations are created Successfully!';
                    //pageRef = new PageReference('/'+Ord.ID);                   
                    
                    //Sending email
                    //Messaging.reserveSingleEmailCapacity(2);
                    //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                    
                    //User UserEmail = [select id,email from User where username='cloudconcept@mec.com.dev'];
                    //String[] toAddresses = new String[]{UserEmail.email};
                    //mail.setTargetObjectId(UserEmail.id);
                    //mail.setWhatId(Ord.ID);
                    //mail.setUseSignature(false);                    
                    //mail.setBccSender(false);
                    //mail.setSaveAsActivity(false);
                    //mail.setUseSignature(false);
                    //mail.setReplyTo(UserEmail.email);
                    //mail.setToAddresses(toAddresses);
                    //mail.setSenderDisplayName('Order Verfication');                    
                    //EmailTemplate et=[Select id from EmailTemplate where DeveloperName=:'New_Sales_Order_Created'];
                    //mail.setTemplateId(et.id);
                    //Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                    //system.debug('Email sent');
                    
                }catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                    system.debug(e);
                    System.debug('Exception => '+ e.getMessage() + ' : Line Number => '+ e.getLineNumber());
                    return e.getMessage();
                } 
            }
           
        }
        else
        {
            return 'Stage must be Approved';
        }
        return '';
    }    
}