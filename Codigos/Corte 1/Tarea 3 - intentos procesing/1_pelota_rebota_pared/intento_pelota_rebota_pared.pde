/*
DAVID JOSUE PINTO GOMEZ - INTENTO CODIGO

CODIGO DE TIRO PARABOLICO - INTENTO :(

INTENTO DE PROGRAMACION PROCESSING

PROBLEMAS DURANTE PROCESO:
1. ECUACIONES NO FUNCIONAN -> INTENTAR DESPEJAR Y RECREARLO MEDIANTE IF
2. AGREGAR CLICK MOUSE Y SU ZOOM (AVECES FUNCIONA)
3. EN TEORIA, SE DEBE PODER AGARRAR LA PELOTA UNA VEZ ESTA SE DETENGA... SI ES QUE LO HACE...
4. AL USAR LA EC ORIGINAL, SE QUEDA CONSTANTE EN REBOTES HORIZONTALES Y NUNCA CAE

*/

float suelo;
float techo;
float paredIzquierda;
float paredDerecha;

float angulo = radians(45); // Ángulo en radianes
float velocidadInicial = 10; // Velocidad inicial

Ball pelota;
boolean arrastrandoPelota = false;

void setup() {
  size(800, 600);
  suelo = height - 20;
  techo = 20;
  paredIzquierda = 100;
  paredDerecha = width - 100;

  float velocidadX = cos(angulo) * velocidadInicial;
  float velocidadY = sin(angulo) * velocidadInicial;

  pelota = new Ball(width / 4, suelo, 15, velocidadX, velocidadY);
}

void draw() {
  background(220);

  if (arrastrandoPelota) {
    pelota.actualizarPosicion(mouseX, mouseY);
  }

  pelota.actualizar();
  pelota.mostrar();

  // Dibujar suelo
  fill(100);
  rect(0, suelo, width, 20);

  // Dibujar techo
  fill(100);
  rect(0, techo, width, 20);

  // Dibujar paredes
  fill(100);
  rect(paredIzquierda, techo, 20, height - suelo - techo);
  rect(paredDerecha, techo, 20, height - suelo - techo);
}

void mousePressed() {
  if (pelota.estaDentro(mouseX, mouseY)) {
    arrastrandoPelota = true;
  }
}

void mouseReleased() {
  arrastrandoPelota = false;
}

class Ball {
  PVector posicion;
  PVector velocidad;
  float radio;

  Ball(float x, float y, float radio, float velocidadX, float velocidadY) {
    posicion = new PVector(x, y);
    velocidad = new PVector(velocidadX, velocidadY);
    this.radio = radio;
  }

  boolean estaDentro(float mouseX, float mouseY) {
    float distancia = dist(mouseX, mouseY, posicion.x, posicion.y);
    return distancia < radio;
  }

  void actualizarPosicion(float newX, float newY) {
    posicion.x = newX;
    posicion.y = newY;
  }

  void actualizar() {
    // Aplicar gravedad
    velocidad.add(0, 0.5); // Gravedad
    posicion.add(velocidad);

    // Colisión con suelo, techo y paredes
    if (posicion.y > suelo - radio) {
      posicion.y = suelo - radio;
      velocidad.y *= -0.8; // Rebote
    } else if (posicion.y < techo + radio) {
      posicion.y = techo + radio;
      velocidad.y *= -0.8; // Rebote
    }

    if (posicion.x < paredIzquierda + radio) {
      posicion.x = paredIzquierda + radio;
      velocidad.x *= -0.8; // Rebote
    } else if (posicion.x > paredDerecha - radio) {
      posicion.x = paredDerecha - radio;
      velocidad.x *= -0.8; // Rebote
    }
  }

  void mostrar() {
    fill(255, 0, 0);
    ellipse(posicion.x, posicion.y, radio * 2, radio * 2);
  }
}
