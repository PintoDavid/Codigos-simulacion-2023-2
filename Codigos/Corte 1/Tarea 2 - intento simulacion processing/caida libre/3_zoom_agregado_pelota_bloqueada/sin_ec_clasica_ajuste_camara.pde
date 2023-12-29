Ball pelota;
float suelo;

float zoom = 1.0;

boolean arrastrandoPelota = false;

void setup() {
  size(800, 600);
  suelo = height - 20;
  pelota = new Ball(width / 2, suelo - 15, 30);
}

void draw() {
  background(220);

  scale(zoom);

  pelota.actualizar(suelo);
  pelota.mostrar();

  // Dibujar suelo
  fill(100);
  rect(0, suelo, width, 20);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    pelota.reiniciar();
  }
}

void mousePressed() {
  if (pelota.estaDentro(mouseX, mouseY)) {
    pelota.hacerArrastrable(mouseX, mouseY);
    arrastrandoPelota = true;
  }
}

void mouseReleased() {
  arrastrandoPelota = false;
}

void mouseDragged() {
  if (arrastrandoPelota) {
    pelota.actualizarPosicion(mouseX, mouseY);
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zoom += e * 0.05; // Ajustar la velocidad de zoom
  zoom = constrain(zoom, 0.2, 3.0); // Limitar el zoom
}

class Ball {
  float x, y;
  float diametro;
  float velocidadY = 0;
  float rebote = -0.6; // Coeficiente de restitución

  float posicionInicialX, posicionInicialY;

  Ball(float x, float y, float diametro) {
    this.x = x;
    this.y = y;
    this.diametro = diametro;
    posicionInicialX = x;
    posicionInicialY = y;
  }

  boolean estaDentro(float mouseX, float mouseY) {
    float distancia = dist(mouseX, mouseY, x, y);
    return distancia < diametro / 2;
  }

  void hacerArrastrable(float mouseX, float mouseY) {
    float distancia = dist(mouseX, mouseY, x, y);
    if (distancia < diametro / 2) {
      x = mouseX;
      y = mouseY;
      velocidadY = 0;
    }
  }

  void actualizarPosicion(float newX, float newY) {
    x = newX;
    y = newY;
    velocidadY = 0;
  }

  void actualizar(float suelo) {
    velocidadY += 0.2; // Gravedad
    y += velocidadY;

    if (y + diametro / 2 > suelo) { // Colisión con el suelo
      y = suelo - diametro / 2;
      velocidadY *= rebote;
    }
  }

  void mostrar() {
    fill(255, 0, 0);
    ellipse(x, y, diametro, diametro);
  }

  void reiniciar() {
    x = posicionInicialX;
    y = posicionInicialY;
    velocidadY = 0;
  }
}
