public class DetailsPage{
    
    public string OppID{get;set;}
    public List<OpportunityLineItem> POList{get;set;}
    public List<DPTableRecord> TableData{get;set;}
    public Map<Id,DPTableRecord> TableDataMap{get;set;}
    public DPTableRecord TempRecord{get;set;}
    public List<TotalValues> TotalVal{get;set;}
    public Map<id,Product2> products{get;set;}
    public Set<ID> poLineIDs{get;set;}
    
    public class DPTableRecord
    {
        public string ProductName{get;set;}
        public Decimal RFP_Qty{get;set;}
        public Decimal PO_Qty{get;set;}
        public Decimal Stock_Qt{get;set;}
        public Decimal AvailableStock{get;set;}
        public Decimal SellOUTQty{get;set;}
        public Decimal SellINQty{get;set;}
        public Decimal Price{get;set;}
        public Decimal RemainingUnbookedQty{get;set;}   
        
        public DPTableRecord(){
            RFP_Qty = 0;
            PO_Qty = 0;
            Stock_Qt = 0;
            AvailableStock = 0;
            SellOUTQty = 0;
            SellINQty = 0;
            Price = 0;
            RemainingUnbookedQty = 0;
        } 
    }
    
    public class TotalValues
    {
        public Decimal TotalPrice{get;set;}
        public Decimal TotalUnbooked{get;set;}
    }
    
    public DetailsPage(ApexPages.StandardController stdController)
    {
        try{
            TotalValues TV = new TotalValues();
            TV.TotalPrice =0;
            TV.TotalUnbooked=0;
            TotalVal = new List<TotalValues>();
            TableData = new List<DPTableRecord>();
            TableDataMap = new Map<id,DPTableRecord>();
            OppID=System.currentPageReference().getParameters().get('id');

            POList=[select ID,Product2ID,UnitPrice,RFPO_Qty__c,PO_Qty__c from OpportunityLineItem where OpportunityId=:OppID];
            poLineIDs = new Set<ID>();
            for(OpportunityLineItem OLI : POList){
                poLineIDs.add(OLI.Product2ID);
            }

            products = new Map<id,Product2>([select id,name,Stock_in_Channel__c,Available_Stock__c,Sell_Out_Qty__c,Sell_In_Qty__c from Product2 where id in :poLineIDs]); 
            System.debug('Id size:' + products.size());            
            
            for (integer i =0;i<POList.size();i++)
            {
                Product2 OLI = products.get(POList[i].Product2ID);
                
                if(TableDataMap.get(POList[i].Product2ID)==null)
                    TempRecord = new DPTableRecord();
                else
                    TempRecord = TableDataMap.get(POList[i].Product2ID);
                    
                if(OLI.Name==null)
                {
                    TempRecord.ProductName='N/A';
                }
                else
                {
                    TempRecord.ProductName=OLI.Name;
                } 
                if(POList[i].RFPO_Qty__c==null)
                {
                    TempRecord.RFP_Qty+=0;
                }
                else
                {
                    TempRecord.RFP_Qty+=POList[i].RFPO_Qty__c;
                }
                if(POList[i].PO_Qty__c==null)
                {
                    TempRecord.PO_Qty+=0;
                }
                else
                {
                    TempRecord.PO_Qty+=POList[i].PO_Qty__c;
                }
                if(OLI.Stock_in_Channel__c==null)
                {
                    TempRecord.Stock_Qt=0;
                }
                else
                {
                    TempRecord.Stock_Qt=OLI.Stock_in_Channel__c; //Opp.Available_Stock__c;
                }
                if(OLI.Available_Stock__c==null)
                {
                    TempRecord.AvailableStock=0;
                }
                else
                {
                    TempRecord.AvailableStock=OLI.Available_Stock__c;
                }
                if(OLI.Sell_Out_Qty__c==null)
                {
                    TempRecord.SellOUTQty=0;
                }
                else
                {
                    TempRecord.SellOUTQty=OLI.Sell_Out_Qty__c;
                }
                if(OLI.Sell_In_Qty__c==null)
                {
                    TempRecord.SellINQty=0;
                }
                else
                {
                    TempRecord.SellINQty=OLI.Sell_In_Qty__c;
                }
                if(POList[i].UnitPrice==null)
                {
                    TempRecord.Price=0;
                }
                else
                {
                    if(POList[i].PO_Qty__c!=null)
                        TempRecord.Price += (POList[i].UnitPrice * POList[i].PO_Qty__c);
                    else if(POList[i].RFPO_Qty__c!=null){
                        TempRecord.Price += (POList[i].UnitPrice * POList[i].RFPO_Qty__c);
                    }    
                    
                    TempRecord.Price = TempRecord.Price.setScale(2);
                    
                    if(POList[i].PO_Qty__c!=null)
                        TV.TotalPrice =TV.TotalPrice+ (POList[i].UnitPrice*POList[i].PO_Qty__c);
                    else if(POList[i].RFPO_Qty__c!=null)    
                        TV.TotalPrice =TV.TotalPrice+ (POList[i].UnitPrice*POList[i].RFPO_Qty__c);
                    
                    TV.TotalPrice = TV.TotalPrice.setScale(2);
                }
                
                if(POList[i]==null||OLI.Sell_In_Qty__c==null)
                {
                    TempRecord.RemainingUnbookedQty =0;
                }
                else
                {
                    TempRecord.RemainingUnbookedQty += POList[i].PO_Qty__c - OLI.Sell_In_Qty__c;
                    TV.TotalUnbooked =TV.TotalUnbooked+TempRecord.RemainingUnbookedQty;
                }
                
                TableDataMap.put(POList[i].Product2ID,TempRecord);
            }
            TotalVal.add(TV);
            TableData = TableDataMap.values();
        }catch(Exception e) {
             System.debug('An unexpected error has occurred: ' + e.getMessage());
             System.debug(e);
             System.debug('Exception => '+ e.getMessage() + ' : Line Number => '+ e.getLineNumber());
        }        
    }
}