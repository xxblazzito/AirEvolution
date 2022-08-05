@isTest
public class JuegoPPTTest {
    
    @isTest
    static void JugarTijeraYPapel(){
        JuegoPPT.respuestaJuego resultado = JuegoPPT.jugar('cristian',JuegoPPT.jugada.TIJERA,'Andres',JuegoPPT.jugada.PAPEL);

        system.assertEquals('Gana el jugador 1',resultado.mensaje);
    }

    @isTest
    static void JugarPapelYTijera(){
        JuegoPPT.respuestaJuego resultado = JuegoPPT.jugar('cristian',JuegoPPT.jugada.PAPEL,'Andres',JuegoPPT.jugada.TIJERA);

        system.assertEquals('Gana el jugador 2',resultado.mensaje);
    }

    @isTest
    static void JugarPapelYPiedra(){
        JuegoPPT.respuestaJuego resultado = JuegoPPT.jugar('cristian',JuegoPPT.jugada.PAPEL,'Andres',JuegoPPT.jugada.PIEDRA);

        system.assertEquals('Gana el jugador 1',resultado.mensaje);
    }

    @isTest
    static void JugarPiedraYPapel(){
        JuegoPPT.respuestaJuego resultado = JuegoPPT.jugar('cristian',JuegoPPT.jugada.PIEDRA,'Andres',JuegoPPT.jugada.PAPEL);

        system.assertEquals('Gana el jugador 2',resultado.mensaje);
    }

    @isTest
    static void JugarPiedraYTijera(){
        JuegoPPT.respuestaJuego resultado = JuegoPPT.jugar('cristian',JuegoPPT.jugada.PIEDRA,'Andres',JuegoPPT.jugada.TIJERA);

        system.assertEquals('Gana el jugador 1',resultado.mensaje);
    }

    @isTest
    static void JugarTijeraYPiedra(){
        JuegoPPT.respuestaJuego resultado = JuegoPPT.jugar('cristian',JuegoPPT.jugada.TIJERA,'Andres',JuegoPPT.jugada.PIEDRA);

        system.assertEquals('Gana el jugador 2',resultado.mensaje);
    }

    @isTest
    static void JugarEmpate(){
        JuegoPPT.respuestaJuego resultado = JuegoPPT.jugar('cristian',JuegoPPT.jugada.PIEDRA,'Andres',JuegoPPT.jugada.PIEDRA);

        system.assertEquals('Hubo un empate',resultado.mensaje);
    }

    @isTest
    static void JugarSinJugador(){
        try{
            JuegoPPT.respuestaJuego resultado = JuegoPPT.jugar(null,JuegoPPT.jugada.PIEDRA,'Andres',JuegoPPT.jugada.PIEDRA);
        }
        catch (Exception e){
            system.assertEquals('Debe ingresar los Jugadores',e.getMessage());
        }
    }

    @isTest
    static void JugarSinJugada(){
        try{
            JuegoPPT.respuestaJuego resultado = JuegoPPT.jugar('Cristian',null,'Andres',JuegoPPT.jugada.PIEDRA);
        }
        catch (Exception e){
            system.assertEquals('Debe ingresar la Jugada',e.getMessage());
        }
    }
}