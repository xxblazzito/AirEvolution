List<product2> vuelos = [Select id from product2 Where Name NOT IN ('AE-0016','AE-0018','AE-0025','AE-0026','AE-0027','AE-0029','AE-0031')];
List<pricebookEntry> listadopreciosNegocios = new List<pricebookEntry>();
List<pricebookEntry> listadopreciosStandar = new List<pricebookEntry>();

for(product2 v: vuelos){
    Integer randomNumber1 = Integer.valueof((math.random() * 1000000));
    Integer randomNumber2 = Integer.valueof((math.random() * 1000000));
    pricebookEntry precios1 = new pricebookEntry(Pricebook2Id = '01s8a000002qqwJAAQ',Product2Id = v.id,UnitPrice=randomNumber1);
    listadopreciosStandar.add(precios1);
   
}
insert (listadopreciosStandar);


system.debug(vuelos);