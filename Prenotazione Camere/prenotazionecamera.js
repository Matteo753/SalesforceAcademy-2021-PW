import { LightningElement,track } from 'lwc';

import getHotels from '@salesforce/apex/prenotazioneclass.getHotels'
import getCam from '@salesforce/apex/prenotazioneclass.getCam'
import getCon from '@salesforce/apex/prenotazioneclass.getCon'
import prenotation from '@salesforce/apex/prenotazioneclass.prenotation'
import insCon from '@salesforce/apex/prenotazioneclass.insCon'
import getNumOsp from '@salesforce/apex/prenotazioneclass.getNumOsp'

export default class Prenotazionecamera extends LightningElement {
    
    @track visual=false;

    @track modalview=false;
    @track contactview=false;

    showmodal(){
        this.modalview=true;
    }

    viewmodalcontact(){
        this.contactview=true;
    }

    hidemodalcontact(){
        this.contactview=false;
    }

    closemodal(){
        this.modalview=false;
        this.cam_option=[];
    }

    @track sta_option=[
                        {value:'Attesa_Cliente', label:'In Attesa del Cliente'},
                        {value:'Cliente in albergo', label:'Cliente in albergo'}
                      ];
    
    @track status;
    foosta(event){
       this.status=event.detail.value;
    }
    
    @track acconto;
    fooconto(event){
        this.acconto=event.detail.value;
    }

    @track doc;
    foodoc(event){
        this.doc=event.detail.value;
    }

    @track start;
    fooin(event){
        this.start=event.detail.value;
    }

    @track perm;
    fooperm(event){
        this.perm=event.detail.value;
    }

    @track cam;
    @track tip;
    @track liv;

    async foocam(event){
        this.cam=event.detail.value;
        const result = await getNumOsp({'cam':this.cam});
        this.tip=result.Tipologia__c;
        this.liv=result.Livello__c;
    }

    @track pre=false;
    foopre(){
        if(this.pre==false){
            this.pre=true;
        }else{
            this.pre=false;
        }
    }

    @track fname;
    foofname(event){
        this.fname=event.detail.value;
    }

    @track lname;
    foolname(event){
        this.lname=event.detail.value;
    }

    @track mail;
    foomail(event){
        this.mail=event.detail.value;
    }


    @track acc_option=[];

    @track accid;
    fooacc(event){
        this.accid=event.detail.value;
    }

    

    connectedCallback(){
        this.loadcontext();
    }

   async loadcontext() {
        try {
            const result = await getHotels();
            Array.prototype.forEach.call(result, child => {
                this.acc_option.push({
                    value: child.Id,
                    label: child.Name
                });
            });
        } catch (err) {
            this.errore = true;
        }
        this.visual = true;
        await this.gestionecamere();
    }

    @track cam_option=[];

    async gestionecamere(event){
        this.btnClick=event.target.source;
        try {
            const result = await getCam({'accid':this.accid});
            Array.prototype.forEach.call(result, child => {
                this.cam_option.push({
                    value: child.Id,
                    label: child.Name
                });
            });
        } catch (err) {
            this.errore = true;
        }
        this.modalview = true;
    }

    @track conid;

    async verificacontact(event){
        this.btnClick=event.target.source;
        const result = await getCon({'doc':this.doc});
        if(result!=null){
            this.conid=result;
            //await this.prenotazione();
            this.closemodal();
        }
    }


    async prenotazione(event){
        this.btnClick=event.target.source;

        const result = await getCon({'doc':this.doc});
        
        if(result!=null){
            this.conid=result.Id;
            try{
                const resultprenotazione = await prenotation({
                    'accid':this.accid,
                    'sta':this.status,
                    'acconto':this.acconto,
                    'conid':this.conid,
                    'start':this.start,
                    'perm':this.perm,
                    'cam':this.cam,
                    'pre':this.pre,
                    'ospiti':this.textospiti
                });
                //window.alert('Prenotazione creata con successo');
            }catch(err){
                window.alert('Nella data richiesta la camera non è disponibile');
            
            } 
            this.closeospitiview();
            
        }else{
            this.closeospitiview();
            this.viewmodalcontact();
        }    
    }

    async insertcontact(event){
        this.btnClick=event.target.source;
        const result= await insCon({
            'FName':this.fname,
            'LName':this.lname,
            'doc':this.doc,
            'mail':this.mail
        });
        this.conid=result.Id;
        if(this.conid==null){
            window.alert('Cliente NON creato');
            this.hidemodalcontact();
        }else{
            //window.alert('Cliente creato con successo');
            try{
                const resultprenotazione = await prenotation({
                    'accid':this.accid,
                    'sta':this.status,
                    'acconto':this.acconto,
                    'conid':this.conid,
                    'start':this.start,
                    'perm':this.perm,
                    'cam':this.cam,
                    'pre':this.pre
                });
                //window.alert('Prenotazione creata con successo');
            }catch(err){
                window.alert('Nella data richiesta la camera non è disponibile');
            } 
            this.hidemodalcontact();
        }
    }

    @track numospiti='';
    @track ospitiview=false;
    @track textospiti;

    closeospitiview(){
        this.ospitiview=false;
    }

    changeospiti(event){
        this.textospiti=event.detail.value;
    }

    async gestioneospiti(event){
        this.btnClick=event.target.source;
        const result = await getNumOsp({'cam':this.cam});
        switch(result.Tipologia__c){
            case 'doppia':
                this.numospiti='1';
                break;
            case 'tripla':
                this.numospiti='2';
                break;
            case 'quadrupla':
                this.numospiti='3';
                break;
        }
        this.closemodal();
        this.ospitiview=true;
    }
    

}