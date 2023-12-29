/*
DAVID JOSUE PINTO GOMEZ - 1202363
CODIGO DE CHOQUE CONTRA PARED 3/5

LA PELOTA REBOTA CONTRA LA PARED :D
LITERALMENTE

NO SE APLICO GRAVEDAD EN LA PELOTA

LA PANTALLA ESTA CHICA Y EXTENDIDA PARA QUE LOGRE HACER UN CHOQUE DISTINTO
*/
class Bola {
  float x, y;
  float radio;
  float velocidadX, velocidadY;
  float masa;
  float coeficienteRestitucion;

  Bola(float x_, float y_, float masa_, float velocidadX_, float velocidadY_, float coeficienteRestitucion_) {
    x = x_;
    y = y_;
    radio = 20; // Radio de la bola
    velocidadX = velocidadX_;
    velocidadY = velocidadY_;
    masa = masa_;
    coeficienteRestitucion = coeficienteRestitucion_;
  }

  void mostrar() {
    fill(0, 0, 255);
    ellipse(x, y, radio * 2, radio * 2);
  }

  void mover() {
    x += velocidadX;
    y += velocidadY;

    // Verificar colisión con las paredes
    if (x + radio >= width) {
      velocidadX *= -coeficienteRestitucion; // Rebote en el eje x
      x = width - radio;
    } else if (x - radio <= 0) {
      velocidadX *= -coeficienteRestitucion; // Rebote en el eje x
      x = radio;
    }

    if (y + radio >= height) {
      velocidadY *= -coeficienteRestitucion; // Rebote en el eje y
      y = height - radio;
    } else if (y - radio <= 0) {
      velocidadY *= -coeficienteRestitucion; // Rebote en el eje y
      y = radio;
    }
  }
  
  float velocidadFinal() {
    // Calcula la velocidad final como la magnitud del vector velocidad
    return sqrt(velocidadX * velocidadX + velocidadY * velocidadY);
  }
}

Bola bola;

void setup() {
  size(1080, 400); // Ventana más grande
  float velocidadXInicial = 3; // Velocidad inicial en el eje x
  float velocidadYInicial = 2; // Velocidad inicial en el eje y
  float coeficienteRestitucion = 0.9; // Coeficiente de restitución
  bola = new Bola(width / 2, height / 2, 9, velocidadXInicial, velocidadYInicial, coeficienteRestitucion);
}

void draw() {
  background(220);

  // Muestra y mueve la bola
  bola.mostrar();
  bola.mover();

  // Muestra la velocidad final de la bola
  fill(0);
  textSize(16);
  text("Velocidad final: " + nf(bola.velocidadFinal(), 0, 2), 20, height - 20);
}
