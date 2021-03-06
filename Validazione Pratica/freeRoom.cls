public with sharing class freeRoom {
    public static Camera__c freequery(date filter1, date filter2, Id filterid){
        string innquery='(select id, StartDate, EndDate__c, Prenotazione__c, Status from pratiche__r where';
        boolean check=false;
        if(filter1!=null){
            check=true;      
            string five=' ((StartDate>='+string.valueof(date.valueOf(filter1))+' and StartDate<='+string.valueof(date.valueOf(filter2))+')';
            innquery+=five+' or';   

            string six=' (EndDate__c<='+string.valueof(date.valueOf(filter2))+' and EndDate__c>='+string.valueof(date.valueOf(filter1))+')';
            innquery+=six+' or';  
            
            string seven=' (StartDate<='+string.valueof(date.valueOf(filter1))+' and EndDate__c>='+string.valueof(date.valueOf(filter2))+')';
            innquery+=seven; 
            innquery+=')'; 
        }
        if(check==false){
            innquery+=' (Prenotazione__c=true and Status!=\'Pratica Annullata\')';
        }else{
            innquery+=' and (Prenotazione__c=true and Status!=\'Pratica Annullata\')';
        }
        innquery+=')';
        string query='select id, Name, Tipologia__c, Livello__c, Costo__c, '+innquery+' from Camera__c where Id=:filterid';

        system.debug(query);
        Camera__c lista=database.query(query);
        system.debug(lista);
        if(lista.pratiche__r.size()!=0){
            return null;
        }else{
            return lista;
        }
    }
}