trigger OpportunityProductsTrigger on OpportunityLineItem (before insert, before update) {
    
    Set<id> productIds = new Set<id>();
    Set<id> accountIds = new Set<id>();
    Set<id> OpportunityIds = new Set<id>();
    
    for(OpportunityLineItem oppline : Trigger.New){
        OpportunityIds.add(oppline.OpportunityId);
    }
    
    Map<id,Opportunity> oppMap = new Map<id,Opportunity>([select id, accountId, parent_Account_Id__c from Opportunity where id in :OpportunityIds]);
    
    for(OpportunityLineItem oppline : Trigger.New){
    	productIds.add(oppline.Product2Id);
        accountIds.add(oppMap.get(oppline.OpportunityId).accountId);
        accountIds.add(oppMap.get(oppline.OpportunityId).parent_Account_Id__c);
    }

    List<Product_Mapping__c> productMappingList = [select id, code__c,product__c,Account__c from Product_Mapping__c where product__c in :productIds and account__c in :accountIds];
    for(Product_Mapping__c pm : productMappingList){
        for(OpportunityLineItem oppline : Trigger.New){
            if(pm.product__c == oppline.Product2Id &&
               (pm.Account__c == oppMap.get(oppline.OpportunityId).accountId || pm.Account__c == oppMap.get(oppline.OpportunityId).parent_Account_Id__c)){
                oppline.Product_Mapping_code__c = pm.code__c;
            }
        }
    }
}