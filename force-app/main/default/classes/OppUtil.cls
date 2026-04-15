public with sharing class OppUtil {

    public static void amountValidate(List<Opportunity> opps){
        for (Opportunity opp : opps) {           
                if (opp.Amount != null && opp.Amount <= 5000) {
                    opp.addError('Opportunity amount must be greater than 5000');
                }     
        }
    }

    public static void setPrimaryContact(List<Opportunity> opps){
        for (Opportunity opp : opps) {

        }
    }

    public static void deleteClosedWonOpp(List<Opportunity> oppsOld){
        for (Opportunity opp : oppsOld) {
            System.debug('Account Industry: ' + opp.Account.Industry);
            System.debug('Opportunity StageName: ' + opp.StageName);
            System.debug('Opportunity Id: ' + opp.Id);
             
            if (opp.StageName == 'Closed Won' /*&& opp.Account.Industry == 'Banking'*/) {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }

} //end of OppUtil class