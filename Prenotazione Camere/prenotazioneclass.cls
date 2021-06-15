public with sharing class prenotazioneclass {
    @AuraEnabled
    public static List<Account> getHotels(){
        //system.debug([SELECT Id, Name, RecordTypeId  FROM Account where RecordTypeId='01209000000xz76AAA']);
        return [SELECT Id, Name, RecordTypeId  FROM Account where RecordTypeId='01209000000xz76AAA'];
    }

    @AuraEnabled
    public static List<Camera__c> getCam(id accid){
        //system.debug([SELECT Id, Name, Tipologia__c FROM Camera__c where Albergo__c=:accid]);
        return [SELECT Id, Name, Tipologia__c, Livello__c, Albergo__c FROM Camera__c where Albergo__c=:accid];
    }

    @AuraEnabled
    public static Camera__c getNumOsp(id cam){
        //system.debug([SELECT Id, Name, Tipologia__c FROM Camera__c where Albergo__c=:accid]);
        return [SELECT Id, Name, Tipologia__c, Livello__c FROM Camera__c where id=:cam];
    }

    @AuraEnabled
    public static Contact getCon(string doc){
        Contact c;
        try{
            c=[SELECT Id, Name, Numero_Documento__c FROM Contact where Numero_Documento__c=:doc];
        }catch(Exception e){
            return null;
        }
        return c;
    }

    @AuraEnabled
    public static Contact insCon(string FName, string LName, string doc, string mail){
        system.debug(FName+' , '+LName+' , '+doc);
        Contact c= new Contact(FirstName=FName, LastName=LName, Numero_Documento__c=doc, Email=mail);
        Database.insert(c,false);
        system.debug(c);
        return c;
    }

    @AuraEnabled
    public static Contract prenotation(id accid, string sta, decimal acconto, id conid, date start, integer perm, id cam, boolean pre, string ospiti){
        system.debug(accid+' , '+ sta +' , '+ acconto +' , '+conid +' , '+start+' , '+ perm+' , '+ cam +' , '+pre+' , '+ospiti);
        Contact contatto=[select id, Name, AccountId from Contact where id=:conid];
        Contract c= new Contract(Albergo_nome_pratica__c=accid,AccountId=contatto.AccountId,Status=sta,Acconto__c=acconto,CustomerSignedId=conid,StartDate=start,ContractTerm=perm,Tipologia_Camera__c=cam,Prenotazione__c=pre,Ospiti__c=ospiti);
        insert c;
        system.debug(c);

        return c;
    }
    

}