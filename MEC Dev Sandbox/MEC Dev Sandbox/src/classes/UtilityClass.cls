public class UtilityClass{

     @future
    public static void calculateWeightedSellOut(Set<Id> p_AcctIds, Set<Id> p_ProductIds,Set<String> p_Weeks){
        
        double weightedNumber = 0.0;
        double totalNumber = 0.0;
                
        double week4 = 0.4;
        double week3 = 0.3;
        double week2 = 0.2;
        double week1 = 0.1;
        
        List<double> weighted = new List<double>();
        
        Boolean lastFourWeek = false;
        
        weighted.add(week4);
        weighted.add(week3);
        weighted.add(week2);
        weighted.add(week1);                        
                        
        map<String,Sell_Out__c> mapSellOut = new map<String,Sell_Out__c>();
        try{
        
            String week = new List<String> ( p_weeks)[0];
            //p_weeks[0];            
            Integer weeknumber = Integer.Valueof(week);
            Set<String> strWeeks = new Set<String>();
            
            /*if(weeknumber > 4){
                 for(integer i=weeknumber-1;i>0;i--){                
                    strWeeks.add(string.valueof(i));
                }
            }
            else{
                 for(integer i=weeknumber;i>0;i--){                
                    strWeeks.add(string.valueof(i));
                }
            }*/
            
           for(integer i=weeknumber-1;i>0;i--){                
               strWeeks.add(string.valueof(i));
           }
            
            system.debug('strWeeks = ' + strWeeks);
          
           List<Sell_Out__c> sellList = [Select Id,Account__c, Product__c,Week__c,Week_Number_Weight__c,Sell_Out__c from Sell_Out__c 
           Where Account__c IN : p_AcctIds and Product__c IN : p_ProductIds and Week__c IN : strWeeks order by Account__c, Product__c,week__c desc];//order by week__c desc limit 5
           
           
           List<Sell_Out__c> sellListWeek = [Select Id,Account__c, Product__c,Week__c,Week_Number_Weight__c,Sell_Out__c from Sell_Out__c 
           Where Account__c IN : p_AcctIds and Product__c IN : p_ProductIds and Week__c IN : p_Weeks
            order by Account__c, Product__c,week__c desc];//order by week__c desc limit 5
            
           for(Sell_Out__c sl :sellListWeek  ){               
               mapSellOut.put(sl.Week__c,sl);               
           }
    
           system.debug('sellList Future = ' + sellList);
           system.debug('sellListWeek Future = ' + mapSellOut);
           
           integer counter = 0;
           
           for(integer i = 0; i<sellList.size(); i++){
               
               system.debug(i + '=' + sellList[i]);
               
               
               if(sellList.size() >= 4){
                   
                   system.debug('Four Weeks');
                   
                   lastFourWeek = true;                   
                   weightedNumber += sellList[i].Sell_Out__c * weighted[i];
                   system.debug('weightedNumber =' + weightedNumber );  
                   
                   if(sellList[i].Sell_Out__c == 0){
                       counter++;                       
                   }
                   
                   totalNumber += sellList[i].Sell_Out__c;                 
                   
               }
               else{
                   
                       totalNumber += sellList[i].Sell_Out__c;
                       system.debug('Not Four Weeks');
                       lastFourWeek = false;
                        if(sellList[i].Sell_Out__c > 0){
                           counter++;                       
                       }
                                      
               } 
               
            }
            
            if(counter > 0)
                lastFourWeek = false;
            
            if(totalNumber > 0.0 && lastFourWeek == false){
                system.debug('calculated totalNumber');
                //weightedNumber = totalNumber/(sellList.size()-1);
                weightedNumber = totalNumber/counter;
                
            }
                
            
           
           if(sellListWeek.size() == 0){
                
                for(Sell_Out__c sl : mapSellOut.values()){
                    //sl.Week_Number_Weight__c = sl.Sell_Out__c;
                }
           }
           else {
               
               for(Sell_Out__c sl : mapSellOut.values()){
                    sl.Week_Number_Weight__c = weightedNumber;
                }
           
           }
           
            
            
            update mapSellOut.values();
            
            //update sellList;
            
            //system.debug('After sellList= ' + sellList);
        
        
       }
       catch(Exception ex){
           system.debug('Exception = ' + ex.getMessage());    
       
       }
        
    
    
    }

}