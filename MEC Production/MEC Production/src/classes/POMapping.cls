public class POMapping {

    public Account acct {get; set;}
    public Product2 prod {get; set;}
    public String clientCode {get; set;}
    public String notes {get; set;}
    public Integer numberOfItems {get; set;}
    public boolean match {get; set;}
    public id prodId {get; set;}
    public TmpObject__c tmpObj {get; set;}
    
    public POMapping(){
        tmpObj = new TmpObject__c();
    }
    
}