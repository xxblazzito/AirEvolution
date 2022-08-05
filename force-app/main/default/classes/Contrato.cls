public with sharing class Contrato {
    public static Contract evaluarContrato(Contract contrato)    {
    Date mydate = contrato.startDate;
    integer duracion ;
    integer year = mydate.year();
    integer mes = mydate.month();
    integer descuento;
    decimal valortotal;
    decimal valortcontrato=contrato.Valor_Contrato__c;
    if(mes>=1 && mes<=3){
        duracion =6;
        
    }
    else if(mes>=4 && mes<=9) {
        duracion =3;
    }
    else{
        duracion =1;
        valortotal = valortcontrato - valortcontrato*0.15;
    }
    if(mydate>Date.newInstance(year, 12, 20) && mydate<Date.newInstance(year+1,1,15)){
        throw new contratoException('fecha invalida');
    }
    
    contrato.ContractTerm = duracion;
    contrato.Valor_Total__c = valortotal;
    database.saveresult resultadito = database.insert(contrato,false);
    return contrato;
    
    }
    
    
    public class contratoException extends Exception {}
}