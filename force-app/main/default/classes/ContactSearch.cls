public class ContactSearch {
    public static List<Contact> searchForContacts(string apellido, string codigopostal)
    {
        List<Contact> consulta = [SELECT Name, Id FROM Contact 
                     WHERE LastName = :apellido AND MailingPostalCode = :codigopostal];
        Return consulta;
    }
}