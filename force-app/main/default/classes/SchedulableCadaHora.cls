public with sharing class SchedulableCadaHora implements Schedulable{
    public void execute(SchedulableContext ctx) {

    FutureCadaHora.validarVuelos();
    FutureCadaHora.validarReservaPagada();
    }
}
