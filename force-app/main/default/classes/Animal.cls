public class Animal {
    public enum especie {Pollo, Perro,Gato}
    Integer numPatas;
    public String color{get;set;}
    Boolean esDomestico;
    public Double edad{get;set;}
    especie Tipo;
    String Nombre;
    
    public Animal(Integer numPatas,String nombre, String color, Boolean esDomestico, especie Tipo){
        this.numPatas=numPatas;
        this.color=color;
        this.esDomestico=esDomestico;
        this.nacer();
        this.nombre=nombre;
        this.tipo=tipo;  
    }
    
    public string hablar(){
        switch on Tipo
        {
            when Perro
            {
                return 'Woof Woof Woof';
            }
            when Gato
            {
                return 'Meow ';
                
            }
            when Pollo
            {
                return 'Pio Pio Pio';
            }
            When else
            {
                return 'es mudo';
            }
        }
        
    }
    
    public boolean comer(){
        Return False;
    }
    
    public boolean comer(String comida){
        if(comida != null)
        {
            Return True;
        }
        Return False;
    }
    
    public string darMedalla(integer place){
    	String medalColor;
    
    	Switch on place{
            when 1{
                medalColor='Gold';
           	}
            when 2{
                medalColor='Silver';
            }
            when 3{
                medalColor='Bronze';
            }
            when else{
                medalColor=null;
            }
                
            }
        return medalColor;
    }
    
    public void nacer(){
        edad =0;
    }
    
    public double crecer(){
        edad +=0.1;
        return edad;
        
    }
}