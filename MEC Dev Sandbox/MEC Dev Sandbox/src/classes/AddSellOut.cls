public class AddSellOut{
    
    public Account RelatedAccount{get;set;}

    Public List<Wrapper> SearchResult{get;set;}
    Public List<Wrapper> AllSearchResult{get;set;}
    Public List<SearchWrapper> SearchCriteria{get;set;}
    
    
     public AddSellOut(ApexPages.standardController std) {
         
        RelatedAccount = (Account)std.getRecord();
        SearchCriteria = new List<SearchWrapper>();
        
        
     
     
     
     }
     
     Public Void getSearchCriteria(){
        List<Customer_Category_Classfication__c> CustomerCategoryClassficationS = [Select Id, Classification_Level__c, Product_Category__c From Customer_Category_Classfication__c Where Account__c =: RelatedAccount.Id];
        //fill SearchCriteria wrapper
        SearchCriteria = new List<SearchWrapper>();
        for(Customer_Category_Classfication__c ccc: CustomerCategoryClassficationS){
            SearchCriteria.add(new SearchWrapper(True, ccc.Product_Category__c, ccc.Classification_Level__c));
        }
    }
    
      Public Void doSearch(){
      
      
      
      }
    
    
     public Class Wrapper{
        public Boolean isSelected {get;set;}
        Public Product2 Prod {get;set;}
        public Account Acc {get;set;}
        public Decimal recommendedRFPO {get;set;}
        
        public Sell_Out__c sellOut {get;set;} 
        public Stock__c stock {get;set;} 

        Public Wrapper(Boolean isSelected, Account Acc, Product2 Prod){
            this.isSelected = isSelected;
            this.Acc = Acc;
            this.Prod = Prod;
            recommendedRFPO = 0;
            
        }
    }
    
       public Class SearchWrapper{
        public Boolean isSelected {get;set;}
        public String Category {get;set;}
        public String Classification {get;set;}
        Public SearchWrapper(Boolean isSelected, String Category, String Classification){
            this.isSelected = isSelected;
            this.Category = Category;
            this.Classification = Classification;
        }
    }
    



}