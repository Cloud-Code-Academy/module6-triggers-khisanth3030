public with sharing class OppUtil {

    public static void afterUpdate(List<Opportunity> opps,Map<Id, Opportunity> oppsOld){

        amountValidate(opps);

        setPrimaryContact(opps);

    }

    public static void amountValidate(List<Opportunity> opps){
        for (Opportunity opp : opps) {    
            if(opp.Amount == null){break;} else       
                if (opp.Amount != null && opp.Amount <= 5000) {
                    opp.addError('Opportunity amount must be greater than 5000');
                }     
        }
    }

    public static void deleteClosedWonOpp(List<Opportunity> oppsOld){
     // Get Account Industry for all opportunities
     Map<Id, String> accountIndustryMap = new Map<Id, String>();
     for(Account acc : [SELECT Id, Industry FROM Account WHERE Id IN 
                        (SELECT AccountId FROM Opportunity WHERE Id IN :oppsOld)]) {
         accountIndustryMap.put(acc.Id, acc.Industry);
     }
     
     for (Opportunity opp : oppsOld) {
         String industry = accountIndustryMap.get(opp.AccountId);
         if (opp.StageName == 'Closed Won' && industry == 'Banking') {
             opp.addError('Cannot delete closed opportunity for a banking account that is won');
         }
     }
 }
    

    public static void setPrimaryContact(List<Opportunity> opps){
        List<Contact> contacts = [SELECT Id, FirstName, Title, AccountId FROM Contact WHERE Title = 'CEO' AND AccountId IN (SELECT AccountId FROM Opportunity WHERE Id IN : opps)];

        System.debug('Contact List Size: ' + contacts.size());
        System.debug('Contact List: ' + contacts);		

		// Loop through each Contact and add the Account Id and Contact to the map
		Map<Id, Contact> contactMap = new Map<Id, Contact>();
		for (Contact con : contacts) {
            System.debug('Contact Id: ' + con.Id);
            System.debug('Contact First Name: ' + con.FirstName);
            System.debug('Contact Title: ' + con.Title);
            System.debug('Contact Account Id: ' + con.AccountId);
			contactMap.put(con.AccountId, con);
			}		
		// Loop through each Opportunity
        for (Opportunity opp : opps) {
            System.debug('Opportunity Account Id: ' + opp.AccountId);
            if(contactMap.containsKey(opp.AccountId)) {
                Contact con = contactMap.get(opp.AccountId);
                System.debug('Contact Map Value: ' + contactMap.get(opp.AccountId));
                System.debug('Opportunity Primary Contact: ' + opp.Primary_Contact__c);
                System.debug('Opportunity Id: ' + opp.Id);            
                opp.Primary_Contact__c = con.Id;
            }else{opp.Primary_Contact__c = null;}
        }
}

    public static List<Opportunity> 
    getOpportunityDetailsForClosedWon(List<Opportunity> opps) {
		List<Opportunity> result = [
        SELECT Id, Name, Amount, CloseDate, StageName, Account.Industry  
        FROM Opportunity WHERE StageName = 'Closed Won' 
        AND Account.Industry = 'Banking'];
        System.debug('Result: ' + result);
		return result; 
	}

} //end of OppUtil class