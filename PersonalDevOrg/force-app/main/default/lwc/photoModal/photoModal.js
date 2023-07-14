import { LightningElement, api } from 'lwc';

export default class PhotoModal extends LightningElement {
    @api currentPhoto = {};
    @api listOfPhotos = [];
    @api displayCaption = false;
    currentIndex = -1;
    isLoaded = false;

    connectedCallback(){
        this.currentIndex = this.listOfPhotos.indexOf(this.currentPhoto);
    }

    get photoCountText(){
        return `${this.currentIndex+1}` + ' / '+ `${this.listOfPhotos.length}`;
    }

    get getPhotoCaption(){
        return this.currentPhoto.name?this.currentPhoto.name.replace(/\.[^/.]+$/, ''):'';
    }

    handlePhotoClick(event){
        this.currentIndex = parseInt(event.currentTarget.dataset.id, 10);
        this.currentPhoto = this.listOfPhotos[this.currentIndex];
    }

    closeModal(){
        this.dispatchEvent(new CustomEvent('closemodal', { detail: ''}));
    }

    handleImgLoad(){
        this.isLoaded = true;
        let ImgElement = this.template.querySelector('.full-image');
        if (ImgElement) {
            ImgElement.classList.remove('slds-hide');   
        }
    }

    handleNext(){
        let currentIndex = parseInt(this.currentIndex, 10);
        let nextIndex = currentIndex + 1;
        let index = nextIndex <= this.listOfPhotos.length-1?nextIndex:currentIndex;
        this.currentPhoto = this.listOfPhotos[index];
        this.currentIndex = index;
    }

    handlePrev(){
        let currentIndex = parseInt(this.currentIndex, 10);
        let prevIndex = currentIndex - 1;
        let index = prevIndex >= 0?prevIndex:currentIndex;
        this.currentPhoto = this.listOfPhotos[index];
        this.currentIndex = index;
    }

    sharePhoto(){
        if(this.currentPhoto.fullPhotoUrl){
            //Create temporary input element for URL value.
            let inputEle = document.createElement("input");
            inputEle.setAttribute("value", this.currentPhoto.fullPhotoUrl);

            //Set design parameters to completely hide temp input element.
            inputEle.style.position = 'fixed';
            inputEle.style.top = '-5rem'; 
            inputEle.style.height = '1px';
            inputEle.style.width = '10px;';

            document.body.appendChild(inputEle);        // append element to document body.    
            inputEle.select();                          // selects all the text  in an < input > element that includes a text field.
            document.execCommand("copy");               // Copies the current selection to the clipboard.
            document.body.removeChild(inputEle);        // Delete temporary input element.

        }
    }
}