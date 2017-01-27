/*Author: Bharat*/
/*Description: Trigger to execute batch classes AB_Batch_Acc_SalesVolume,AB_Batch_Route_SalesVolume
               To get sales volume deshboard data*/
/*Created Date: 1/18/2017               */
/* Test Class :  AB_Batch_Acc_SalesVolume_Test*/

trigger AB_SVolumeBatches_Execution_Trg on EventLog__c (after insert) {
        
    for(EventLog__c objEvt : trigger.new){
        if(objEvt.Application__c == 'Mob360' && objEvt.Event__c  == 'AccountActualVolumeLoaded'){
            //BatchClass AB_Batch_Acc_SalesVolume = new BatchClass();
            Database.executeBatch(new AB_Batch_Acc_SalesVolume(),200);
            Database.executeBatch(new AB_Batch_Route_SalesVolume(),200);
        }
    }
    
}