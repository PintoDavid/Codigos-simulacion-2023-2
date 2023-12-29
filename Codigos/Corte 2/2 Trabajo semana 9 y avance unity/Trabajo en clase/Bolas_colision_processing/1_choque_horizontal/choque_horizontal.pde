float m1 = 1.0;         // Masa de la primera bola (kg)
float m2 = 9.0;         // Masa de la segunda bola (kg)
float r1 = 20;          // Radio de la primera bola
float r2 = 30;          // Radio de la segunda bola
float e = 0.9;          // Coeficiente de restitución

float x1, x2;           // Posiciones x de las bolas
float v1, v2;           // Velocidades en el eje x de las bolas

void setup() {
  size(800, 400);
  resetBalls();
  frameRate(60);          // Establece la velocidad de fotogramas
}

void draw() {
  background(255);
  
  // Dibuja las bolas
  ellipse(x1, height / 2, 2 * r1, 2 * r1);
  ellipse(x2, height / 2, 2 * r2, 2 * r2);
  
  // Actualiza la posición de las bolas
  x1 += v1;
  x2 += v2;
  
  // Detecta colisión con los bordes de la ventana y aplica rebote
  if (x1 < r1 || x1 > width - r1) {
    v1 *= -1;
  }
  if (x2 < r2 || x2 > width - r2) {
    v2 *= -1;
  }
  
  // Detecta la colisión entre las bolas y aplica las ecuaciones de colisión
  float d = abs(x2 - x1);
  if (d < r1 + r2) {
    // Aplica el coeficiente de restitución
    float v1_final = ((m1 - m2) * v1 + 2 * m2 * v2) / (m1 + m2);
    float v2_final = ((2 * m1 * v1) + (m2 - m1) * v2) / (m1 + m2);
    
    v1 = v1_final * e;
    v2 = v2_final * e;
  }
}

void resetBalls() {
  // Inicializa las posiciones y velocidades de las bolas en el eje x
  x1 = width / 4;
  x2 = 3 * width / 4;
  v1 = random(1, 5);
  v2 = random(-5, -1);
}
