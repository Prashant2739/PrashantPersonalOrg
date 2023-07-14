import { LightningElement,track,api} from 'lwc';
import searchAccounts from '@salesforce/apex/FacetedAccSearchController.searchAccounts';
import getDetailsOnLoad from '@salesforce/apex/FacetedAccSearchController.getDetailsOnLoad';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const resultColumns = [
    { label: 'Account Name', fieldName: 'Name' , type:'text'},
    { label: 'State', fieldName: 'BillingState', type: 'text' },
    { label: 'City', fieldName: 'BillingCity', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Industry', fieldName: 'Industry', type: 'text' },
    { label: 'Rating', fieldName: 'Rating', type: 'text' },
    { label: 'Annual Revenue', fieldName: 'AnnualRevenue', type: 'text' }
];

export default class FacetedAccountSearch extends LightningElement {

    resultColumns = resultColumns;
    @track searchedAccounts = [];
    accountName = '';
    billingState = '';
    billingCity = '';
    phoneNumber = '';
    industry = '';
    rating = '';
    industryOptions = [];
    ratingOptions = [];
    error;
    dynamicQuery = '';
    totalRecordsToDisplay = '';
    showSearchedResults = false;
    emptyFilterValidation = 'Please select atleast one filter to search the Account records.';
    notFoundValidation = 'No desired Accounts found.';

    //Pagination Properties Comment
    pageSizeOptions = [5, 10, 25, 50, 75, 100]; //Page size options
    totalRecords = 0; //Total no.of records
    pageSize = 5; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    @track recordsToDisplay = []; //Records to be displayed on the page

    connectedCallback(){
        this.getPicklistDetails();
    }

    getPicklistDetails() {
        getDetailsOnLoad()
                .then(result => {
                    var industryOptions = result.getIndustryValues;
                    for (var key in industryOptions) {
                        this.industryOptions = [...this.industryOptions, { value: key, label: industryOptions[key] }];
                    }

                    var ratingOptions = result.getRatingValues;
                    for (var key in ratingOptions) {
                        this.ratingOptions = [...this.ratingOptions, { value: key, label: ratingOptions[key] }];
                    }
                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error;
                    console.log('error' + JSON.stringify(error));
                })
    }

    handleAccountNameChange(event) {
        this.accountName = event.target.value;
    }

    handleBillingStateChange(event) {
        this.billingState = event.target.value;
    }

    handleBillingCityChange(event) {
        this.billingCity = event.target.value;
    }

    handlePhoneChange(event) {
        this.phoneNumber = event.target.value;
    }

    handleIndustryChange(event) {
        this.industry = event.target.value;
    }

    handleRatingChange(event) {
        this.rating = event.target.value;
    }

    formDynamicQuery(){
        let accountQuery = 'SELECT Id, Name, BillingState, BillingCity, Phone, Industry, Rating, AnnualRevenue FROM Account';
        let queryConditions = [];

        if (this.accountName) {
            queryConditions.push(`Name LIKE '%${this.accountName}%'`);
        }
    
        if (this.billingState) {
            queryConditions.push(`BillingState = '${this.billingState}'`);
        }
    
        if (this.billingCity) {
            queryConditions.push(`BillingCity = '${this.billingCity}'`);
        }
    
        if (this.phoneNumber) {
            queryConditions.push(`Phone = '${this.phoneNumber}'`);
        }
    
        if (this.industry) {
            queryConditions.push(`Industry = '${this.industry}'`);
        }
    
        if (this.rating) {
            queryConditions.push(`Rating = '${this.rating}'`);
        }

        if(queryConditions.length > 0){
            this.dynamicQuery = accountQuery + ` WHERE ${queryConditions.join(' AND ')}`;
        }
        console.log(' this.dynamicQuery'+ this.dynamicQuery);
    }

    handleClick(){
        if(!this.accountName && !this.billingState && !this.billingCity &&
        !this.phoneNumber && !this.industry && !this.rating ){
            this.showSearchedResults = false;
            this.showErrorMessage(this.emptyFilterValidation,'error','Error');
        }
        else{
            this.formDynamicQuery();
            searchAccounts({accountSearchQuery : this.dynamicQuery})
                .then(result => {
                    this.searchedAccounts = result;
                    this.showSearchedResults = this.searchedAccounts.length > 0 ? true:false;
                    if(!this.searchedAccounts.length > 0){
                        this.showErrorMessage(this.notFoundValidation,'warning','Warning');
                    }
                    this.totalRecords = this.searchedAccounts.length;
                    this.totalRecordsToDisplay = 'Total Records: '+ this.totalRecords;
                    this.paginationHelper();
                })
                .catch(error => {
                    this.error = error;
                    console.log('error' + JSON.stringify(error));
                })
        }
    }

    showErrorMessage(errorMsg,variant,title) {
        const evt = new ShowToastEvent({
            title: title,
            message: errorMsg,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    //Pagination Code**********
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }
    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }
    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }
    // JS function to handel pagination logic 
    paginationHelper() {
        this.recordsToDisplay = [];
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.searchedAccounts[i]);
        }
    }

}
