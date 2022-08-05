@IsTest
public class DescuentoTest {
    @TestSetup
    static void makeData() {   
        contact clienteRecurrente = new Contact(firstname = 'Robby', lastname = 'Rotten' ,Tipo_de_Identificacion__c ='Cedula de Ciudadania',
                                                Numero_de_Identificacion__c='10407586324');
        insert clienteRecurrente;
    }

    @IsTest
    static void dctoClienteRecurrenteTC(){
        contact cliente = [select id, Tipo_de_Identificacion__c, Numero_de_Identificacion__c from contact LIMIT 1 ];

        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, descuento.metodo.TC,100);

        system.assert(respuesta.resultado);
        system.assertEquals(80, respuesta.valorConDcto);
        system.assert(respuesta.mensaje.contains(string.valueOf(descuento.metodo.TC)));

    }

    @IsTest
    static void dctoClienteRecurrenteEFECTIVO(){
        contact cliente = [select id, Tipo_de_Identificacion__c, Numero_de_Identificacion__c from contact LIMIT 1 ];

        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, descuento.metodo.EFECTIVO,100);

        system.assert(respuesta.resultado);
        system.assertEquals(70, respuesta.valorConDcto);
        system.assert(respuesta.mensaje.contains(string.valueOf(descuento.metodo.EFECTIVO)));

    }
    @IsTest
    static void dctoClienteNuevoTC(){
        contact cliente = new contact (lastName='joseftorudo',Tipo_de_Identificacion__c='Cedula de Ciudadania',Numero_de_Identificacion__c='741522222');

        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, descuento.metodo.TC,100);

        system.assert(respuesta.resultado);
        system.assertEquals(85, respuesta.valorConDcto);
        system.assert(respuesta.mensaje.contains(string.valueOf(descuento.metodo.TC)));

    }
    @IsTest
    static void dctoClienteNuevoEFECTIVO(){
        contact cliente = new contact (lastName='katerinah',Tipo_de_Identificacion__c='Cedula de Ciudadania',Numero_de_Identificacion__c='75365214000');

        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, descuento.metodo.EFECTIVO,100);

        system.assert(respuesta.resultado);
        system.assertEquals(85, respuesta.valorConDcto);
        system.assert(respuesta.mensaje.contains(string.valueOf(descuento.metodo.EFECTIVO)));

    }
    @IsTest
    static void dctoClienteSinApellido(){
        try{
            contact cliente = new contact (Tipo_de_Identificacion__c='Cedula de Ciudadania',Numero_de_Identificacion__c='741522222');

        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, descuento.metodo.EFECTIVO,100);
        }
        catch(Exception e){
            system.assertEquals('Ocurrio un error en la inserción',e.getMessage());
        }

        

    }
    @IsTest
    static void dctoClienteSinValor(){
        try{
            contact cliente = [select id, Tipo_de_Identificacion__c, Numero_de_Identificacion__c from contact LIMIT 1 ];

        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, descuento.metodo.EFECTIVO,null);
        }
        catch(Exception e){
            system.assertEquals('Ocurrio un error no esperado',e.getMessage());
        }

        

    }

    @IsTest
    static void dctoClienteSinCliente(){
        try{
            contact cliente = new contact(firstname = 'Robby', lastname = 'Rotten' ,Tipo_de_Identificacion__c ='Cedula de Ciudadania',
            Numero_de_Identificacion__c='10407586324') ;

        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, descuento.metodo.EFECTIVO,100);
        }
        catch(Exception e){
            system.assertEquals('Ocurrio un error no esperado',e.getMessage());
        }

        

    }

    @IsTest
    static void dctoClienteSinMetodoPago(){
        try{
            contact cliente = [select id, Tipo_de_Identificacion__c, Numero_de_Identificacion__c from contact LIMIT 1 ];

        Descuento.respuestaDcto respuesta = Descuento.aplicarDescuento(cliente, null,100);
        }
        catch(Exception e){
            system.assertEquals('El método de pago no corresponde',e.getMessage());
        }

        

    }
}