global class BatchApexAccountUpdate implements Database.Batchable<Sobject>, Database.Stateful{

    // Map to hold ID and Error Message
    global Map<Id, String> errorMap {get; set;}
    // map to hold id and associated sobject
    global Map<Id, SObject> IdToSObjectMap {get; set;}

    global class BatchApexAccountUpdate(){
        errorMap = new Map<Id, String>();
        IdToSObjectMap = new Map<Id, SObject>();
    }
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){

        return Database.getQueryLocator('Select Id, ownerId, Name From Account');

    }
    // Execute Method
    global void execute(Database.BatchableContext BC,List<Sobject> scope){

        List<Account> accountList = new List<Account>();
        for(SObject s : scope){
          Account acct = (Account) s;
          // Logic to update fields on the Account
           accountList.add(acct);
        }

        if(accountList.size()>0){
            List<Database.SaveResult> dsrs = Database.Update(accountList,false);
            Integer index = 0;
            for(Database.SaveResult dsr : dsrs){
                if (!dsr.isSuccess()) {
                    String errMsg = dsr.getErrors()[0].getMessage();
                    errorMap.put(accountList[index].id,errMsg);
                    IdToSObjectMap.put[(accountList[index].Id, accountList[index]]
                }
            index++;
            }
        }
    }
    //Finish Method 
    global void finish(atabase.Batchablecontext  BC){

        if(!errorMap.isEmpty()){
            AsyncApexJob a = [SELECT Id,ApexClassId, JobItemsProcessed, 
                            TotalJobItems , NumberOfErrors, CreatedBy.Email From AsyncApexJob Where id =: BC.getJobId()];
          String body = 'Your batch job '
             + 'BatchApexAccountUpdate '
             + 'has finished. \n' 
             + 'There were '
             + errorMap.size()
             + ' errors. Please find the error list attached to the Case.';

             //Creating CSV File
              String finalstr = 'Id, Name, Error \n';
              String subject = 'Account - Apex Batch Error List'; 
              String attName = 'Account Errors.csv'; 

              for(Id id  : errorMap.keySet()){

                string err = errorMap.get(id);

                Account acct = (Account) IdToSObjectMap.get(id);

                string recordString = '"'+id+'","'+acct.Name+'","'+err+'"\n';
                finalstr = finalstr +recordString;
                
            } 

            // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();

             efa.setFileName(attName);
             efa.setBody(Blob.valueOf(finalstr));

             // Sets the paramaters of the email
            email.setSubject( subject );
            email.setToAddresses( new String[] {a.CreatedBy.Email} );
            email.setPlainTextBody( body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Sends the email
            Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
            }
        }

    }

}