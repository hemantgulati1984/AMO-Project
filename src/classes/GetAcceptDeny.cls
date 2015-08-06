public with sharing class GetAcceptDeny {	
	
    public void getrelatedListData(){
        List <TempResponseTable__c> TempResLst = New List<TempResponseTable__c>();
        for(LogCase__c lc:[select id,name,(select name,id,AcceptDeny__c from TempResponseTables__r) from LogCase__c]){
           for(TempResponseTable__c trList:lc.TempResponseTables__r)
               TempResLst.add(trList); 
        }
        System.Debug('TEMP RESPONSE LIST' + TempResLst);
        //alert(TempResLst);
    }

}