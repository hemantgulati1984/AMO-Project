/**
@Description: Visualforce controller for the page to export the records directly from list view.
@Author: Ejaz Mulla.
**/

public with sharing class listviewAPI {

public List<String> fields {get;set;}
public List<String> columnName {get;set;}
public List<sObject> recordList {get;set;}
public List<List<sObject>> allRecords {get;set;}
public List<listviewAPI.Columns> parserCol{get;set;}
public String fileName {get;set;}
public List<Columns> columns;

  public void fetchListviewRecords() { 
    columnName = new List<String>();
    fields = new List<String>();
    parserCol =  new List<listviewAPI.Columns>();
    recordList = new List<sObject>();
    allRecords = new List<List<sObject>>();
    try{    
    String listid = ApexPages.currentpage().getparameters().get('listid');
    String ObjectName = ApexPages.currentpage().getparameters().get('Object');
    String listName = ApexPages.currentpage().getparameters().get('listName');
    fileName =  ObjectName +'_'+listName.replace(' ','_') +'_'+ Datetime.now().format();   
 
        
    //Http callout 
    HttpRequest req = new HttpRequest();        
    req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
    req.setHeader('Content-Type', 'application/json');    
    String domainUrl=URL.getSalesforceBaseUrl().toExternalForm();
    System.debug('********domainUrl:'+domainUrl);
    //String endpointUrl = domainUrl+'/services/data/v34.0/sobjects/' +'LogCase__c'+'/listviews/'+'00B28000002qnfEEAQ'+'/describe';
    String endpointUrl = domainUrl+'/services/data/v34.0/sobjects/' + ObjectName +'/listviews/'+listid+'/describe';
    system.debug('domain URL' + endpointUrl);
    req.setEndpoint(endpointUrl);
    req.setMethod('GET');      
    Http h = new Http();
    HttpResponse res = h.send(req); 
    
    Map<String,Object> root  = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());     
    //Nested list logic to overcome collection limit.
    for(Sobject sobj : Database.query((string)root.get('query'))){
        recordList.add(sobj);        
        if(recordList.size() == 10000){
            allRecords.add(recordList);
            recordList = new List<sObject>();            
        }
     }
     
     if(recordList != null && !recordList.isEmpty())
       allRecords.add(recordList);         
    //Parsing JSON string to get the column details    
    JSONParser parser = JSON.createParser(res.getBody());        
    while (parser.nextToken() != null){ 
        if(parser.getCurrentToken() == JSONToken.START_ARRAY) {       
            while (parser.nextToken() != null) {
                if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    listviewAPI.Columns le = (listviewAPI.Columns)parser.readValueAs(listviewAPI.Columns.class);
                    parserCol.add(le);                                        
                }
            }
        }
     }
         
    for(listviewAPI.Columns lc : parserCol){
        if(lc.hidden == false && lc.fieldNameOrPath != Null){
            fields.add(lc.fieldNameOrPath);
            columnName.add(lc.label);            
        }
     }
    }catch(Exception ex){
       Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'There is some problem occurred, verify object name."'));
    }

  }   
  
  public class Columns {
    
    public String ascendingLabel;
    public String descendingLabel;
    public String fieldNameOrPath;
    public Boolean hidden;
    public String label;
    public String selectListItem;
    public String sortDirection;
    public Integer sortIndex;
    public Boolean sortable;
    public String type;
  }
}