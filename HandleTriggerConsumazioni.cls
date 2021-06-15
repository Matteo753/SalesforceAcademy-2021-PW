public with sharing class HandleTriggerConsumazioni {
    public static void adelete(map<id,Order> oldmap){
        list<id> lista= new list<id>();
        for(Id o: oldmap.keyset()){
            lista.add(oldmap.get(o).ContractId); 
        }
       	system.debug(oldmap);
        list<Contract> listcon =[select id, Totale_consumazioni_pagate__c, Totale_consumazioni__c from contract where id in: lista];
        system.debug(listcon);
        for(Id o: oldmap.keyset()){
            for(Contract c: listcon){
                if(oldmap.get(o).ContractId==c.Id){
                    system.debug(oldmap.get(o));
                    if(oldmap.get(o).Pagato__c==true){
                        system.debug('pagato true b: '+c.Totale_consumazioni_pagate__c);
                     	c.Totale_consumazioni_pagate__c-=oldmap.get(o).TotalAmount;	  
                        system.debug('pagato true a: '+c.Totale_consumazioni_pagate__c);
                    }else{
                        system.debug('pagato false b: '+c.Totale_consumazioni__c);
                        c.Totale_consumazioni__c-=oldmap.get(o).TotalAmount;	
                        system.debug('pagato false a: '+c.Totale_consumazioni__c);
                    }        
                }
            }
        }
        update listcon;
    }
}