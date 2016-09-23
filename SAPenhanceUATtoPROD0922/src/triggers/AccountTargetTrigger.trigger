trigger AccountTargetTrigger on US_Account_Target__c (After insert, After update, Before insert, before update) {


if(Trigger.isBefore){

	for(US_Account_Target__c at : Trigger.new){
		if(at.Brand_Package__c != null){
			if(at.Brand_Package__c == 'FLEX FLAVOR')
				at.sku__c = 'FLEX';		
			else if(at.Brand_Package__c.startswith('BDL/BUD/MUL '))
				at.sku__c = 'ALUM';
		}					
	}
}

if(Trigger.isAfter){
	set<id> setATPs = new set<id>(); 

	for(US_Account_Target__c at : Trigger.new){
		setATPs.add(at.Account_Target_Program__c);
	}

	list<US_Account_Target_Program__c> uThese = [SELECT id, SAP_Color_Indicator__c, SAP_Color_Indicator_Num__c  from US_Account_Target_Program__c where id in :setATPs];

	

	for(US_Account_Target_Program__c uThis :uThese){
		system.debug('uThis.SAP_Color_Indicator__c = ' + uThis.SAP_Color_Indicator__c);
		system.debug('uThis.SAP_Color_Indicator_Num__c = ' + uThis.SAP_Color_Indicator_Num__c);
		uThis.SAP_Color_Indicator_Num__c = uThis.SAP_Color_Indicator__c;
	}

	update uThese;
}//after
}