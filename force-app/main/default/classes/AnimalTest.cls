@isTest
public class AnimalTest {
	
    @isTest
    private static void animalHablar(){
        Animal mascota = new Animal (4,'Komi','Vaquita',True,Animal.especie.Gato);
        
        system.assert(mascota.hablar().contains('Meow'));
    }
    
    @isTest
    private static void animalCrecer(){
        Animal mascota = new Animal (4,'Komi','Vaquita',True,Animal.especie.Gato);
        mascota.crecer();
        system.assertEquals(0.1, mascota.edad);
    }
    
    @isTest
    private static void animalComerComida(){
        Animal mascota = new Animal (4,'Komi','Vaquita',True,Animal.especie.Gato);
        
        system.assert(mascota.comer('cuido'));
    }
    
    @isTest
    private static void animalDarMedalla1(){
        Animal mascota = new Animal (4,'Komi','Vaquita',True,Animal.especie.Gato);
        
        system.assert(mascota.darMedalla(1).contains('Gold'));
    }
    
    @isTest
    private static void animalDarMedalla2(){
        Animal mascota = new Animal (4,'Komi','Vaquita',True,Animal.especie.Gato);
        
        system.assert(mascota.darMedalla(2).contains('Silver'));
    }
    
    @isTest
    private static void animalDarMedalla3(){
        Animal mascota = new Animal (4,'Komi','Vaquita',True,Animal.especie.Gato);
        
        system.assert(mascota.darMedalla(3).contains('Bronze'));
    }
    
    @isTest
    private static void animalDarMedalla4(){
        Animal mascota = new Animal (4,'Komi','Vaquita',True,Animal.especie.Gato);
        
        system.assertEquals(null, mascota.darMedalla(4));
    }
    
    @isTest
    private static void animalHablarPerro(){
        Animal mascota = new Animal (4,'rodolfo','blanco',True,Animal.especie.Perro);
        
        system.assert(mascota.hablar().contains('Woof Woof Woof'));
    }
    
    @isTest
    private static void animalHablarPollo(){
        Animal mascota = new Animal (4,'goku','amarillo',True,Animal.especie.Pollo);
        
        system.assert(mascota.hablar().contains('Pio Pio Pio'));
    }
    
}