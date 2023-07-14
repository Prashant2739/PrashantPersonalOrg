import { LightningElement,api } from 'lwc';
import ShowOppAmountController from '@salesforce/apex/ShowOppAmountController.calculateOppAmount';


export default class ShowOppAmountonAcc extends LightningElement {

    aggegatedOpportunityAmount=0;
    @api recordId;
    error;

    connectedCallback(){
        this.getOpportunityAmount();
    }

    getOpportunityAmount(){
        ShowOppAmountController({AccountIdFromLWC:this.recordId})
        .then(result => {
            this.aggegatedOpportunityAmount = result;
        })
        .catch(error => {
            this.error = error;
            console.log('error' + JSON.stringify(error));
        })

        }
        
}