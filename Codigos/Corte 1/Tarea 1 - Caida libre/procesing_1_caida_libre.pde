//----------------------------------------------------------------
//METODO DEL PROFESOR
//----------------------------------------------------------------

/*float yDist = 1.0;
pelota pelota1;

void setup(){
  size(640,320);
  pelota1 = new pelota(width/2, height/2, 20, 20);
}

void draw(){
  background(220);
  pelota1.actualizarPos(0,yDist);
  pelota1.dibujar();
}*/

//----------------------------------------------------------------
//MI METODO
//----------------------------------------------------------------

class Esfera {
  float x;
  float y;
  float masa;
  float velocidadInicial;
  float angulo;
  float gravedad = 9.81;
  
  boolean enMovimiento = true;
  
  Esfera(float x, float y, float masa, float velocidadInicial, float angulo) {
    this.x = x;
    this.y = y;
    this.masa = masa;
    this.velocidadInicial = velocidadInicial;
    this.angulo = angulo;
    this.gravedad = gravedad * (masa / 30.0); // Ajusta la gravedad según la masa
  }
  
  void actualizar() {
    if (enMovimiento) {
      float tiempo = millis() / 1000.0;
      x = velocidadInicial * cos(angulo) * tiempo;
      y = velocidadInicial * sin(angulo) * tiempo - 0.5 * gravedad * tiempo * tiempo;
    } else {
      x += 1; // Movimiento constante en el eje x después de tocar el suelo
    }
  }
  
  void dibujo() {
    float diametro = map(masa, 0, 50, 10, 50); // Ajusta el tamaño de la esfera según la masa
    fill(255, 0, 0);
    ellipse(x, height - y, diametro, diametro);
  }
}

Esfera miEsfera;
float xInicial, yInicial;

void setup() {
  size(640, 320);
  xInicial = width * 0.1;
  yInicial = height * 0.9;
  float masa = 10;
  float velocidadInicial = 50;
  float angulo = radians(45);
  miEsfera = new Esfera(xInicial, yInicial, masa, velocidadInicial, angulo);
}

void draw() {
  background(220);
  
  miEsfera.actualizar();
  miEsfera.dibujo();
}
