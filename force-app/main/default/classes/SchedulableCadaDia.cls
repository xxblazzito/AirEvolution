public with sharing class SchedulableCadaDia implements Schedulable{
    public void execute(SchedulableContext ctx) {

        FutureDiaAntes.validarVuelos();
        
    }
}
