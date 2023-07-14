import { LightningElement, api } from 'lwc';

export default class FirstCommunity extends LightningElement {

    @api buttonText;
 
    handleClick() {
        console.log("Button Clicked!");
    }


}