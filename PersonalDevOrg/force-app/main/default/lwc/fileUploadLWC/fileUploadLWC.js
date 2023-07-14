/* fileupload_aws_s3bucket.js */
/* eslint-disable no-console */
import { LightningElement, track, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import { loadScript } from "lightning/platformResourceLoader";
import AWSSDK from "@salesforce/resourceUrl/awskit";

export default class Fileupload_aws_s3bucket extends LightningElement {
  /*========= Start - variable declaration =========*/
  s3; //store AWS S3 object
  isAwsSdkInitialized = false; //flag to check if AWS SDK initialized
  @track awsSettngRecordId; //store record id of custom metadata type where AWS configurations are stored
  selectedFilesToUpload; //store selected file
  @track showSpinner = false; //used for when to show spinner
  @track fileName; //to display the selected file name

  /*========= End - variable declaration =========*/

  //Called after every render of the component. This lifecycle hook is specific to Lightning Web Components,
  //it isn’t from the HTML custom elements specification.
  renderedCallback() {
    if (this.isAwsSdkInitialized) {
      return;
    }
    loadScript(this, AWSSDK)
      .then(() => {
        //For demo, hard coded the Record Id. It can dynamically be passed the record id based upon use cases
        this.awsSettngRecordId = "m037F000000HS4Q";
      })
      .catch(error => {
        console.error("error -> " + error);
      });
  }

  //Using wire service getting AWS configuration from Custom Metadata type based upon record id passed

  @wire(getRecord, {
    recordId: "$awsSettngRecordId",
    fields: [
      "AWS_Setting__mdt.S3_Bucket_Name__c",
      "AWS_Setting__mdt.AWS_Access_Key_Id__c",
      "AWS_Setting__mdt.AWS_Secret_Access_Key__c",
      "AWS_Setting__mdt.S3_Region_Name__c"
    ]
  })
  awsConfigData({ error, data }) {
    if (data) {
      let awsS3MetadataConf = {};
      let currentData = data.fields;
      //console.log("AWS Conf ====> " + JSON.stringify(currentData));
      awsS3MetadataConf = {
        s3bucketName: 'prashant-rupnur-salesforce',//currentData.S3_Bucket_Name__c.value,
        awsAccessKeyId: 'AKIAIXRXLAZBXKAYQ4MA',//currentData.AWS_Access_Key_Id__c.value,
        awsSecretAccessKey: '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', //currentData.AWS_Secret_Access_Key__c.value,
        s3RegionName: 'us-east-1'//currentData.S3_Region_Name__c.value
      };
      this.initializeAwsSdk(awsS3MetadataConf); //Initializing AWS SDK based upon configuration data
    } else if (error) {
      console.error("error ====> " + JSON.stringify(error));
    }
  }

  //Initializing AWS SDK
  initializeAwsSdk(confData) {
    const AWS = window.AWS;
    AWS.config.update({
      accessKeyId: 'AKIAIXRXLAZBXKAYQ4MA',//confData.awsAccessKeyId, //Assigning access key id
      secretAccessKey: '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'//confData.awsSecretAccessKey //Assigning secret access key
    });

    AWS.config.region = 'us-east-1'//confData.s3RegionName; //Assigning region of S3 bucket

    this.s3 = new AWS.S3({
      apiVersion: "2006-03-01",
      params: {
        Bucket: 'prashant-rupnur-salesforce'//confData.s3bucketName //Assigning S3 bucket name
      }
    });
    this.isAwsSdkInitialized = true;
  }

  //get the file name from user's selection
  handleSelectedFiles(event) {
    if (event.target.files.length > 0) {
      this.selectedFilesToUpload = event.target.files[0];
      this.fileName = event.target.files[0].name;
      console.log("fileName ====> " + this.fileName);    }
  }

  //file upload to AWS S3 bucket
  uploadToAWS() {
    if (this.selectedFilesToUpload) {
      this.showSpinner = true;
      let objKey = this.selectedFilesToUpload.name
        .replace(/\s+/g, "_") //each space character is being replaced with _
        .toLowerCase();

      //starting file upload
      this.s3.putObject(
        {
          Key: objKey,
          ContentType: this.selectedFilesToUpload.type,
          Body: this.selectedFilesToUpload,
          ACL: "public-read"
        },
        err => {
          if (err) {
            this.showSpinner = false;
            console.error(err);
          } else {
            this.showSpinner = false;
            console.log("Success");
            this.listS3Objects();
          }
        }
      );
    }
  }

  //listing all stored documents from S3 bucket
  listS3Objects() {
    //console.log("AWS -> " + JSON.stringify(this.s3));
    this.s3.listObjects((err, data) => {
      if (err) {
        console.log("Error", err);
      } else {
        console.log("Success", data);
      }
    });
  }
}