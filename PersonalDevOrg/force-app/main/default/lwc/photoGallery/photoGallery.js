import { LightningElement, api, track, wire } from 'lwc';
import { loadScript } from "lightning/platformResourceLoader";
import AWS_SDK from "@salesforce/resourceUrl/awskit";
import getConfigAndIntegrationData from '@salesforce/apex/PhotoGalleryUtility.getConfigAndIntegrationData';
import { updateAWSConfig, getPhotosForAlbum } from 'c/awsLibrary';
//import { RecordUtil } from 'c/util';
//import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
//import DISPLAY_CAPTION_FIELD from '@salesforce/schema/Photo_Album__c.Display_Captions__c';
//import NAME_FIELD from '@salesforce/schema/Photo_Album__c.Name';

const RESIZED_PREFIX = 'resized-';  // Prefix to use for retrieving thumbnail folder

export default class PhotoGallery extends LightningElement {
    /* Exposed properties */
    @api recordId;                  //Album name is based on photo album record id
    @api limitPhotos;               //Number of photos to load per page - For pagiation implementation
    photoAlbumName = 'Amazon S3 POC';

    /* Collection Reactive properties */
    @track thumbnailPhotoList = []; //Used to store thumbnail sized photos retrieved from AWS.
    @track fullPhotoList = [];      //Used to store full sized photos retrieved from AWS.
    @track listOfPhotos = [];       //Used to store current set of photos to display - Depends on pagination size.
    @track combinedPhotoList = [];  //Used to store combined list of thumbanils and full size photo details.

    /* Private reactive properties */
    modalVisibility = false;        //Visibility of photo modal
    awsSdkInitialised = false;      //Status of AWS library
    awsIntConfig;                   //Configuration settings from custom settings
    isLoaded = false;               //Display Spinner
    currentPage = 1;                //current page
    numberOfPages = 1;              //calculates the total number of pages
    navigationButtonState = {       //State of pagination buttons
        firstPage: true,
        nextPage: false,
        prevPage: true,
        lastPage: false,
    };
    error;                          //Error captured
    
    get listOfPhotosSize(){
        return this.listOfPhotos.length;
    }

    //Load AWS library
    connectedCallback(){
        //Convert 15 digit record it to 18 digit
        //this.recordId = RecordUtil.convertSalesforceId15to18(this.recordId);
        //Initilize AWS and callouts aws for thumbnails and full photo details 
        console.log('this.awsSdkInitialised'+this.awsSdkInitialised);
        console.log('this.recordId'+this.recordId);
        if (this.awsSdkInitialised && this.recordId === undefined) {
            return;
        }else{
            loadScript(this, AWS_SDK)
            .then(() => {
                /* Wait for AWS Library to load + Custom setting record before making callout to AWS */
                if(this.awsIntConfig){
                    this.requestData();
                }
                this.awsSdkInitialised = true;
            })
        }
    }

    /*@wire(getRecord, { recordId: '$recordId', fields: [], optionalFields: [DISPLAY_CAPTION_FIELD, NAME_FIELD] })
    photoAlbum;

    get isDisplayPhotoCaptionEnabled() {
        return getFieldValue(this.photoAlbum.data, DISPLAY_CAPTION_FIELD)!=undefined?getFieldValue(this.photoAlbum.data, DISPLAY_CAPTION_FIELD):false;
    }

    get photoAlbumName(  {
        return getFieldValue(this.photoAlbum.data, NAME_FIELD)!=undefined?getFieldValue(this.photoAlbum.data, NAME_FIELD):'';
    }*/
    
    //Retrieve integration configuration record from custom setting - Temp variable is used to make wire method reactive
    @wire(getConfigAndIntegrationData, { isRecordIdAvailable: '$recordId'} )
    wireIntegrationConfig ({error, data}) {
        if(data) {
            this.awsIntConfig = data;
            console.log('this.awsIntConfig '+JSON.stringify(this.awsIntConfig) );
            /* Wait for AWS Library to load + Custom setting record before making callout to AWS */
            if (window.AWS) {
                this.requestData();
            }
        }else if(error) {
            this.error = error;
            console.error(`Error retrieving photo gallery configuration settings.`);
        }  
    }

    requestData(){
        console.log('Inside RequestData');
        if(this.awsIntConfig && this.awsIntConfig.awsCredentials && this.awsIntConfig.awsCredentials.result){
            console.log('Inside RequestData if');
            this.initilizeAWSLibrary();
            //this.getThumbnailPhotos();
            this.getFullPhotos();
        }else if(data.awsCredentials.error){
            this.error = data.awsCredentials.error;
            console.error(`Error occurred = > ${data.awsCredentials.error}`);
        }
    }

