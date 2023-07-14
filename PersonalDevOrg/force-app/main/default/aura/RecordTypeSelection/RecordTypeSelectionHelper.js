({

    /*

     * This methid takes recordTypeId and entityTypeName parameters

     * and invoke standard force:createRecord event to create record

     * if recordTypeIs is blank, this will create record under master recordType

     * */

    showCreateRecordModal : function(component, recordTypeId, entityApiName) {

        var createRecordEvent = $A.get("e.force:createRecord");

        if(createRecordEvent){ //checking if the event is supported

            if(recordTypeId){//if recordTypeId is supplied, then set recordTypeId parameter
				if(component.get('v.recordId').startsWith('003') || component.get('v.recordId').startsWith('00Q')){
					createRecordEvent.setParams({

						"entityApiName": entityApiName,

						"recordTypeId": recordTypeId,

						"defaultFieldValues": {

							'WhoId': component.get('v.recordId'),
							'Status': 'Completed'

						}

						

					});
				}else{
					createRecordEvent.setParams({

						"entityApiName": entityApiName,

						"recordTypeId": recordTypeId,

						"defaultFieldValues": {

							'WhatId': component.get('v.recordId'),
							'Status': 'Completed'

						}

						

					});
				}

            } else{//else create record under master recordType
				if(component.get('v.recordId').startsWith('003') || component.get('v.recordId').startsWith('00Q')){
                createRecordEvent.setParams({

                    "entityApiName": entityApiName,

                    "defaultFieldValues": {

                        'WhoId': component.get('v.recordId'),
                        'Status': 'Completed'

                    }

                });
				
				}else{
					createRecordEvent.setParams({

						"entityApiName": entityApiName,

						"defaultFieldValues": {

							'WhatId': component.get('v.recordId'),
							'Status': 'Completed'

						}

					});
				}

            }

            createRecordEvent.fire();

        } else{

            alert('This event is not supported');

        }

    },

    

    /*

     * closing quickAction modal window

     * */

    closeModal : function(){

        var closeEvent = $A.get("e.force:closeQuickAction");

        if(closeEvent){

        closeEvent.fire();

        } else{

            alert('force:closeQuickAction event is not supported in this Ligthning Context');

        }

    },

})