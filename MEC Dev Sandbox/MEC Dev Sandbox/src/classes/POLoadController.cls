public class POLoadController {
    
    public List<POMapping> poMappingList {get; set;}
    public List<Account> accountList {get; set;}
    public Account acct {get; set;}
    public Map<String,Account> accountMap {get; set;} 
    public Map<id,String> accountNames {get; set;}
    public List<Product2> productList {get; set;}
    public Map<String,Product2> products {get; set;}
    public boolean success {get; set;}
    
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    
    public Contact tmpContact{get;set;}
    public TmpObject__c tmpObject{get;set;} 
    public Document extraFile{get;set;} 
    public Document virginFile{get;set;} 
    
    public POLoadController(){
        success = true;
        csvFileLines = new String[]{};
        List<Document> documents = [select id, name, body from Document where name = 'Virgin File' or name = 'Extra File'];
        if(documents.size()==2){
            if(documents[0].name=='Virgin File'){
               virginFile = documents[0]; 
               extraFile = documents[1]; 
            } else {
               virginFile = documents[1]; 
               extraFile = documents[0]; 
            }
        }

        //accountList = [select id,name from Account where ParentId=null limit 1000]; 
        
        //productList = [select id,name,article__c from Product2]; 
        accountNames = new Map<id,String>();
        accountMap = new Map<String,Account>();
        products = new Map<String,Product2>();
        /*
        for(integer i=0;i<accountList.size();i++)
          accountNames.put(accountList[i].id, accountList[i].name);  
        */  
        acct = new Account();
        tmpContact = new Contact();
        tmpObject = new TmpObject__c();
    }
    
    /*   
    public list<SelectOption> AccList {
        get{
            list<SelectOption> st= new list<SelectOption>();
            
            for( Account acc : accountList)
            {
                st.add(new SelectOption(acc.id, acc.name));
            }
            return st;
        }
        set; }
    */    
    
    public list<SelectOption> prodList {
        get{
            list<SelectOption> st= new list<SelectOption>();
            acct = [select id, Price_Book__c from Account where id=:acct.id];
            List<PriceBookEntry> pbe= [select product2Id,product2.name from PriceBookEntry where Pricebook2Id=:acct.Price_Book__c]; 

            for(PriceBookEntry pro : pbe)
            {
                st.add(new SelectOption(pro.product2Id, pro.product2.name));
            }
            return st;
        }
        set; }
    
    public pageReference importCSVFile(){
        try{    
            poMappingList = new List<POMapping>();
            //acct = (Account)contact.accountId;
            if(tmpContact.accountId!=null){
                acct = [select id, name from Account where id=:tmpContact.accountId];    
                accountNames.put(acct.id, acct.name);
                // Extra file Mapping
                if(tmpContact.accountId!=null && acct.name.contains('Extra'))
                {
                    parseExtraFile();
                }
                
                // Sony file Mapping
                if(tmpContact.accountId!=null && (acct.name.contains('VIRGIN') || acct.name.contains('Virgin')))
                {
                    parseVirginFile();
                }
                    
            }
        }
        catch (Exception e)
        {
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }
        
        return null;  
    }
    
    public pageReference parseExtraFile(){
        try{    
            poMappingList = new List<POMapping>();           
            accountNames.put(acct.id, acct.name);
            // Extra file Mapping
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n'); 
            
            String[] header = csvFileLines[0].split(',');
            List<String> accNames = new List<String>();
            for(integer j=2;j<header.size();j++){
                accNames.add(header[j].trim());
            }
            List<Account> accounts = [Select id, name from Account where name in :accNames and ParentId = :acct.id ];
            for(integer j=0;j<accounts.size();j++)
                accountMap.put(accounts[j].name,accounts[j]);
          
            List<String> proNames = new List<String>();        
            for(Integer i=1;i<csvFileLines.size();i++){
                String[] csvRecordData = csvFileLines[i].split(',');    
                proNames.add(csvRecordData[0].trim());
            }
            List<Product_Mapping__c> tmp = [select id, Product__r.id,Product__r.name,Product__r.productCode,Product__r.Article__c,code__c from Product_Mapping__c where code__c in :proNames];
            for(Integer i=0;i<tmp.size();i++){
                Product2 prod = new Product2();
                prod.id=tmp[i].Product__r.id;
                prod.name=tmp[i].Product__r.name;
                prod.productCode=tmp[i].Product__r.Article__c;
                products.put(tmp[i].code__c, prod);
            }
            
            for(Integer i=1;i<csvFileLines.size();i++){
                String[] csvRecordData = csvFileLines[i].split(',');
                System.debug('Line length-->'+ csvRecordData.size());
                for(Integer j=2;j<csvRecordData.size();j++){
                    if(header[j]==null || header[j].trim().equals(''))break;
                    if(csvRecordData[j]==null || csvRecordData[j].trim().equals(''))break;
                    
                                        
                    POMapping mapping = new POMapping();
                    Account accObj = null;
                    if(accountMap.get(header[j].trim())!=null)                                              
                        accObj = accountMap.get(header[j].trim());
                    else{
                            mapping.notes ='Store not found!';
                    }    
                    /*    
                    else{
                        List<Account> acc = [Select id, name from Account where name=:header[j].trim() and ParentId = :acct.id limit 1];
                        if(acc.size()>0){
                            accObj = acc[0];
                            accountMap.put(acc[0].name,acc[0]);
                        }
                    }    
                    */
                    
                    Product2 prod = null;
                    if(products.get(csvRecordData[0])!=null){
                        prod = products.get(csvRecordData[0]);
                        mapping.prod = prod;
                        mapping.match = true;
                    }
                    else{
                            mapping.match = false;
                        }
                    /*
                    else {
                        List<Product_Mapping__c> tmp = [select id, Product__r.id,Product__r.name,Product__r.productCode,Product__r.Article__c from Product_Mapping__c where code__c = :csvRecordData[0].trim() limit 1];
                        if(tmp.size()>0){
                            prod = new Product2();
                            prod.id=tmp[0].Product__r.id;
                            prod.name=tmp[0].Product__r.name;
                            prod.productCode=tmp[0].Product__r.Article__c;
                            products.put(csvRecordData[0], prod);
                            mapping.prod = prod;
                            mapping.match = true;
                        }
                        
                    }*/
                    
                    mapping.clientCode = csvRecordData[0];
                    if(csvRecordData[j].trim()!=null && !csvRecordData[j].trim().equals(''))
                        mapping.numberOfItems = integer.valueof(csvRecordData[j].trim()); 
                    else      
                        mapping.numberOfItems = 0;
                    
                    mapping.acct = accObj;
                    poMappingList.add(mapping);
                }
            }
        }
        catch (Exception e)
        {
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }
        
        return null;  
    }
    
    
    public pageReference parseVirginFile(){
        try{    
            poMappingList = new List<POMapping>();           
            accountNames.put(acct.id, acct.name);
            // Extra file Mapping
            csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n'); 
            
            for(Integer i=1;i<csvFileLines.size();i++){
                String[] csvRecordData = csvFileLines[i].split(',');
                if(csvRecordData.size()<14)continue;                        
                POMapping mapping = new POMapping();
                Account accObj = null;
                if(accountMap.get(csvRecordData[1].trim())!=null)                                              
                    accObj = accountMap.get(csvRecordData[1].trim());
                else{
                    List<Account> acc = [Select id, name from Account where name=:csvRecordData[1].trim() and ParentId = :acct.id limit 1];
                    if(acc.size()>0){
                        accObj = acc[0];
                        accountMap.put(acc[0].name,acc[0]);
                    }else{
                        mapping.notes ='Store not found!';
                    }
                }    
                
                Product2 prod = null;
                if(products.get(csvRecordData[2])!=null){
                    prod = products.get(csvRecordData[2]);
                    mapping.prod = prod;
                    mapping.match = true;
                }else {
                    List<Product_Mapping__c> tmp = [select id, Product__r.id,Product__r.name,Product__r.productCode,Product__r.Article__c from Product_Mapping__c where code__c = :csvRecordData[2].trim() limit 1];
                    if(tmp.size()>0){
                        prod = new Product2();
                        prod.id=tmp[0].Product__r.id;
                        prod.name=tmp[0].Product__r.name;
                        prod.productCode=tmp[0].Product__r.Article__c;
                        products.put(csvRecordData[0], prod);
                        mapping.prod = prod;
                        mapping.match = true;
                    }else{
                        mapping.match = false;
                    }
                }
                
                mapping.clientCode = csvRecordData[2];
                mapping.numberOfItems = integer.valueof(csvRecordData[13].trim());   
                
                mapping.acct = accObj;
                poMappingList.add(mapping);
                
            }
        }
        catch (Exception e)
        {
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }
        
        return null;  
         
    }
    
    
    public pageReference upload(){
        Opportunity op = null;
        try{
            List<Product_Mapping__c> mappingList = new List<Product_Mapping__c>();
            //List<Opportunity> oppList = new List<Opportunity>();
            List<OpportunityLineItem> oppProductList = new List<OpportunityLineItem>();
            Map<id,PricebookEntry> priceBookList = new Map<id,PricebookEntry>();
            
            RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opportunity' and Name='PO' LIMIT 1];
            Pricebook2 stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
                        
            /*
            Map<id, List<POMapping>> groupPO = new Map<id, List<POMapping>>();
            for(POMapping po : poMappingList){
                if(groupPO.get(po.acct.id)==null){
                    List<POMapping> listStore = new List<POMapping>();
                    listStore.add(po);
                    groupPO.put(po.acct.id,listStore);
                }else{
                    groupPO.get(po.acct.id).add(po);
                }
            }
            */
                // RFPO attached to PO
                
                if(tmpObject.opportunity__C==null)
                {
                    op = new Opportunity();
                    
                    op.recordTypeId = rt.id;
                    op.accountId = acct.id;
                    
                    op.name='OP';
                    op.StageName='Proposal';
                    op.CloseDate = system.today().addMonths(1);

                    op.From_Upload__c = true;
                    insert(op);
                        
                    op = [select id,Pricebook2Id from opportunity where id=:op.id limit 1];
                    List<PricebookEntry> pb = new list<PricebookEntry>();
                    if(op.Pricebook2Id!=null){
                        pb = [Select Product2Id,id,UnitPrice from PricebookEntry WHERE pricebook2id= :op.Pricebook2Id];
                    } 
    
                    integer count = 0;
                    for(POMapping po : poMappingList){
                        OpportunityLineItem lineItem = new OpportunityLineItem();
                        lineItem.OpportunityId = op.id;
                        lineItem.Outlet__c = po.acct.id;
                        lineItem.Quantity = po.numberOfItems;
                        
                        if(po.prod==null){
                            Product_Mapping__c proMap = new Product_Mapping__c();
                            proMap.code__c = po.clientCode;
                            proMap.Product__c = po.tmpObj.product__c;
                            lineItem.Product_Id__c = po.tmpObj.product__c;
                            
                            mappingList.add(proMap);
                        } else
                            lineItem.Product_Id__c = po.prod.id;
                        
                        double price=1;
                        boolean found=false;
                        for(integer i=0;i<pb.size();i++){
                            if(pb[i].Product2Id==lineItem.Product_Id__c){
                                system.debug('Found price book!!');
                                lineItem.pricebookentryId = pb[i].id;
                                price = pb[i].unitPrice;
                                found = true;
                            }
                        }
                        
                        if(!found){
                            List<PricebookEntry> pbEntry = [Select id,unitPrice from PricebookEntry WHERE pricebook2id= :stdPb.id and product2id= :lineItem.Product_Id__c limit 1];
                                if(pbEntry.size()>0){
                                    lineItem.PricebookEntryId = pbEntry[0].id;
                                    price = pbEntry[0].unitPrice;
                                }else{
                                    PricebookEntry pbe = new PricebookEntry(pricebook2id=stdPb.id, 
                                        product2id=lineItem.Product_Id__c,unitprice=1.0, isActive=true,UseStandardPrice=false);
                                    priceBookList.put(lineItem.Product_Id__c,pbe);
                            }
                       }
                        
                        /*
                        else{
                                List<PricebookEntry> pbEntry = [Select id,unitPrice from PricebookEntry WHERE pricebook2id= :stdPb.id and product2id= :lineItem.Product_Id__c];
                                if(pbEntry.size()>0){
                                    lineItem.PricebookEntryId = pbEntry[0].id;
                                    price = pbEntry[0].unitPrice;
                                }
                            }
                        */
                        
                        lineItem.TotalPrice = price * po.numberOfItems;
                        
                        
                        /*
                        else{
                            List<PricebookEntry> pb = [Select id from PricebookEntry WHERE pricebook2id= :stdPb.id and product2id= :lineItem.Product_Id__c];
                            if(pb.size()>0){
                                lineItem.PricebookEntryId = pb[0].id;
                            }
                            else{
                                PricebookEntry pbe = new PricebookEntry(pricebook2id=stdPb.id, 
                                    product2id=lineItem.Product_Id__c,unitprice=1.0, isActive=true,UseStandardPrice=false);
                                priceBookList.put(lineItem.Product_Id__c,pbe);
                            }
                        }
                        */
                        
                        oppProductList.add(lineItem); 
                        
                        count+=po.numberOfItems;
                    }
                    op.TotalOpportunityQuantity = count;
                    update(op);
                } else {  // Case of existing RFPO
                    op = [select id from opportunity where id=:tmpObject.Opportunity__c];               
                    op.recordTypeId = rt.id;
                    List<OpportunityLineItem> lineItemList = [Select id, Outlet__c, Product2Id, PO_Qty__c ,Quantity from OpportunityLineItem where OpportunityId = :tmpObject.Opportunity__c];
                    for(OpportunityLineItem item : lineItemList){
                        for(POMapping po : poMappingList){
                            if(item.Outlet__c == po.acct.id && item.Product2Id==po.prod.id){
                                item.PO_Qty__c = po.numberOfItems;
                                item.Quantity = po.numberOfItems;
                            }
                        }    
                    }
                    update lineItemList;
                    update op;
                }
                
            Attachment attach = new Attachment();
            attach.Body = csvFileBody;
            attach.Name = 'PO file.csv';
            attach.IsPrivate = false;
            attach.ParentId = op.id;
            insert attach;    
            
            insert(mappingList);
            upsert(priceBookList.values());
            
            
            for(integer i=0;i<oppProductList.size();i++){
                if(oppProductList[i].PricebookEntryId==null)
                    oppProductList[i].PricebookEntryId = priceBookList.get(oppProductList[i].Product_Id__c ).id;
            }
            
            
            insert(oppProductList);
            
            ApexPages.Message successMessage = new ApexPages.Message(ApexPages.severity.CONFIRM,'File uploaded successfully!');
            ApexPages.addMessage(successMessage);
        }
        catch (Exception e)
        {
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
            return null;
        }
        success = false;
        return new PageReference('/'+op.id);
    }
    
}