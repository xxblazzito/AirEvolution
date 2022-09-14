public abstract class Contacto {
    string nombre {get;set;}
    string apellido {get;set;}
    string tipoIdentificacion {get;set;}
    string nroIdentificacion {get;set;}
    string nroPasaporte {get;set;} 
    string nacionalidad {get;set;}
    date fechaNacimiento {get;set;}
    
    void crearContacto(Contact contacto){
        nombre = contacto.firstName;
        apellido = contacto.LastName;
        tipoIdentificacion = contacto.Tipo_de_Identificacion__c;
        nroIdentificacion = contacto.Numero_de_Identificacion__c;
        nroPasaporte = contacto.Numero_de_pasaporte__c;
        nacionalidad = contacto.Nacionalidad__c;
        fechaNacimiento = contacto.ffecha_de_nacimiento__c;
    }
}