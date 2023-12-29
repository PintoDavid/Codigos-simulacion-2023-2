/*
DAVID JOSUE PINTO GOMEZ - 1202363

CODIGO DE 2 BOLAS COLISIONANDO HORIZONTALMENTE
RETO 1/5

*/
Bola b1,b2;

void setup(){
  size(800,600);
  
  //inicia con las 2 bolas: b1 y b2
  // nombre_bola = new Bola(posicion_X, posicion_Y);
  b1= new Bola(100, height/2, 70);
  b2= new Bola(600, height/2, 50);
}

void draw(){
  background(255);
  
  //muestra las bolas b1 y b2
  //llama a la vez la colision en b1 y b2
  b1.movimiento();
  b2.movimiento();
  
  colision_bolas(b1, b2); // Verificar la colisión en cada cuadro
  
  b1.muestra();
  b2.muestra();
}

//FUNCION QUE VERIFICA LAS COLISIONES DE LAS BOLAS
//SE AÑADEN LAS BOLAS b1 Y b2
void colision_bolas(Bola b1, Bola b2){
  
  //encuentra la distancia entre ambas bolas
  //usamos el valor absoluto para su respuesta -> abs()
  float distancia = abs(b1.x - b2.x);
  
  //si la distancia es menor a la suma de sus radios
  if(distancia < b1.radio + b2.radio){
    
    //cuando las bolas colisionen
    //usamos variables temporales para sus velocidades finales
    float masaTotal = b1.masa + b2.masa;
    float nuevaVx1 = ((b1.masa - b2.masa) / masaTotal) * b1.vx + ((2 * b2.masa) / masaTotal) * b2.vx;
    float nuevaVx2 = ((2 * b1.masa) / masaTotal) * b1.vx - ((b1.masa - b2.masa) / masaTotal) * b2.vx;

    // Actualiza las velocidades finales en las bolas
    b1.vx = nuevaVx1;
    b2.vx = nuevaVx2;

    //se usa vx de b1 y b2 a las velocidades finales vx1(para b1) y vx2(para b2)
  }
}
