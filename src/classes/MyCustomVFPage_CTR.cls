public class MyCustomVFPage_CTR {

    public String ObjectId {get;set;}

    public String ResponseCode {get;set;}
    
   public String ManagerId {get;set;}
    
     /*public String CaseNumber{get;set;}*/
    
    public list<TempResponseTable__c> listResponse{ get; set; }

    public MyCustomVFPage_CTR () {

        ObjectId = ApexPages.currentPage().getParameters().get('ObjectId');

        ResponseCode = ApexPages.currentPage().getParameters().get('ResponseCode');
        
        ManagerId = ApexPages.currentPage().getParameters().get('ManagerId');
        
        /*CaseNumber = ApexPages.currentPage().getParameters().get('CaseNumber');*/

    }

    public PageReference InitPage() {
     
        List<TempResponseTable__c> res= [SELECT Id, AcceptDeny__c FROM TempResponseTable__c WHERE Name=:ObjectId LIMIT 1];

        if(!res.IsEmpty()){
        
            res[0].AcceptDeny__c = ResponseCode;
            res[0].ManagerIds__c = ManagerId;
            /*res[0].CaseNumber__c = CaseNumber;*/
             
            UPDATE res;
        }
        else{
            listResponse=new list<TempResponseTable__c>();
            TempResponseTable__c resNew= new TempResponseTable__c();
            resNew.Name = ObjectId ;
           resNew.ManagerIds__c = ManagerId;
            /* resNew.CaseNumber__c = CaseNumber;*/
            resNew.AcceptDeny__c = ResponseCode;
            resNew.LogCaseNumber__c = ObjectId ;
            listResponse.add(resNew);
            INSERT listResponse;
        }
        return null;

    }

}