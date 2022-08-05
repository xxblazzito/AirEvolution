public with sharing class JuegoPPT {
    public enum jugada{PIEDRA,PAPEL,TIJERA}
    string jugador;
    
    
    public static respuestaJuego Jugar(String player1,jugada mov1,String player2,Jugada mov2){
        
        respuestaJuego resultado = new respuestaJuego();
        try{
            if(string.isEmpty(player1) || string.isEmpty(player2) ){
                throw new juegoException();
            }
            if(mov1 == null || mov2 == null){
                throw new juego2Exception();
            }
            
            if(mov1 == jugada.TIJERA && mov2 == jugada.PAPEL){
                
                resultado.mensaje = 'Gana el jugador 1';
                
            }else if(mov1 == jugada.PAPEL && mov2 == jugada.TIJERA){
                resultado.mensaje = 'Gana el jugador 2';
            }
            else if(mov1 == jugada.PAPEL && mov2 == jugada.PIEDRA){
                resultado.mensaje = 'Gana el jugador 1';
            }
            else if(mov1 == jugada.PIEDRA && mov2 == jugada.PAPEL){
                resultado.mensaje = 'Gana el jugador 2';
            }
            else if(mov1 == jugada.PIEDRA && mov2 == jugada.TIJERA){
                resultado.mensaje = 'Gana el jugador 1';
            }
            else if(mov1 == jugada.TIJERA && mov2 == jugada.PIEDRA){
                resultado.mensaje = 'Gana el jugador 2';
            }
            else{
            resultado.mensaje = 'Hubo un empate';
            }
            

        }
        catch(juegoException e){
            throw new juegoException('Debe ingresar los Jugadores',e);
        }
         catch(juego2Exception e){
            throw new juego2Exception('Debe ingresar la Jugada',e);
         }
        catch(Exception e){
            throw new juegoException('Ha ocurrido un error no esperado ',e);
        }
        return resultado;

        
    }
    public class respuestaJuego{
    
        public string mensaje;
    }
    public class juegoException extends Exception {}
    public class juego2Exception extends Exception {}
}