    //Retrieve full size photos from AWS for album
    getFullPhotos(){
        this.getPhotosForAlbum(this.awsIntConfig.awsBucketName, this.awsIntConfig.awsObjectAPIVersion)
        .then(result => {
            console.log('Inside getFullPhotos result'+JSON.stringify(result));
            this.fullPhotoList = result;
            if (this.fullPhotoList.length>0) {
                this.combinePhotoLists();   
            }
            this.isLoaded = true;
        }).catch(err => {
            this.error = err;
            this.isLoaded = true;
            console.error(`Error Retrieving Full Sized Photos = >${err}`);
        });
    }

    //Retrieve thumbnail size photos from AWS for album
    /*getThumbnailPhotos(){
        this.getPhotosForAlbum(this.awsIntConfig.awsThumbnailBucketName, RESIZED_PREFIX+this.recordId, this.awsIntConfig.awsObjectAPIVersion)
        .then(result => {
            this.thumbnailPhotoList = result;
            if (this.thumbnailPhotoList.length>0 && this.fullPhotoList.length>0) {
                this.combinePhotoLists();   
            }
            this.isLoaded = true;
        }).catch(err => {
            this.error = err;
            this.isLoaded = true;
            console.error(`Error Retrieving Thumbnail Photos = >${err}`);
        });
    }*/

    //Merge thumbnail list and full photo list to generate combined list for iteration
    combinePhotoLists(){
        try{
            
                this.combinedPhotoList = [...this.fullPhotoList];
            
            this.initilizeGallery();
            this.isLoaded = true;
        }catch(err){
            this.error = err;
            this.isLoaded = true;
            console.error(`Error in Processing Photos =>${err}`);
        }
    }

    //Initilize AWS object with integration configuration from custom setting
    initilizeAWSLibrary() {
        console.log('Inside initilizeAWSLibrary');
        if (this.awsIntConfig.awsBucketRegion && this.awsIntConfig.awsCredentials.result) {
            updateAWSConfig(this.awsIntConfig.awsBucketRegion, this.awsIntConfig.awsCredential, this.awsIntConfig.awsCredentials.result);   
        }
    }
    
    //Callout to AWS to retrieve photos for album. Returns promise if not resolved at first place.
    async getPhotosForAlbum(bucketName, awsObjectAPIVersion){
        let photoList = [];
        if (bucketName) {
            await getPhotosForAlbum(bucketName, awsObjectAPIVersion).then((data) => {
                photoList = data;
            });
        }
        return photoList;
    }

    /* Methods for Photo Gallery */

    //Close photo modal
    closeModal(event){
        this.modalVisibility = false;
        this.currentPhoto = {};
    }

    //Capture photo key (photo name retrieved from AWS) and find in current list of photos.
    handlePhotoClick(event){
        if (event.currentTarget.dataset.id) {
            this.currentPhoto = this.listOfPhotos[event.currentTarget.dataset.id];   
            this.modalVisibility = true;
        }
    }

    /* Methods to Initilize and action Gallery Navigation */
    
    //Calculate pagination parameters like total number of pages and load current list of photos from combined list of photos.
    initilizeGallery(){
        this.numberOfPages = Math.ceil(this.combinedPhotoList.length / this.limitPhotos);
        this.loadList();
    }

    //Navigate to first page and load current list of photos from combined list of photos.
    firstPage() {
        this.currentPage = 1;
        this.loadList();
    }

    //Navigate to next page and load current list of photos from combined list of photos.
    nextPage() {
        this.currentPage += 1;
        this.loadList();
    }

    //Navigate to previous page and load current list of photos from combined list of photos.
    previousPage() {
        this.currentPage -= 1;
        this.loadList();
    }

    //Navigate to last page and load current list of photos from combined list of photos.
    lastPage() {
        this.currentPage = this.numberOfPages;
        this.loadList();
    }

    //Load current list of photos from combined list of photos based on pagination parameters.
    loadList() {
        let begin = ((this.currentPage - 1) * this.limitPhotos);
        let end = begin + this.limitPhotos;
        
        this.listOfPhotos = this.combinedPhotoList.slice(begin, end);
        this.initilizeButtonState();        // determines the states of the pagination buttons
    }

    //Re-initilize navigation buttons to disable/enable button state based on pagination parameters.
    initilizeButtonState() {
        this.navigationButtonState.firstPage = this.currentPage == 1 ? true : false;
        this.navigationButtonState.lastPage = this.currentPage == this.numberOfPages ? true : false;
        this.navigationButtonState.nextPage = this.currentPage == this.numberOfPages ? true : false;
        this.navigationButtonState.prevPage = this.currentPage == 1 ? true : false;
    }
}