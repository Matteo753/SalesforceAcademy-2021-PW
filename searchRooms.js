import { LightningElement, track } from 'lwc';

import getcam from '@salesforce/apex/SearchRoomsApex.getcam'
import ZIP from '@salesforce/resourceUrl/image'
import getHotels from '@salesforce/apex/prenotazioneclass.getHotels'

export default class SearchRooms extends LightningElement {

@track camere;
@track filter1=null;
@track filter2=null;
@track filter3=null;
@track filter4=null;
@track filter5=null;
@track filter6=null;
@track operatore=null;
@track image;
@track viusalimg;

@track tip_option=[
    {value:null, label:'--nessun filtro--'},
    {value:'singola' , label:'singola'},
    {value:'doppia' , label:'doppia'},
    {value:'tripla' , label:'tripla'},
    {value:'quadrupla' , label:'quadrupla'}
];

@track liv_option=[
    {value:null, label:'--nessun filtro--'},
    {value:'standard',label:'standard'},
    {value:'business',label:'business'},
    {value:'suite',label:'suite'},
    {value:'luxury',label:'luxury'}
];


foo1(event){
    this.filter1=event.detail.value;
    this.visual = false;
    this.viusalimg=false;
}

foo2(event){
    this.filter2=event.detail.value;
    this.visual = false;
    this.viusalimg=false;
}
                 
foo3(event){
    this.filter3=event.detail.value;
    if(this.filter3==''){
        this.filter3=null;
    }
    this.visual = false;
    this.viusalimg=false;
}

foo4(event){

    this.filter4=event.detail.value;
    if(this.filter4==''){
        this.filter4=null;
    }
    this.visual = false;
    this.viusalimg=false;
}

foo5(event){
    this.filter5=event.detail.value;
    this.visual = false;
    this.viusalimg=false;
}

foo6(event){
    this.filter6=event.detail.value;
    this.visual = false;
    this.viusalimg=false;
}

@track acc_option=[];
@track albview=false;

connectedCallback(){
    this.loadcontext();
}

async loadcontext(){
    await this.hotels();
    await this.getcamere();
}

async hotels(){
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
    this.albview=true;
}

async getcamere(event){
    this.btnClick = event.target.source;
        if((this.filter5==null && this.filter6!=null)||(this.filter5!=null && this.filter6==null)){
            window.alert('L\'intervallo non è completo');
        }else if(this.filter6<this.filter5){
            window.alert('End Date non può essere minore di Start Date');
        }else{
            this.camere = await getcam({
                'filter1' : this.filter1,
                'filter2' : this.filter2,
                'filter3' : this.filter3,
                'filter4' : this.filter4,
                'filter5' : this.filter5,
                'filter6' : this.filter6,
                'filter7' : this.accid
            });
            if(this.filter1!=null && this.filter2!=null){
            this.image=ZIP+'/img/'+this.filter1+this.filter2+'.jpg';
            this.viusalimg=true;
            }
        }
    }


    @track columns = [{
            label: 'Nome',
            fieldName: 'Name',
            type: 'text',
            sortable: false
        },
        {
            label: 'Tipologia',
            fieldName: 'Tipologia__c',
            type: 'text',
            sortable: false
        },
        {
            label: 'Livello',
            fieldName: 'Livello__c',
            type: 'text',
            sortable: false
        },
        {
            label: 'Albergo',
            fieldName: 'albName__c',
            type: 'text',
            sortable: false
        }];

    @track accid;
    fooacc(event){
        this.accid=event.detail.value;
    }

}