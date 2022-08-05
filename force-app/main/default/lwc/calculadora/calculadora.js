import { LightningElement } from 'lwc';

export default class Calculadora extends LightningElement {
    cadena = '';
    cadena2 ='';
    valor1 = '';
    valor2 = '';
    resultado = '';
    resultado2 ='';
    operacion = '';
    temp = '';

    numberChange(event){
        switch(event.target.dataset.id)
        {
            case '1':
                this.temp += '1';
                this.cadena += '1';
                
                break;
            case '2':
                this.temp += '2';
                this.cadena += '2';
                
                break;
            case '3':
                this.temp += '3';
                this.cadena += '3';
                
                break;
            case '4':
                this.temp += '4';
                this.cadena += '4';
                
                break;
            case '5':
                this.temp += '5';
                this.cadena += '5';
                
                break;
            case '6':
                this.temp += '6';
                this.cadena += '6';
                
                break;
            case '7':
                this.temp += '7';
                this.cadena += '7';
                
                break;
            case '8':
                this.temp += '8';
                this.cadena += '8';
                
                break;
            case '9':
                this.temp += '9';
                this.cadena += '9';
                
                break;
            case '0':
                this.temp += '0';
                this.cadena += '0';
                
                break;
            
        }
    }
    clear(){
        this.cadena = '';
        this.valor1 = '';
        this.valor2 = '';
        this.temp = '';
        this.operacion = '';
        this.resultado = '';
        this.cadena2 = '';
    }
    operationClick(event){
        switch(event.target.dataset.id){
            case '+':                
                this.valor1 = Number(this.temp);
                this.cadena += '+';
                this.operacion = 'sumar';
                this.temp = '';
                
            break;
            case '-':                
                this.valor1 = Number(this.temp);
                this.cadena += '-';
                this.operacion = 'restar';
                this.temp = '';
                
            break;
            case '*':                
                this.valor1 = Number(this.temp);
                this.cadena += '*';
                this.operacion = 'multiplicar';
                this.temp = '';
                
            break;
            case '/':                
                this.valor1 = Number(this.temp);
                this.cadena += '/';
                this.operacion = 'dividir';
                this.temp = '';
                
            break;
        }
    }

    operate(){
        switch(this.operacion){
            case 'sumar':
                this.valor2 = Number(this.temp);
                this.resultado = this.valor1 + this.valor2;
                this.temp = this.resultado;
                
            break;
            case 'restar':
                this.valor2 = Number(this.temp);
                this.resultado = this.valor1 - this.valor2;
                this.temp = this.resultado;
                
            break;
            case 'multiplicar':
                this.valor2 = Number(this.temp);
                this.resultado = this.valor1 * this.valor2;
                this.temp = this.resultado;
                
            break;
            case 'dividir':
                this.valor2 = Number(this.temp);
                this.resultado = this.valor1 / this.valor2;
                this.temp = this.resultado;
                
            break;
        }
    }

    
}