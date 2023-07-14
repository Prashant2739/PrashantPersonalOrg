import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class FileUploadValidationCmp extends LightningElement {
		@track file;
    @track isUploading = false;
    
    handleFileChange(event) {
        this.file = event.target.files[0];
    }

    handleUpload() {
        if (this.file) {
            if (this.file.size <= 10000000 && this.file.type === 'application/pdf') {
                this.isUploading = true;
                // Perform upload logic here
            } else {
                const toastEvent = new ShowToastEvent({
                    title: 'Error',
                    message: 'File must be a PDF and must not exceed 10MB',
                    variant: 'error'
                });
                this.dispatchEvent(toastEvent);
            }
        }
    }
}