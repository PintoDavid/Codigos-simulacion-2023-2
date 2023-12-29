/*
DAVID JOSUE PINTO GOMEZ - 1202363
CODIGO DE CHOQUE DIFERENTE ANGULO 2/5

SE INTENTO CORREGIR LA COLISION DE ANGULOS NEGATIVOS A POSITIVOS
AL PARECER, LA FUNCION TRIGONOMETRICA PLANTEADA-> atan2() SOLO RETORNA EN VALOR ABSOLUTO
HACIENDO QUE VARIAS COLISIONES QUEDEN... "RARAS"

EN LA PRIMERA COLISION - SE QUEDA ESTANCADO EN LOS ANGULOS RECTOS

SE INTENTO CORREGIR LOS ANGULOS PERO NI CON LA FUNCION DE RANDOM, LO SOLUCIONO :C
*/
float m1 = 1.0;         // Masa de la primera bola (kg)
float m2 = 9.0;         // Masa de la segunda bola (kg)
float r1 = 20;          // Radio de la primera bola
float r2 = 30;          // Radio de la segunda bola
float e = 0.9;          // Coeficiente de restitución

float x1, x2;           // Posiciones x de las bolas
float y1, y2;           // Posiciones y de las bolas
float vx1, vx2;         // Velocidades en el eje x de las bolas
float vy1, vy2;         // Velocidades en el eje y de las bolas

boolean firstCollision = true; // Variable para controlar la primera colisión

void setup() {
  size(400, 400);
  resetBalls();
  frameRate(60);          // Establece la velocidad de fotogramas
}

void draw() {
  background(255);
  
  // Dibuja las bolas
  ellipse(x1, y1, 2 * r1, 2 * r1);
  ellipse(x2, y2, 2 * r2, 2 * r2);
  
  // Actualiza la posición de las bolas
  x1 += vx1;
  x2 += vx2;
  y1 += vy1;
  y2 += vy2;
  
  // Detecta colisión con los bordes de la ventana y aplica rebote
  if (x1 < r1 || x1 > width - r1) {
    vx1 *= -1;
  }
  if (x2 < r2 || x2 > width - r2) {
    vx2 *= -1;
  }
  if (y1 < r1 || y1 > height - r1) {
    vy1 *= -1;
  }
  if (y2 < r2 || y2 > height - r2) {
    vy2 *= -1;
  }
  
  // Detecta la colisión entre las bolas y aplica las ecuaciones de colisión
  float d = dist(x1, y1, x2, y2);
  
  // Comprueba si las bolas se han encontrado nuevamente
  if (d < r1 + r2) {
    if (firstCollision) {
      // Si es la primera colisión, cambia las velocidades de manera aleatoria
      float angle1 = random(0, TWO_PI);
      float angle2 = random(0, TWO_PI);
      float speed = random(1, 5);
      
      vx1 = speed * cos(angle1);
      vy1 = speed * sin(angle1);
      vx2 = speed * cos(angle2);
      vy2 = speed * sin(angle2);
      //angulo, rotar vectores, rotar velocidad, rotar vectores
      
      firstCollision = false; // Desactiva la bandera de la primera colisión
    } else {
      // Aplica el coeficiente de restitución en las colisiones subsiguientes
      float angle = atan2(y2 - y1, x2 - x1);
      float v1_final = ((m1 - m2) * vx1 + 2 * m2 * vx2) / (m1 + m2);
      float v2_final = ((2 * m1 * vx1) + (m2 - m1) * vx2) / (m1 + m2);
    
      vx1 = v1_final * e * cos(angle);
      vy1 = v1_final * e * sin(angle);
      vx2 = v2_final * e * cos(angle + PI);
      vy2 = v2_final * e * sin(angle + PI);
    }
  }
}

void resetBalls() {
  // Inicializa las posiciones, velocidades y direcciones aleatorias de las bolas
  x1 = width / 4;
  y1 = height / 2;
  x2 = 3 * width / 4;
  y2 = height / 2;
  float angle1 = random(0, TWO_PI);
  float angle2 = random(0, TWO_PI);
  float speed = random(1, 5);
  
  vx1 = speed * cos(angle1);
  vy1 = speed * sin(angle1);
  vx2 = speed * cos(angle2);
  vy2 = speed * sin(angle2);
}
