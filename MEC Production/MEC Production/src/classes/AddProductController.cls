public class AddProductController {
    
    public String Classification{get;set;}
    public Account RelatedAccount{get;set;}
    public Account Store{get;set;}
    public Contact RelatedContact{get;set;}
    Opportunity RelatedOpp{get;set;}
    Public List<Account> AccountList {get;set;}
    Map<Id, List<Wrapper>> DisplayMap{get;set;}
    Map<Id, List<SearchWrapper>> DisplaySearchMap{get;set;}
    Map<Id, Sell_Out__c> sellOut {get;set;}
    Map<Id, Stock__c> stockMap {get;set;}
    public boolean returnToOpp{get;set;} 
    public boolean trueBool {get;set;} 
    
    Public List<Wrapper> SearchResult{get;set;}
    Public List<Wrapper> AllSearchResult{get;set;}
    Public List<SearchWrapper> AllSearchCriteria{get;set;}
    Public List<SearchWrapper> SearchCriteria{get;set;}
    public Boolean AddDisabled {get;set;}
    //heree
    public Boolean PrevDisabled {get;set;}
    public Boolean NextDisabled {get;set;}
    public Account CurrentAccount {get;set;}
    Integer Index{get;set;}
    List<Account> ChildrenAccountList {get;set;}
    
    
    
    public Boolean SearchDisabled {get;set;}
    Account ParentAccount {get;set;}
    Map<Id, PricebookEntry> CreatedpbeMap{get;set;}
    
    Pricebook2 stdPb{get;set;}    
    Private Boolean flag{get;set;}
    Private Boolean anotherFlag{get;set;}
    
    //for pagination
    private integer Counter;  //keeps track of the offset
    private integer List_size; //sets the page size or number of rows
    public integer Total_size;
    
    
    //Public OpportunityLineItem OLI;
    public AddProductController(ApexPages.standardController std) {
        // heree List_size = 100;
        List_size = 100;
        counter = 0;
        trueBool = true;
        RelatedOpp = (Opportunity)std.getRecord();
        SearchResult = new List<Wrapper>();
        AllSearchResult = new List<Wrapper>();
        DisplayMap = new Map<Id, List<Wrapper>>();
        DisplaySearchMap = new Map<Id, List<SearchWrapper>>();
        SearchCriteria = new List<SearchWrapper>();
        AllSearchCriteria = new List<SearchWrapper>();
        ParentAccount = new Account();
        CreatedpbeMap = new Map<Id, PricebookEntry>();
        //RelatedOpp = [Select name, AccountId, Contact__c From Opportunity Where Id =: RelatedOpp.id];
        RelatedAccount  = [Select name, Category__c, ParentId, Price_Book__c, Parent.Price_Book__c, Site__c From Account Where Id =: RelatedOpp.AccountId ];
        Store = RelatedAccount;
        if(RelatedOpp.Contact__c != null) 
            RelatedContact =  [Select name From Contact Where Id =: RelatedOpp.Contact__c ];
        
        AccountList = new list<Account>();    
        AccountList.add(RelatedAccount);
        
        //AccountList.add(RelatedAccount);
        ChildrenAccountList = [Select Id, name, Price_Book__c, ParentId, Parent.Price_Book__c From Account Where ParentId =: RelatedAccount.Id];
        //ChildrenAccountList = [Select Id,name From Account Where ParentId =: RelatedAccount.Id];
        if(ChildrenAccountList.isEmpty() == False)
            AccountList.addAll(ChildrenAccountList);
        
        CurrentAccount = RelatedAccount;   
        getSearchCriteria(); 
        AddDisabled = true;
        NextDisabled = AccountList.size()>1?false:true;
        PrevDisabled = True;
        Index = 0;
        
        SearchDisabled = True;
        stdPb = new Pricebook2();
        
        sellOut = new Map<Id, Sell_Out__c>();
        stockMap = new Map<Id, Stock__c>();
        
        flag =True;
        anotherFlag = True;
    }
    
    public Class Wrapper{
        public Boolean isSelected {get;set;}
        Public Product2 Prod {get;set;}
        public Account Acc {get;set;}
        public OpportunityLineItem opLineItem {get;set;}
        public Sell_Out__c sellOut {get;set;} 
        public Stock__c stock {get;set;} 
        Public Opportunity opp{get;set;}
        Public PricebookEntry PBE{get;set;}
        
        Public Wrapper(Boolean isSelected, Account Acc, Product2 Prod,Sell_Out__c sellOut,Stock__c stock,OpportunityLineItem opLineItem, Opportunity opp, PricebookEntry PBE){
            this.isSelected = isSelected;
            this.Acc = Acc;
            this.Prod = Prod;
            this.sellOut = sellOut;
            this.stock = stock;
            this.opLineItem = opLineItem ;
            this.opp = opp;
            this.PBE = PBE;
            if((opLineItem.RFPO_Qty__c ==null || opLineItem.RFPO_Qty__c ==0) && opp.RecordType.DeveloperName == 'RFPO'){
                if(sellout!=null)
                    opLineItem.Recommended_RFPO__c = (sellout.Sell_Out__c - sellout.Stock_on_Hand__c);
                else
                    opLineItem.Recommended_RFPO__c = 0;
                if(opLineItem.Recommended_RFPO__c!=null && opLineItem.Recommended_RFPO__c>0)    
                    opLineItem.RFPO_Qty__c = opLineItem.Recommended_RFPO__c;
                if(opLineItem.Recommended_RFPO__c<0)
                    opLineItem.Recommended_RFPO__c = 0;
            }
        }
    }
    
    @TestVisible
    public Class SearchWrapper{
        public Boolean isSelected {get;set;}
        public String Category {get;set;}
        public String Classification {get;set;}
        Public Id AccId {get;set;}
        Public SearchWrapper(Boolean isSelected, String Category, String Classification, Id AccId){
            this.isSelected = isSelected;
            this.Category = Category;
            this.Classification = Classification;
            this.AccId = AccId;
        }
    }
    
    //Pagination
    //start heree
    public void Beginning() 
    {   
        //user clicked beginning
        Counter = 0;
        doSearch();
    }
    public void Previous() 
    {   
        //user clicked previous button
        Counter -= List_size;
        doSearch();
    }
    public void Next() 
    {   
        //user clicked next button
        Counter += List_size;
        doSearch();
    }
    
    public void End() 
    {   
        //user clicked end
        Counter = Total_size - math.mod(Total_size, List_size);
        if(Counter == Total_size && Total_size != 0)
            Counter = Total_size - List_size; 
        doSearch();
    }
    
    public Boolean getDisablePrevious() 
    { 
        //this will disable the previous and beginning buttons
        if (Counter > 0) 
            return false; 
        else 
            return true;
    }
    public Boolean getDisableNext() 
    {
        //this will disable the next and end buttons
        if (Counter + List_size < Total_size) 
            return false; 
        else 
            return true;
    }
    //end heree
    
    Public Void getSearchCriteria(){
        //AccountList = new List<Account>();
        //List<Account> ChildrenAccountList = new List<Account>();
        List<Id> AccountSIdS = new List<Id>();
        //select the current account + its children if any exist
        //if the account parent field filled, then it is a child
        
        /*
        AccountList = new list<Account>();    
        AccountList.add(RelatedAccount);
        
        //AccountList.add(RelatedAccount);
        ChildrenAccountList = [Select Id,name From Account Where ParentId =: RelatedAccount.Id];
        if(ChildrenAccountList.isEmpty() == False)
            AccountList.addAll(ChildrenAccountList);
        */
        
        for(Account A : AccountList){
            AccountSIdS.add(A.Id);
        }
        System.debug('Size Account:'+AccountList.size());
        
        List<Customer_Category_Classfication__c> CustomerCategoryClassficationS = new List<Customer_Category_Classfication__c>();
        if(RelatedContact!=null && RelatedContact.id!=null)
            CustomerCategoryClassficationS = [Select Id, Account__c, Classification_Level__c, Product_Category__c From Customer_Category_Classfication__c Where Account__c IN: AccountSIdS and contact__c = :RelatedContact.id];
        else{    
            CustomerCategoryClassficationS = [Select Id, Account__c, Classification_Level__c, Product_Category__c From Customer_Category_Classfication__c Where Account__c IN: AccountSIdS];
            
        }
        
        //fill AllSearchCriteria wrapper
        AllSearchCriteria = new List<SearchWrapper>();
        for(Customer_Category_Classfication__c ccc: CustomerCategoryClassficationS){
            AllSearchCriteria.add(new SearchWrapper(True, ccc.Product_Category__c, ccc.Classification_Level__c, ccc.Account__c));
        }
        
        //devide AllSearchResult into seperate lists, one for each Account
        List<SearchWrapper> temp = new List<SearchWrapper>();
        for(Account Acc1: AccountList){
            temp = new List<SearchWrapper>();
            for(SearchWrapper w: AllSearchCriteria){
                if(w.AccId == Acc1.Id){
                    temp.add(w);
                }
            }
            System.debug('Account name: '+Acc1.name+' temp.size():'+temp.size());
            DisplaySearchMap.Put(Acc1.Id, temp);
        }
        
        system.debug('DisplaySearchMap' + DisplaySearchMap.size());
        
        SearchCriteria = DisplaySearchMap.get(currentAccount.Id);
    }
    
    Public void SetAddDisabled(){
        for(Wrapper R: SearchResult){
            if(R.isSelected == True){
                AddDisabled = False;
                break;
            }else{
                AddDisabled = True;
            }
        }
    }
    Public void SetSearchDisabled(){
        for(SearchWrapper R: SearchCriteria){
            if(R.isSelected == True){
                SearchDisabled = False;
                break;
            }else{
                SearchDisabled = True;
            }
        }
    }
    
    Public void SetPrevDisabled(){
        for(Wrapper R: SearchResult){
            if(R.isSelected == True){
                AddDisabled = False;
                break;
            }else{
                AddDisabled = True;
            }
        }
    }
    
    
    Public Void doSearch(){
        try{
            List<OpportunityLineItem> ExistingOpportunityLineItemS = [Select OpportunityID, Product2ID ,Outlet__c,RFPO_Qty__c,PO_Qty__c,Remarks__c,Recommended_RFPO__c,Quantity,UnitPrice,PricebookEntryId  From OpportunityLineItem Where OpportunityID=: RelatedOpp.Id];
            DisplayMap = new Map<Id, List<Wrapper>>();
            //AccountList = new List<Account>();
            //List<Account> ChildrenAccountList = new List<Account>();
            //List<Product2> ProductList = new List<Product2>();
            Map<Id, Product2> ProductListToBedisplayed = new Map<Id, Product2>();
            //select the current account + its children if any exist
            //if the account parent field filled, then it is a child
            /*
            if(RelatedAccount.ParentId != Null){
                AccountList.add(RelatedAccount);
                ParentAccount = [Select Id, name, Price_Book__c, Parent.Price_Book__c From Account Where Id =: RelatedAccount.ParentId];
            }else{
                //the account is not a child, search if it has children
                AccountList.add(RelatedAccount);
                ChildrenAccountList = [Select Id, name, Price_Book__c, ParentId, Parent.Price_Book__c From Account Where ParentId =: RelatedAccount.Id];
                if(ChildrenAccountList.isEmpty() == False)
                    AccountList.addAll(ChildrenAccountList);
            }
            */
            
            List<Id> AccountPricebookEntryIdS = new List<Id>();
            for(Account A: AccountList){
                AccountPricebookEntryIdS.add(A.Price_Book__c);
            }
            
            Set<String> cats = new Set<String>();
            for(SearchWrapper SW: SearchCriteria){
                cats.add(SW.Category);
            }
            
            List<PricebookEntry> AccountPricebookEntry = [Select Product2Id,UnitPrice,Classification_Level__c From PricebookEntry Where pricebook2id IN: AccountPricebookEntryIdS and product2.Product_Hierarchy2__r.Category__c in :cats];
            List<Id> ProductSIdS = new List<Id>();
            for(PricebookEntry PEI :AccountPricebookEntry){
                ProductSIdS.add(PEI.Product2Id);
            }
            
            
            system.debug('Cats:'+cats);
            
            List<SearchWrapper> SelectedSearchCriteria = new List<SearchWrapper>(); 
            
            for(SearchWrapper SW: SearchCriteria){
                if(SW.isSelected == True){  
                    SelectedSearchCriteria.add(SW);
                }}
            
            //String tempStr = NUll;
            String FullString = NUll;
            //if(SelectedSearchCriteria.size() == 1){
            //     FullString  = 'AND( Classification_Level__c >= \'' + SelectedSearchCriteria[0].Classification + ' AND Product__r.Product_Hierarchy2__r.Category__c '+ SelectedSearchCriteria[0].Category+ ')\'';    
            //}else{
                for(SearchWrapper SW: SelectedSearchCriteria){
                    //tempStr = '';
                    if(FullString == Null){
                        FullString  = ' AND (( Classification_Level__c >= \'' + SW.Classification + '\' AND Product__r.Product_Hierarchy2__r.Category__c =\''+ SW.Category+ '\')';    
                    }else{
                        FullString  += ' OR ( Classification_Level__c >= \'' + SW.Classification + '\' AND Product__r.Product_Hierarchy2__r.Category__c =\''+ SW.Category+ '\')';    
                    }
                    //FullString += tempStr;
                }
                if(FullString != Null)
                    FullString +=' ) ';
                system.debug('FullString' + FullString);
                
            //}
            
            
            String queryStr = 'Select Classification_Level__c, Product__c From Product_Classification__c Where Product__c IN :ProductSIdS '+ FullString +' LIMIT :List_size OFFSET :Counter';
            List<Product_Classification__c> ProductClassificationS =  database.query(queryStr); 
            String countQueryStr = 'Select COUNT() From Product_Classification__c Where Product__c IN: ProductSIdS ' +FullString; 
            Total_size = database.countQuery(countQueryStr);
            
            Set<Id> ProductListToBedisplayedIdS = new Set<Id>();
            //fill ProductListToBedisplayed 
            //Product2 Pro = new Product2();
            for(Product_Classification__c pc: ProductClassificationS){
                /*    pro = new Product2();
pro.Id = pc.Product__c;
pro.name = pc.Product__r.name;
pro.Manufacturing_Type__c = p;c.Product__r.Manufacturing_Type__c;
pro.Product_Category__c = pc.Product__r.Product_Category__c;
pro.Merchandise_Category__c = pc.Product__r.Merchandise_Category__c;
pro.Product_Hierarchy2__c  = pc.Product__r.Product_Hie;2rarchy2__c;
pro.Item_Status_Description__c = pc.Product__r.Item_Status_Description__c;
pro.Item_Status__c = PC.Product__r.Item_Status__c;
pro.Latest_Stock__c = PC.Product__r.Latest_Stock__c;
ProductListToBedisplayed.put(pro.Id, pro);*/
                ProductListToBedisplayedIdS.add(pc.Product__c);
            }
            ProductListToBedisplayed =  new Map<Id, Product2>([Select name, Manufacturing_Type__c,Product_Category__c,Merchandise_Category__c,Product_Hierarchy2__r.Category__c,Item_Status_Description__c,Item_Status__c,
                                                               Latest_Stock__c From Product2 Where Id IN: ProductListToBedisplayedIdS]);
            
            
            /*ProductList = [Select name, Manufacturing_Type__c,Product_Category__c,Merchandise_Category__c,Product_Hierarchy2__r.Category__c,Item_Status_Description__c,Item_Status__c,
Latest_Stock__c From Product2 Where Id IN: ProductSIdS and Product_Hierarchy2__r.Category__c IN: cats LIMIT :List_size OFFSET :Counter];*/
            system.debug('Total_size ' + Total_size);
            system.debug('Counter ' + Counter);
            system.debug('List_size ' + List_size);
            System.debug('Product list size:'+ProductListToBedisplayed.size());
            
            
            //set ProductListToBedisplayed
            /*for(SearchWrapper SW: SearchCriteria){
if(SW.isSelected == True){
for(Product2 prod : ProductList){
for(Product_Classification__c PC : ProductClassificationS){
if(prod.Id == PC.Product__c && SW.Classification <= PC.Classification_Level__c && SW.Category == Prod.Product_Hierarchy2__r.Category__c){
ProductListToBedisplayed.put(prod.Id, prod); 
}
}
}}}*/
            
            
            //fill the wrapper
            //Boolean Existing = False;
            Set<Id> ProductIds = new Set<Id>();
            for(Product2 prod : ProductListToBedisplayed.values()){
                ProductIds.add(Prod.Id);
            }
            Account TheParentAcc = New Account(); 
            if(RelatedAccount.ParentId == Null){
                TheParentAcc = RelatedAccount;
            }else{
                TheParentAcc = ParentAccount;
            }
            
            
            //List<PricebookEntry> pbList =  [Select id, pricebook2id, Product2Id, UnitPrice,Classification_Level__c from PricebookEntry WHERE pricebook2id IN: AccountPricebookEntryIdS AND Product2Id IN: ProductIds];
            List<PricebookEntry> pbList =  [Select id, pricebook2id, Product2Id, UnitPrice,Classification_Level__c from PricebookEntry WHERE pricebook2id =: TheParentAcc.Price_Book__c AND Product2Id IN: ProductIds];
            PricebookEntry ParentPb = new PricebookEntry();
            Boolean PBEFoundFlag = False;
            
            /*        if(RelatedAccount.ParentId == Null){
for(PricebookEntry p1: pbList){
if(p1.pricebook2id == RelatedAccount.Price_Book__c){
ParentPb = p1;
break;
}
}}else if(ParentAccount.Id != Null){
for(PricebookEntry p1: pbList){
if(p1.pricebook2id == ParentAccount.Price_Book__c){
ParentPb = p1;
break;
}}

}*/
            
            
            
            system.debug('ProductListToBedisplayed.values()' +ProductListToBedisplayed.values());
            AllSearchResult = new List<Wrapper>();
            
            
            for(Account Acc: AccountList){
                for(Product2 P: ProductListToBedisplayed.values()){
                    PBEFoundFlag = False;
                    //SelectedPb = new PricebookEntry();
                    
                    
                    //check if the row is already added as OpportunityLineItem
                    OpportunityLineItem lineItem = new OpportunityLineItem();
                    for(OpportunityLineItem o :ExistingOpportunityLineItemS){
                        if(o.Product2ID == p.Id && o.Outlet__c == Acc.Id){
                            lineItem = o;
                            break;
                        }
                    }
                    
                    if(sellOut.get(p.id)==null){
                        List<Sell_Out__c> sellList = [select id,Weighted_Sell_Out__c,Stock_on_Hand__c,Sell_Out__c from Sell_Out__c where product__c = :p.id order by year__c, week__c desc limit 1];
                        if(sellList.size()>0){
                            sellOut.put(p.id,sellList[0]);
                        }
                    } 
                    
                    if(stockMap.get(p.id)==null){
                        List<Stock__c> stockList = [select id,Val_in_Trans_Tfr__c from Stock__c where Site__c = :RelatedAccount.Site__c and article__c = :p.id limit 1];
                        if(stockList.size()>0){
                            stockMap.put(p.id,stockList[0]);
                        }
                    }
                    //for el list, get same acc and p
                    for(PricebookEntry SelectedPb: pbList){
                        if(SelectedPb.Product2Id == p.Id){
                            PBEFoundFlag = True;
                            if(lineItem.PricebookEntryId == Null) lineItem.PricebookEntryId = SelectedPb.Id;
                            if(lineItem.UnitPrice == Null) lineItem.UnitPrice = SelectedPb.UnitPrice;
                            AllSearchResult.add(new Wrapper(True, Acc, p,sellOut.get(p.id),stockMap.get(p.id),lineItem, RelatedOpp, SelectedPb));
                            break;
                        }
                    }
                    if(PBEFoundFlag == False){
                        //add wz the parent account one, leave as null
                        PricebookEntry EmptyPb = new PricebookEntry();
                        AllSearchResult.add(new Wrapper(True, Acc, p,sellOut.get(p.id),stockMap.get(p.id),lineItem, RelatedOpp, EmptyPb));
                    }
                }
            }
            
            //devide AllSearchResult into seperate lists, one for each Account
            List<Wrapper> temp = new List<Wrapper>();
            for(Account Acc1: AccountList){
                temp = new List<Wrapper>();
                for(Wrapper w: AllSearchResult){
                    if(w.Acc.Id == Acc1.Id){
                        temp.add(w);
                    }}
                DisplayMap.Put(Acc1.Id, temp);
            }
            
            if (anotherFlag == True){
                Index = 1;
                SearchResult = DisplayMap.get(currentAccount.Id);
                if(AccountList.size() > 1){
                    NextDisabled = False;
                    PrevDisabled = true;}
                
            }
        }catch (Exception e)
        {
            System.debug(e.getLineNumber());
            System.debug(e.getMessage());
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }
        //CurrentAccount = new Account();
        
        
        
        //if (flag == true) getNextAccount();
        //getNextAccount();
    }
    
    Public Void getNextAccount(){
        //heree List_size = 100;
        counter = 0;
        anotherFlag = False;
        SearchCriteria = new List<SearchWrapper>();
        SearchResult = new List<Wrapper>();
        List<Wrapper> temp = new List<Wrapper>();
        List<SearchWrapper> Srchtemp = new List<SearchWrapper>();
        if(Index ==1 ) 
            PrevDisabled = False;
        
        for(Integer i=0 ; i<AccountList.size(); i++){
            if(AccountList[i].Id == CurrentAccount.Id){
                if(i>-1) PrevDisabled = False;
                if(i+1 < AccountList.size()-1){
                    Index = i+1;
                    NextDisabled = False;
                    break;
                }else if(i+1 == AccountList.size()-1){
                    Index = i+1;
                    //setNext Disabled
                    NextDisabled = True;
                    PrevDisabled = False;
                    break;
                }
            }
        }
        
        CurrentAccount = AccountList[Index];
        Store = AccountList[Index];
        
        if(CurrentAccount.Id != NUll) 
            Srchtemp = DisplaySearchMap.get(CurrentAccount.Id);
        if(Srchtemp.size() > 0){ 
            SearchCriteria.addAll(Srchtemp);
            
        }
        doSearch();
        
        
        if(CurrentAccount.Id != NUll) 
            temp = DisplayMap.get(CurrentAccount.Id);
        
        if(temp!=null && temp.size() >0){ 
            SearchResult.addAll(temp);
        }else{
            SearchResult = new List<Wrapper>();
        }
        
    }
    
    Public void getPrevAccount(){
        //heree List_size = 100;
        counter = 0;
        SearchCriteria = new List<SearchWrapper>();
        SearchResult = new List<Wrapper>();
        List<Wrapper> temp = new List<Wrapper>();
        List<SearchWrapper> Srchtemp = new List<SearchWrapper>();
        for(Integer i=0 ; i<AccountList.size(); i++){
            if(AccountList[i].Id == CurrentAccount.Id){
                if(i<AccountList.size())NextDisabled = False;
                if(i-1 > 0){
                    Index = i-1;
                    PrevDisabled = False;
                    break;
                }else if(i-1 == 0){
                    Index = i-1;
                    //set previous Disabled
                    PrevDisabled = True;
                    NextDisabled = False;
                    break;
                }
            }
        }
        CurrentAccount = AccountList[Index];
        Store = AccountList[Index];
        
        system.debug('Index: '+Index+' Current Account: '+CurrentAccount.id);
        
        if(CurrentAccount.Id != NUll) Srchtemp = DisplaySearchMap.get(CurrentAccount.Id);
        system.debug('Srchtemp :' +Srchtemp.size());
        if(Srchtemp.size() > 0){ 
            SearchCriteria.addAll(Srchtemp);
            
        }
        
        doSearch();
        
        if(CurrentAccount.Id != NUll)
            temp = DisplayMap.get(CurrentAccount.Id);
        
        if(temp!=null && temp.size() >0){
            SearchResult.addAll(temp);
        }else{
            SearchResult = new List<Wrapper>();
        }
        
    }
    
    Public PageReference AddOppLineItemsReturn(){
        AddOppLineItems();
        return new PageReference('/'+RelatedOpp.id);
    }
    
    Public PageReference AddOppLineItems(){
        //create Opportunity Product Fields
        List<OpportunityLineItem> OppLineItemToBeAdded = new List<OpportunityLineItem>();
        OpportunityLineItem NewOppLineItem = new OpportunityLineItem();
        Set<Id> AccountSPriceBookIds= new Set<Id>();
        Set<Id> ProductIds = new Set<Id>();
        Set<Id> AccountIds = new Set<Id>();
        //get SearchResult Acc.Price_Book__c and Prod.Id
        for(Wrapper RW: SearchResult){
            if(RW.isSelected == True){
                AccountIds.add(RW.Acc.Id);
                if(RW.Acc.Price_Book__c != Null)
                    AccountSPriceBookIds.add(RW.Acc.Price_Book__c);
                //if the Relatedacc is a child account, add the parent account to this list
                if(RW.Acc.ParentId != Null){
                    AccountSPriceBookIds.add(ParentAccount.Price_Book__c);
                }
                if(RW.Acc.Parent.Price_Book__c != Null) AccountSPriceBookIds.add(RW.Acc.Parent.Price_Book__c);
                ProductIds.add(RW.Prod.Id);
            }
        }
        //get related Product_Mapping__c
        List<Product_Mapping__c> RelatedProductMapping =[Select code__c, Account__c, Product__c From Product_Mapping__c Where Account__c IN: AccountIds AND Product__c IN: ProductIds];
        for(integer i=0;i<RelatedProductMapping.size();i++)
            System.debug('PM ' + RelatedProductMapping[i].code__c);
        Product_Mapping__c SelectedPM = new Product_Mapping__c();
        //get standard Pricebook
        //        stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        
        List<PricebookEntry> pbList =  [Select id, pricebook2id, Product2Id,UnitPrice,Classification_Level__c from PricebookEntry WHERE pricebook2id IN: AccountSPriceBookIds AND Product2Id IN: ProductIds];
        //List<PricebookEntry> StandardpbList = [Select id, pricebook2id, Product2Id,Classification_Level__c from PricebookEntry WHERE pricebook2id =: stdPb.id AND Product2Id IN: ProductIds];
        PricebookEntry SelectedPb = new PricebookEntry();
        
        
        
        for(Wrapper RW: SearchResult){
            SelectedPM = new Product_Mapping__c();
            NewOppLineItem = new OpportunityLineItem();
            SelectedPb = new PricebookEntry();
            if(RW.isSelected == True){
                NewOppLineItem = RW.opLineItem;
                if(RW.opLineItem.id==null)
                    NewOppLineItem.OpportunityID = RelatedOpp.Id;
                NewOppLineItem.Outlet__c = RW.Acc.Id;
                if(RW.opLineItem.id==null)
                    NewOppLineItem.Product_Id__c = RW.Prod.Id;
                if(RelatedOpp.RecordType.DeveloperName == 'RFPO'){
                    NewOppLineItem.Quantity = RW.opLineItem.RFPO_Qty__c;
                }else if(RelatedOpp.RecordType.DeveloperName == 'PO'){
                    NewOppLineItem.Quantity = RW.opLineItem.PO_Qty__c;
                }
                
                for(Product_Mapping__c PM: RelatedProductMapping){
                    if(PM.Product__c == RW.Prod.Id && PM.Account__c == RW.Acc.Id){
                        SelectedPM = PM;
                        break;
                    }}
                
                //fill conga fields
                if(SelectedPM.Id != Null) NewOppLineItem.Product_Mapping_code__c = SelectedPM.code__c;
                NewOppLineItem.Weighted_Sell_Out__c = RW.sellout.Weighted_Sell_Out__c;
                NewOppLineItem.Sell_Out_Stock_on_Hand__c = RW.sellout.Stock_on_Hand__c; 
                
                
                // if(NewOppLineItem.PricebookEntryId!=null)
                //NewOppLineItem.totalPrice = NewOppLineItem.UnitPrice * NewOppLineItem.RFPO_Qty__c;
                
                /*for(PricebookEntry Pb:pbList){
if(Pb.pricebook2id == RW.Acc.Price_Book__c && Pb.Product2Id == RW.Prod.Id){
SelectedPb = Pb;
break;
}
}*/
                
                /*if(SelectedPb.Id != NUll && RW.opLineItem.id==null){  
NewOppLineItem.PricebookEntryId = SelectedPb.Id;
NewOppLineItem.UnitPrice = SelectedPb.UnitPrice;
}else if(SelectedPb.Id == NUll){
system.debug('2nd case ');
//if the account has a parent, get the PricebookEntry of the parent 
if(RW.Acc.parentId != null){
system.debug('2nd case dash 1 has parent');

if(RelatedAccount.ParentId == Null){
//get the parent account from the AccountList List
for(Account Acc1 : AccountList){
if(Acc1.Id == RW.Acc.ParentId){
ParentAccount = Acc1;
break;
}}}

for(PricebookEntry Pb:pbList){
if(Pb.pricebook2id == ParentAccount.Price_Book__c && Pb.Product2Id == RW.Prod.Id){
SelectedPb = Pb;
break;
}
}

if(SelectedPb.Id != Null){
system.debug('2nd case dash 1-1 found parent pricebook');
if(NewOppLineItem.PricebookEntryId==null)
NewOppLineItem.PricebookEntryId = SelectedPb.Id;
NewOppLineItem.UnitPrice = SelectedPb.UnitPrice;
}
}
}*/
                //end heree
                system.debug('NewOppLineItem ' + NewOppLineItem);
                if(NewOppLineItem.PO_Qty__c == Null && NewOppLineItem.RFPO_Qty__c == Null){
                    //don't add    
                }else{
                    OppLineItemToBeAdded.add(NewOppLineItem);
                }
                
            }
        }
        
        system.debug('OppLineItemToBeAdded ' + OppLineItemToBeAdded);
        if(OppLineItemToBeAdded.isEmpty() == False)
            upsert OppLineItemToBeAdded;
        
        
        return null;
    }
    
}