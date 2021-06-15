public with sharing class SearchRoomsApex {
    @AuraEnabled
    public static list<Camera__c> getcam(string filter1, string filter2, decimal filter3, string filter4, date filter5, date filter6, id filter7){
        system.debug(filter5+' , '+filter6);
        string innquery='(select id, StartDate, EndDate__c, Prenotazione__c, Status from pratiche__r where';
        boolean check=false;
        if(filter5!=null){
            check=true;      
            string five=' ((StartDate>='+string.valueof(date.valueOf(filter5))+' and StartDate<='+string.valueof(date.valueOf(filter6))+')';
            innquery+=five+' or';   

            string six=' (EndDate__c<='+string.valueof(date.valueOf(filter6))+' and EndDate__c>='+string.valueof(date.valueOf(filter5))+')';
            innquery+=six+' or';  
            
            string fivesix=' (StartDate<='+string.valueof(date.valueOf(filter5))+' and EndDate__c>='+string.valueof(date.valueOf(filter6))+')';
            innquery+=fivesix; 
            innquery+=')'; 
        }
        if(check==false){
            innquery+=' (Prenotazione__c=true and Status!=\'Pratica Annullata\')';
        }else{
            innquery+=' and (Prenotazione__c=true and Status!=\'Pratica Annullata\')';
        }
        innquery+=')';
        string query='select id, Name, Tipologia__c, Livello__c, Albergo__r.Name, albName__c, Costo__c, '+innquery+' from Camera__c';
        boolean wherecondition=false;
        if(filter1!=null){
            
            string one=' where Tipologia__c=\''+filter1+'\'';
            query=query+one;  
            wherecondition=true;
        }
        
        if(filter2!=null){
            if(wherecondition==false){
                query=query+' where';
                wherecondition=true;
            }else{
                query +=' and';
            }
            string two=' Livello__c=\''+filter2+'\'';
            query=query+two;  
        }

        if(filter3!=null){
            if(wherecondition==false){
                query=query+' where';
                wherecondition=true;
            }else{
                query +=' and';
            }
            string three=' Costo__c>='+filter3;
            query=query+three;    
        }

        if(filter7!=null){
            if(wherecondition==false){
                query=query+' where';
                wherecondition=true;
            }else{
                query +=' and';
            }
            string seven=' Albergo__c=:filter7';
            query=query+seven;    
        }

        if(filter4!=null){
            if(wherecondition==false){
                query=query+' where';
                wherecondition=true;
            }else{
                query +=' and';
            }
            string four=' Costo__c<='+filter4;
            query=query+four;    
        }
        
        system.debug(query);
        list<Camera__c> lista=database.query(query);
        system.debug(lista);
        
        if(filter5!=null || filter6!=null){
            list<Camera__c> todelete= new list<Camera__c>();
            for(Camera__c c:lista){
                if(c.pratiche__r.size()!=0){
                    todelete.add(c);
                }
            }
            for(Camera__c i:todelete){
                lista.remove(lista.indexof(i));
            }
            system.debug(lista);
        }
        
        return lista;
    }
}

/*
boolean check=false;
        if(filter5!=null && filter6!=null){
            check=true;
            if(!innquery.contains('where')){
                innquery=innquery+' where';
            }
            string condition=' (StartDate<'+string.valueof(date.valueOf(filter5))+' and EndDate__c<'+string.valueof(date.valueOf(filter5))+')';
            condition+=' or';
            condition+=' (StartDate>'+string.valueof(date.valueOf(filter6))+' and EndDate__c>'+string.valueof(date.valueOf(filter6))+')';
            innquery+=condition;   
        }
        if(filter5!=null && check==false){
            if(!innquery.contains('where')){
                innquery+=' where';
            }else{
                innquery +=' and';
            }       
            string five=' StartDate>'+string.valueof(date.valueOf(filter5))+' and EndDate__c>'+string.valueof(date.valueOf(filter5));
            innquery+=five;   
        }
        if(filter6!=null && check==false){
            if(!innquery.contains('where')){
                innquery+=' where';
            }else{
                innquery +=' and';
            }
            string six=' StartDate<'+string.valueof(date.valueOf(filter6))+' and EndDate__c<'+string.valueof(date.valueOf(filter6));
            innquery+=six;  
        }
        */