public class ContactAndLeadSearch {
    public static List<List<sObject>> searchContactsAndLeads (String parametro)
    {
        List<List<sObject>> busquedaSOSL = [Find :parametro IN NAME FIELDS 
                                            RETURNING Contact(FirstName,LastName), Lead(FirstName,LastName)];
        Return busquedaSOSL;
    }
}