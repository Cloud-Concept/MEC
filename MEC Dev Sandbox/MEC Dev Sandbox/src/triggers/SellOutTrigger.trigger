trigger SellOutTrigger on Sell_Out__c (after insert, after update) {
    
    system.debug('Before.....');
    
    Set<Id> lstAccountIds = new Set<Id>();
    Set<Id> lstProductIds = new Set<Id>();
    Set<String> lstWeek = new Set<String>();
       
   for(Sell_Out__c sl : Trigger.New){
       lstAccountIds.add(sl.Account__c);
       lstProductIds.add(sl.Product__c);
       lstWeek.add(sl.Week__c);
   }
   
   /*List<Sell_Out__c> sellList = [Select Id,Account__c, Product__c,Week__c,Week_Number_Weight__c from Sell_Out__c 
           Where Account__c IN : lstAccountIds and Product__c IN : lstProductIds];//order by week__c desc limit 5
    
    system.debug('sellList = ' + sellList);*/
    
    if(system.isFuture()) return;

    UtilityClass.calculateWeightedSellOut(lstAccountIds,lstProductIds,lstWeek);
    
    //for(Sell_Out__c a : Trigger.New) { 
        
        /*for(integer i = 5; i>0; i--){
            if(i<=sellList.size())
              sellList[4-i+1].Week_Number_Weight__c = (i-1) * 0.1;   
        }
        update sellList;*/
    //}
    
}