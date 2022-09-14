public class ProbandoApexDinamico {
    
    public static Set<String> getSObjectFields(String sObjectName) {

    // * Initializing fieldNames set
    Set<String> fieldNames = new Set<String>();

    // * Getting metadata of all sObjects
    Map<String, Schema.SObjectType> sObjectMap = Schema.getGlobalDescribe();

    // * Getting the reference to current sObject
    Schema.SObjectType sObjectTypeInstance = sObjectMap.get(sObjectName);

    if(sObjectTypeInstance!=null) {

        // * Getting Fields for current sObject
        Map<String, Schema.SObjectField> fieldMap = sObjectTypeInstance.getDescribe().fields.getMap();

        // * Checking each field one by one, if it's accessible, adding it's name to fieldNames set
        for(Schema.SObjectField field: fieldMap.values()) {
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
            if(fieldResult.isAccessible()) {
                fieldNames.add(fieldResult.getName());
            }
        }
    }

    // * Returning the fieldNames set
    return fieldNames;
}
    
	public static String obtenerNombre(String objectName, String nombre) {

    // * Getting the field names using the object name
    Set<String> fieldNames = getSObjectFields(objectName);
    string name = nombre;
    
    // * Forming the SOQL query
    String query = 'SELECT ';
    for(String fieldName : fieldNames) {
        query += fieldName + ', ';
    }
    
    // * Removing last , from the SOQL query string
    query = query.substring(0, query.lastIndexof(','));
    
    // * Adding the object name to the SOQL
    query += ' FROM ' + objectName + ' Where Name Like =: name';
    
    // * Returning the SOQL
    return query;
}
}