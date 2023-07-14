import { LightningElement, wire, track } from 'lwc';

import getAccountList from '@salesforce/apex/fetchAccounts.getAccountList';

export default class AutoSearch extends LightningElement {
    @track columns = [{
        label: 'Account name',
        fieldName: 'Name',
        type: 'text',
        sortable: true
    },
    {
        label: 'Type',
        fieldName: 'Type',
        type: 'text',
        sortable: true
    },
    {
        label: 'Phone',
        fieldName: 'Phone',
        type: 'phone',
        sortable: true
    },
    {
        label: 'Website',
        fieldName: 'Website',
        type: 'url',
        sortable: true
    },
    {
        label: 'Rating',
        fieldName: 'Rating',
        type: 'test',
        sortable: true
    }
    ];
    @track error;
    @track accList;
    @track showTable = false;
    accountList = [];

    handleChange(event) {
        var searchedText = event.target.value;
        var recs = this.accountList;
        this.accList = [];
        if (searchedText != '') {
            this.showTable = true;
            for (let i = 0; i < recs.length; i++) {
                if (recs[i].Name.toLowerCase().includes(searchedText.toLowerCase())) {
                    this.accList.push(recs[i]);
                }
            }
        }
        else {
            this.showTable = false;
        }
    }

    @wire(getAccountList)
    wiredAccounts({
        error,
        data
    }) {
        if (data) {
            this.accountList = data;
        } else if (error) {
            this.error = error;
        }
    }

}