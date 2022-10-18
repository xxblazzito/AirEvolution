public with sharing class convertLetras {
    public static string convertirLetra(Integer numero){
        List<string> letras = new List<string>{null,'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
        if(numero != null){
            if(numero <= 26){
                return letras[numero];
            }else{
                return 'Error';
            }
        }else{
            return 'Error, numero vacio';
        }
    }
}
