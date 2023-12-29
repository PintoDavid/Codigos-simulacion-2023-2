Ball pelota;

void setup() {
  size(600, 400);
  pelota = new Ball(width / 2, height * 0.2, 30);
}

void draw() {
  background(220);
  
  pelota.actualizar();
  pelota.mostrar();
  
  // Dibujar suelo
  fill(100);
  rect(0, height - 20, width, 20);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    pelota.reiniciar();
  }
}

void mousePressed() {
  pelota.hacerArrastrable(mouseX, mouseY);
}

void mouseReleased() {
  pelota.dejarDeArrastrar();
}

class Ball {
  float x, y;
  float diametro;
  float velocidadY = 0;
  boolean arrastrando = false;
  float rebote = -0.6; // Coeficiente de restitución
  
  float posicionInicialX, posicionInicialY; //
  
  Ball(float x, float y, float diametro) {
    this.x = x;
    this.y = y;
    this.diametro = diametro;
    posicionInicialX = x;
    posicionInicialY = y;
  }
  
  void hacerArrastrable(float mouseX, float mouseY) {
    float distancia = dist(mouseX, mouseY, x, y);
    if (distancia < diametro / 2) {
      arrastrando = true;
    }
  }
  
  void dejarDeArrastrar() {
    arrastrando = false;
  }
  
  void actualizar() {
    if (arrastrando) {
      x = mouseX;
      y = mouseY;
      velocidadY = 0;
    } else {
      velocidadY += 0.2; // Gravedad
      y += velocidadY;
      
      if (y + diametro / 2 > height - 20) { // Colisión con el suelo
        y = height - 20 - diametro / 2;
        velocidadY *= rebote;
      }
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
