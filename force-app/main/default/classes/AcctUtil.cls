public with sharing class AcctUtil {

public static void setAccountTypeToProspect(List<Account> accounts) {
    for (Account acc : accounts) {
        if (acc.Type == null) {
            acc.Type = 'Prospect';
        }
    }
}

public static void copyAccountShippingToBillingAdd(List<Account> accounts){
    for (Account acc : accounts) {
        if(acc.ShippingStreet != null) {
            acc.BillingStreet = acc.ShippingStreet;}
        if(acc.ShippingCity != null) {
            acc.BillingCity = acc.ShippingCity;}
        if(acc.ShippingState != null) {
            acc.BillingState = acc.ShippingState;}
        if(acc.ShippingPostalCode != null) {
            acc.BillingPostalCode = acc.ShippingPostalCode;}
        if(acc.ShippingCountry != null) {
            acc.BillingCountry = acc.ShippingCountry;}
    }
}

public static void setAccountRatingHot (List<Account> accounts) {
    for (Account acc : accounts) {    
        if(acc.Phone != null && acc.Website != null && acc.Fax != null) {
         acc.Rating = 'Hot';
        }
    }
}

public static void setAccountDefaultContact(List<Account> accounts){
    List<Contact> contactsToInsert = new List<Contact>();
    for (Account acc : accounts) { 
        Contact defaultContact = new Contact();
        defaultContact.LastName = 'DefaultContact';
        defaultContact.Email = 'default@email.com';                    
        defaultContact.AccountId = acc.Id;
        contactsToInsert.add(defaultContact);
    }
    insert contactsToInsert;
}

} //end of AcctUtil class

