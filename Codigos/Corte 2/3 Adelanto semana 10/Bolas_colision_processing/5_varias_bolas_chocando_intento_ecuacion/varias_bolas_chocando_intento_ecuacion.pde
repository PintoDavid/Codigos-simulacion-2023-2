/*
DAVID JOSUE PINTO GOMEZ - 1202363
CODIGO DE CHOQUES MULTIPLES BOLAS 5/5

INTENTE EVITAR A TODA COSTA LAS ARRAYS Y TRANSFORMADAS YA QUE NO ME GUSTAN (TENGO TRAUMA DE COMPUTACION GRAFICA D:)

INTENTE POR EL METODO SIN UTILIZAR VECTORES


*/
ArrayList<Ball> balls = new ArrayList<Ball>();

void setup() {
  size(1000, 700);
  for (int i = 0; i < 10; i++) { // Cambia el número de bolas aquí
    Ball b = new Ball(random(20, width - 20), random(20, height - 20), random(10, 30));
    boolean overlapping = false;
    for (Ball other : balls) {
      float minDist = b.radius + other.radius + 10; // 10 unidades de margen
      float d = dist(b.x, b.y, other.x, other.y);
      if (d < minDist) {
        overlapping = true;
        break;
      }
    }
    if (!overlapping) {
      balls.add(b);
    }
  }
  frameRate(60);
}

void draw() {
  background(255);
  for (Ball b : balls) {
    b.display();
    b.move();
  }
  collision();
}

class Ball {
  float x, y;
  float vx, vy;
  float radius;
  color c;

  Ball(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.vx = random(-3, 3);
    this.vy = random(-3, 3);
    this.c = color(random(255), random(255), random(255));
  }

  void move() {
    x += vx;
    y += vy;
    if (x < radius || x > width - radius) {
      vx *= -1;
    }
    if (y < radius || y > height - radius) {
      vy *= -1;
    }
  }

  void display() {
    fill(c);
    ellipse(x, y, radius * 2, radius * 2);
  }
}

void collision() {
  for (int i = 0; i < balls.size(); i++) {
    Ball ball1 = balls.get(i);
    for (int j = i + 1; j < balls.size(); j++) {
      Ball ball2 = balls.get(j);
      float dx = ball2.x - ball1.x;
      float dy = ball2.y - ball1.y;
      float distance = sqrt(dx * dx + dy * dy);
      float minDist = ball1.radius + ball2.radius;

      if (distance < minDist) {
        float angle = atan2(dy, dx);
        float overlap = minDist - distance;
        float moveX = overlap * cos(angle) * 0.5;
        float moveY = overlap * sin(angle) * 0.5;

        ball1.x -= moveX;
        ball1.y -= moveY;
        ball2.x += moveX;
        ball2.y += moveY;

        float v1f = ((ball1.radius - ball2.radius) * ball1.vx + 2 * ball2.radius * ball2.vx) / (ball1.radius + ball2.radius);
        float v2f = ((2 * ball1.radius * ball1.vx + ball2.radius * ball2.vx) / (ball1.radius + ball2.radius));

        ball1.vx = v1f;
        ball2.vx = v2f;
      }
    }
  }
}
