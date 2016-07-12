public class AddSellOutController {
    
    public String Classification{get;set;}
    public Account RelatedAccount{get;set;}
    public Account Store{get;set;}
    Public List<Account> AccountList {get;set;}
    Map<Id, List<Wrapper>> DisplayMap{get;set;}
    Map<Id, List<SearchWrapper>> DisplaySearchMap{get;set;}
    public boolean returnToAccount{get;set;} 
    public boolean trueBool {get;set;} 
    
    Public List<Wrapper> SearchResult{get;set;}
    Public List<Wrapper> AllSearchResult{get;set;}
    Public List<SearchWrapper> AllSearchCriteria{get;set;}
    Public List<SearchWrapper> SearchCriteria{get;set;}
    public Boolean AddDisabled {get;set;}
    //heree
    public Boolean PrevDisabled {get;set;}
    public Boolean NextDisabled {get;set;}
    Account CurrentAccount {get;set;}
    Integer Index{get;set;}
    
    
    
    public Boolean SearchDisabled {get;set;}
    Account ParentAccount {get;set;}
    
    Pricebook2 stdPb{get;set;}    
    Private Boolean flag{get;set;}
    Private Boolean anotherFlag{get;set;}
    
    
    public AddSellOutController(ApexPages.standardController std) {
        trueBool = true;
        RelatedAccount = (Account)std.getRecord();
        SearchResult = new List<Wrapper>();
        AllSearchResult = new List<Wrapper>();
        DisplayMap = new Map<Id, List<Wrapper>>();
        DisplaySearchMap = new Map<Id, List<SearchWrapper>>();
        SearchCriteria = new List<SearchWrapper>();
        AllSearchCriteria = new List<SearchWrapper>();
        ParentAccount = new Account();
        
        Store = RelatedAccount;
        AddDisabled = True;
        NextDisabled = True;
        PrevDisabled = True;
        Index = 0;
        CurrentAccount = new Account();
        SearchDisabled = True;
        AccountList = new List<Account>();
        
        flag =True;
        anotherFlag = True;
    }
    
    public Class Wrapper{
        public Boolean isSelected {get;set;}
        Public Product2 Prod {get;set;}
        public Account Acc {get;set;}
        public Sell_Out__c sellOut {get;set;} 
        
        Public Wrapper(Boolean isSelected, Account Acc, Product2 Prod){
            this.isSelected = isSelected;
            this.Acc = Acc;
            this.Prod = Prod;
            this.sellOut = sellOut;
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
    
    Public Void getSearchCriteria(){
        AccountList = new List<Account>();
        List<Account> ChildrenAccountList = new List<Account>();
        List<Id> AccountSIdS = new List<Id>();
        //select the current account + its children if any exist
        //if the account parent field filled, then it is a child
        if(RelatedAccount.ParentId != Null){
            AccountList.add(RelatedAccount);
            //ParentAccount = [Select Id, name, Price_Book__c, Parent.Price_Book__c From Account Where Id =: RelatedAccount.ParentId];
        }else{
            //the account is not a child, search if it has children
            AccountList.add(RelatedAccount);
            ChildrenAccountList = [Select Id From Account Where ParentId =: RelatedAccount.Id];
            if(ChildrenAccountList.isEmpty() == False)
                AccountList.addAll(ChildrenAccountList);
        }
        for(Account A : AccountList){
            AccountSIdS.add(A.Id);
        }
        
        List<Customer_Category_Classfication__c> CustomerCategoryClassficationS = [Select Id, Account__c, Classification_Level__c, Product_Category__c From Customer_Category_Classfication__c Where Account__c IN: AccountSIdS];
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
                }}
            DisplaySearchMap.Put(Acc1.Id, temp);
        }
        
        //system.debug('AllSearchResult ' + AllSearchResult);
        system.debug('DisplaySearchMap ' + DisplaySearchMap);
        
        SearchCriteria = DisplaySearchMap.get(RelatedAccount.Id);
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
        DisplayMap = new Map<Id, List<Wrapper>>();
        AccountList = new List<Account>();
        List<Account> ChildrenAccountList = new List<Account>();
        List<Product2> ProductList = new List<Product2>();
        Map<Id, Product2> ProductListToBedisplayed = new Map<Id, Product2>();
        //select the current account + its children if any exist
        //if the account parent field filled, then it is a child
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
        
        List<Id> AccountPricebookEntryIdS = new List<Id>();
        for(Account A: AccountList){
            AccountPricebookEntryIdS.add(A.Price_Book__c);
        }
        
        List<PricebookEntry> AccountPricebookEntry = [Select Product2Id,UnitPrice From PricebookEntry Where pricebook2id IN: AccountPricebookEntryIdS];
        List<Id> ProductSIdS = new List<Id>();
        for(PricebookEntry PEI :AccountPricebookEntry){
            ProductSIdS.add(PEI.Product2Id);
        }
        ProductList = [Select name, Manufacturing_Type__c,Merchandise_Category__c,Product_Hierarchy2__r.Category__c,Item_Status_Description__c,Item_Status__c,
                       Latest_Stock__c From Product2 Where Id IN: ProductSIdS];
        
        List<Product_Classification__c> ProductClassificationS = [Select Product__c, Classification_Level__c From Product_Classification__c Where Product__c IN: ProductSIdS];
        
        //set ProductListToBedisplayed
        for(SearchWrapper SW: SearchCriteria){
            if(SW.isSelected == True){
                for(Product2 prod : ProductList){
                    for(Product_Classification__c PC : ProductClassificationS){
                            if(prod.Id == PC.Product__c && SW.Classification >= PC.Classification_Level__c && SW.Category == Prod.Product_Hierarchy2__r.Category__c ){
                            ProductListToBedisplayed.put(prod.Id, prod); 
                        }
                    }
                }}}
        
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
        
        List<PricebookEntry> pbList =  [Select id, pricebook2id, Product2Id, UnitPrice from PricebookEntry WHERE pricebook2id =: TheParentAcc.Price_Book__c AND Product2Id IN: ProductIds];
        
        system.debug('ProductListToBedisplayed.values()' +ProductListToBedisplayed.values());
        AllSearchResult = new List<Wrapper>();
        
        
        for(Account Acc: AccountList){
            for(Product2 P: ProductListToBedisplayed.values()){
                
                //for el list, get same acc and p
                for(PricebookEntry SelectedPb: pbList){
                    if(SelectedPb.Product2Id == p.Id){
                        AllSearchResult.add(new Wrapper(True, Acc, p));
                        break;
                    }
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
        
        system.debug('AllSearchResult ' + AllSearchResult);
        system.debug('DisplayMap ' + DisplayMap);
        if (anotherFlag == True){
            Index = 1;
            SearchResult = DisplayMap.get(RelatedAccount.Id);
            if(AccountList.size() > 1){
            NextDisabled = False;
                PrevDisabled = true;}
            
        }
        //CurrentAccount = new Account();
        
        
        
        //if (flag == true) getNextAccount();
        //getNextAccount();
    }
    
    Public Void getNextAccount(){
        anotherFlag = False;
        SearchCriteria = new List<SearchWrapper>();
        SearchResult = new List<Wrapper>();
        List<Wrapper> temp = new List<Wrapper>();
        List<SearchWrapper> Srchtemp = new List<SearchWrapper>();
        if(Index ==1 ) PrevDisabled = False;
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
        system.debug('Index ' + Index);
        CurrentAccount.Id = AccountList[Index].Id;
        Store = AccountList[Index];
        system.debug('hnaaaa '  + Store.name);
        
        if(CurrentAccount.Id != NUll) Srchtemp = DisplaySearchMap.get(CurrentAccount.Id);
        if(Srchtemp.size() > 0){ 
            SearchCriteria.addAll(Srchtemp);
            system.debug('SearchCriteria '  + SearchCriteria);
            
        }else{
            SearchCriteria = DisplaySearchMap.get(RelatedAccount.Id);
        }
        doSearch();
        
        
        if(CurrentAccount.Id != NUll) 
            temp = DisplayMap.get(CurrentAccount.Id);
        
        if(temp.size() >0){ 
            SearchResult.addAll(temp);
        }else{
            SearchResult = new List<Wrapper>();
        }
        
        system.debug('temp ' + temp);
        system.debug('SearchResult ' + SearchResult);
    }
    
    Public void getPrevAccount(){
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
        system.debug('Index ' + Index);
        CurrentAccount.Id = AccountList[Index].Id;
        Store = AccountList[Index];
        system.debug('hnaaaa '  + Store.name);
        
        if(CurrentAccount.Id != NUll) Srchtemp = DisplaySearchMap.get(CurrentAccount.Id);
        if(Srchtemp.size() > 0){ 
            SearchCriteria.addAll(Srchtemp);
            
        }else{
            SearchCriteria = DisplaySearchMap.get(RelatedAccount.Id);
        }
        doSearch();
        
        if(CurrentAccount.Id != NUll)
            temp = DisplayMap.get(CurrentAccount.Id);
        
        if(temp.size() >0){
            SearchResult.addAll(temp);
        }else{
            SearchResult = new List<Wrapper>();
        }
        
        system.debug('temp ' + temp);
        system.debug('SearchResult ' + SearchResult);
    }
    
    Public PageReference AddSellOutsReturn(){
        AddSellOuts();
        return new PageReference('/'+RelatedAccount.id);
    }
    Public PageReference AddSellOuts(){
        //create Opportunity Product Fields
        List<Sell_out__c> sellOutToBeAdded = new List<Sell_out__c>();
        
        Set<Id> ProductIds = new Set<Id>();
        Set<Id> AccountIds = new Set<Id>();
        //get SearchResult Acc.Price_Book__c and Prod.Id
        for(Wrapper RW: SearchResult){
            if(RW.isSelected == True){
                AccountIds.add(RW.Acc.Id);
                //if(RW.Acc.Price_Book__c != Null)
                 //   AccountSPriceBookIds.add(RW.Acc.Price_Book__c);
                //if the Relatedacc is a child account, add the parent account to this list
                //if(RW.Acc.ParentId != Null){
                //    AccountSPriceBookIds.add(ParentAccount.Price_Book__c);
               // }
                //if(RW.Acc.Parent.Price_Book__c != Null) AccountSPriceBookIds.add(RW.Acc.Parent.Price_Book__c);
                ProductIds.add(RW.Prod.Id);
            }
        }
        
        //get related Product_Mapping__c
        List<Product_Mapping__c> RelatedProductMapping =[Select code__c, Account__c, Product__c From Product_Mapping__c Where Account__c IN: AccountIds AND Product__c IN: ProductIds];
        Product_Mapping__c SelectedPM = new Product_Mapping__c();
        //get standard Pricebook
        stdPb = [select Id from Pricebook2 where isStandard=true limit 1];
        
        /* Samy Comment start from here 
        List<PricebookEntry> pbList =  [Select id, pricebook2id, Product2Id,UnitPrice from PricebookEntry WHERE pricebook2id IN: AccountSPriceBookIds AND Product2Id IN: ProductIds];
        //List<PricebookEntry> StandardpbList = [Select id, pricebook2id, Product2Id from PricebookEntry WHERE pricebook2id =: stdPb.id AND Product2Id IN: ProductIds];
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
        */
        
        return null;
    }
    
    
}