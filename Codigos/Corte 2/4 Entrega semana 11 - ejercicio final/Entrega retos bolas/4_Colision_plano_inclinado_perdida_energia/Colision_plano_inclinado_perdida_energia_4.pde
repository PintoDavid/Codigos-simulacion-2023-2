/*
DAVID JOSUE PINTO GOMEZ - 1202363

CODIGO DE BOLA COLISIONANDO EN PLANO INCLINADO + PERDIDA DE ENERGIA
RETO 4/5

INCLUYE:
- REBOTE EN BORDES VENTANA
- AGARRE MOUSE
- LINEA O PLANO MAS LARGO

POSIBLES ERRORES:
- AL ARRASTRAR LA BOLA PUEDE VARIAR SU VELOCIDAD INESPERADAMENTE
- POCAS VECES SE ESTANCA EN LA LINEA, PERO SE SOLUCIONA CON LA GRAVEDAD
*/

Bola bola;
Linea linea;

//ARRASTRE CON MOUSE EN LA BOLA
boolean mousePressedOnBall = false;
PVector mouseOffset;

//IMPLEMENTACION DE PERDIDA DE ENERGIA A PARTIR DEL COEFICIENTE DE RESTITUCION
float coeficienteRestitucion = 0.8; // Ajusta el coeficiente según lo desees

void setup() {
  size(800, 600);
  frameRate(60);
  
  // Inicializa la bola y la línea inclinada
  bola = new Bola(width - 550, height - 550, 20);  //BOLA Y SU RADIO
  linea = new Linea(width / 6, height / 2, radians(30), 400);
}

void draw() {
  background(255);
  
  // Calcula la gravedad
  PVector gravedad = new PVector(0, 0.2);
  bola.aplicarFuerza(gravedad);
  
  // Verifica si la bola colisiona con los bordes de la ventana
  bola.rebotarEnBordes();
  
  // Actualiza la posición de la bola
  bola.actualizar();

  // Si el mouse está presionado en la bola, arrástrala
  if (mousePressedOnBall) {
    PVector mousePos = new PVector(mouseX, mouseY);
    PVector nuevaPosicion = mousePos.sub(mouseOffset);
    bola.mover(nuevaPosicion);
  }
  
  // Verifica si la bola colisiona con la línea inclinada
  if (bola.colision(linea)) {
    bola.rebotar(linea);
  }
  
  // Dibuja la línea y la bola
  linea.mostrar();
  bola.mostrar();
}

//=================================================================================
//AGARRE DE BOLA CON EL MOUSE
//=================================================================================
void mousePressed() {
  float d = dist(mouseX, mouseY, bola.posicion.x, bola.posicion.y);
  if (d < bola.radio) {
    mousePressedOnBall = true;
    mouseOffset = new PVector(mouseX - bola.posicion.x, mouseY - bola.posicion.y);
    bola.detener();
  }
}

void mouseReleased() {
  mousePressedOnBall = false;
  bola.reanudar();
}


//CLASES PARA LA BOLA Y LINEA
//=================================================================================
//CLASE PARA LA BOLA - TIPO PARED INCLINADA
//=================================================================================
class Bola {
  PVector posicion;
  PVector velocidad;
  float radio;
  
  Bola(float x, float y, float r) {
    posicion = new PVector(x, y);
    velocidad = new PVector(0, 0);
    radio = r;
  }
  
  void aplicarFuerza(PVector fuerza) {
    PVector f = fuerza.copy();
    f.div(1); // Divide la fuerza por la masa (que es 1 en este caso)
    velocidad.add(f);
  }
  
  void actualizar() {
    posicion.add(velocidad);
  }
  
  void mostrar() {
    ellipse(posicion.x, posicion.y, radio * 2, radio * 2);
  }
  
  //CALCULA LA COLISION CON LA LINEA
  boolean colision(Linea linea) {
  // Calcula la posición de la bola en relación con la línea inclinada
  PVector puntoDeColision = posicion.copy();
  puntoDeColision.sub(linea.inicio); // Resta la posición inicial de la línea inclinada
  puntoDeColision.rotate(-linea.angulo); // Gira el punto según el ángulo negativo de la línea inclinada
  
  // Comprueba si el punto de colisión está dentro de la longitud de la línea inclinada
  if (puntoDeColision.x >= 0 && puntoDeColision.x <= linea.longitud) {
    // Comprueba si la bola está por debajo de la línea inclinada en la coordenada y
    float distanciaALinea = abs(puntoDeColision.y);
    return distanciaALinea <= radio;
  }
  
  return false;
}

  //CALCULA EL REBOTE CON LA LINEA
  void rebotar(Linea linea) {
    // Calcula la velocidad en la dirección perpendicular a la línea inclinada
    PVector velocidadNormal = velocidad.copy();
    velocidadNormal.rotate(-linea.angulo);
  
    // Invierte la velocidad normal para el rebote
    velocidadNormal.y *= -1;
    
    // Aplica la rotación inversa al vector de velocidad normal
    velocidadNormal.rotate(linea.angulo);
    
    // Actualiza la velocidad de la bola con la velocidad rebote
    velocidad = velocidadNormal;
  }
  void mover(PVector nuevaPosicion) {
    posicion = nuevaPosicion;
  }

  //CALCULA EL REBOTE EN PAREDES O BORDE DE LA VENTANA
  void rebotarEnBordes() {
    if (posicion.x < radio || posicion.x > width - radio) {
      velocidad.x *= -coeficienteRestitucion; // Pérdida de energía en la dirección x
    }
    if (posicion.y > height - radio) {
      velocidad.y *= -coeficienteRestitucion; // Pérdida de energía en la dirección y
      // Restringe la posición vertical para evitar que la bola "se pegue" al suelo
      posicion.y = height - radio;
    }
  }

  void detener() {
    velocidad.set(0, 0);
  }

  void reanudar() {
    // Continuar con la velocidad anterior
  }
}

//=================================================================================
//CLASE PARA LA LINEA
//=================================================================================
class Linea {
  PVector inicio;
  float longitud;
  float angulo;
  
  Linea(float x, float y, float a, float l) {
    inicio = new PVector(x, y);
    angulo = a;
    longitud = l;
  }
  
  void mostrar() {
    pushMatrix();
    translate(inicio.x, inicio.y);
    rotate(angulo);
    line(0, 0, longitud, 0);
    popMatrix();
  }
}
