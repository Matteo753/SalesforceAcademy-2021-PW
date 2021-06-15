public with sharing class HandleTriggerValidatePratica {
    public static void binsert(list<Contract> trignew){
        Camera__c camera;
        for(Contract c:trignew){
            camera=freeRoom.freequery(c.StartDate,c.EndDate__c,c.Tipologia_Camera__c);
            system.debug(camera);
            if(camera==null){
                c.addError('Nell\'intervallo inserito la camera selezionata non è disponibile');
            }  
        }
    }

    public static void ainsert(list<Contract> trignew){
    	list<Contract> lista = [select id,ContractNumber, CustomerSigned.Name, CustomerSigned.Email 
                                from Contract 
                                where Id in:trignew];
        list<Messaging.SingleEmailMessage> mails = new list<Messaging.SingleEmailMessage>();        
        list<String> sendTo = new list<String>();        
        for(Contract c : lista){            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            sendTo.add(string.valueOf(c.CustomerSigned.Email));            
            message.setToAddresses(sendTo);
            message.setSubject('Prenotazione avvenuta con successo');
            message.setHtmlBody('Gentile '+c.CustomerSigned.name+' la sua prenotazione numero '+c.ContractNumber+' è stata confermata. Per accedere all\'area personale cliccare sul seguente link https://my-hilton-experience-developer-edition.eu40.force.com/s/');
            mails.add(message);
            
        }
        
        Messaging.sendEmail(mails);    
    }
}