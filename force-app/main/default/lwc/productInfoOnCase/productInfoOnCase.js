import { LightningElement, api, wire } from 'lwc';
import getProductInfoFromMetadata from '@salesforce/apex/ProductInfoController.getProductInfoFromMetadata';

export default class ProductInfoOnCase extends LightningElement {
    @api recordId;  // Case Id passed automatically on Case layout
    productData;

    @wire(getProductInfoFromMetadata, { caseId: '$recordId' })
    wiredProductInfo({ error, data }) {
        if (data) {
            this.productData = data;
        } else if (error) {
            console.error('Error fetching product information', error);
        }
    }

    get costPerMonth() {
        return this.productData ? this.productData.Cost : 'N/A';
    }

    get atmFee() {
        return this.productData ? this.productData.ATMFee : 'N/A';
    }

    get replacementCost() {
        return this.productData ? this.productData.ReplacementCost : 'N/A';
    }
}
