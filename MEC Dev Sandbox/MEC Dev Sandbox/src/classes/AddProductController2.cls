public with sharing class AddProductController2 {
    
/*   public List<Contact> contacts{get;set;}
   private String sortDirection = 'ASC';
   private String sortExp = 'name';

    public String sortExpression{
        get
        {
            return sortExp;
        }
        set
        {
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }

     public String getSortDirection(){
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
     }
    
    public void setSortDirection(String value){  
       sortDirection = value;
     }
    
    public PageReference ViewData() {
       string sortFullExp = sortExpression  + ' ' + sortDirection;
       contacts = Database.query('select FirstName, LastName, Birthdate, Email, LastModifiedDate, OwnerId from Contact order by ' + sortFullExp + ' limit 50');
       return null;
   }*/
    
   public List<Account> accounts;
   private String sortDirection = 'ASC';
   private String sortExp = 'name';
   public String inputValue{get;set;} 

   public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

 public String getSortDirection()
 {
    //if not column is selected 
    if (sortExpression == null || sortExpression == '')
      return 'ASC';
    else
     return sortDirection;
 }

 public void setSortDirection(String value)
 {  
   sortDirection = value;
 }
  
   public List<Account> getAccounts() {
       return accounts;
   }


   public PageReference ViewData() {
       //build the full sort expression
       string sortFullExp = sortExpression  + ' ' + sortDirection;
      
       //query the database based on the sort expression
       accounts = Database.query('Select id, Name, BillingCity, BillingCountry, Phone from Account order by ' + sortFullExp + ' limit 50');
       return null;
   }
    
   public PageReference SearchAccounts() {
       if(inputValue!=null && !inputValue.equals('')) {
           accounts = [Select id, Name, BillingCity, BillingCountry, Phone from Account Where Name = :inputValue OR BillingCity = :inputValue OR BillingCountry = :inputValue OR Phone = :inputValue LIMIT 50];
       }     
       
       return null;
   }
}