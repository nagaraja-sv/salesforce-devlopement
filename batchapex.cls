global class BatchjobCase implements Database.Batchable<sobject>{  
   List<Case> deleteList = new List<Case>();
   public string query;
   global Database.QueryLocator start (Database.BatchableContext BC){
       
       query ='SELECT id,Contact.Name,Subject,Status,Priority,CaseNumber FROM Case';
       system.Debug('Query==>'+query);  
       return Database.getQueryLocator(query);    
   }
   
   global void execute (Database.BatchableContext BC,list<Case> scope){
       
       deleteList = scope;
       //system.Debug('scope==>'+scope);  
       dofinish(deleteList);
       delete deleteList;
       //system.debug('deleteList==>'+deletelist);
       
   }
   
   public void dofinish (List<case> Acclist){
       
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
       string[] toAddress = new String[] {'Rakesh.maddy007@gmail.com'};
           string[] ccAddress = new string[] {'Rakesh.Manakondu@gmail.com'};
               
               string EmailBody;
       mail.setToAddresses(toAddress);
       mail.setccAddresses(ccAddress);
       mail.setSenderDisplayName('Case Deleted');
       mail.setBccSender(true);
       mail.setSaveAsActivity(false);
       
       EmailBody = '<html> <body style="font_family:rerdana; font_size:9pt;">';
       EmailBody+= 'Dear Administrator,'+'Automated Payment Process Completed Successfull,below is the list of CASES WHICH ARE CLOSED';
       
       
       if(Acclist.size() > 0){                
           EmailBody+='<table border ="1" cell padding = "4" cellspacing = "1" bycolor = "#AEB8FE">';
           EmailBody+='<tr bg color = "GREEN"> <th>';
           
           
           for(integer i=0; i<Acclist.size(); i++){
               
               EmailBody+='<tr>';
               EmailBody+='<td>'+Acclist[i].contact.name+'</td>';
               EmailBody+='<td>'+Acclist[i].subject+'</td>';
               EmailBody+='<td>'+Acclist[i].priority+'</td>';
               EmailBody+='<td>'+Acclist[i].CaseNumber+'</td>';
               EmailBody+='</tr>';
               
           }
           
           EmailBody +='</table> <br> <br>';
           
       }
       
       EmailBody += '</body> <br> </br> This is a computer generated Email. NO response is required';
       system.debug(' EmailBody==>'+ EmailBody);
       
       mail.setHtmlBody(EmailBody);
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});    
       
   }
   
   global void finish (Database.BatchableContext BC){
       
       
       
   }
   
}