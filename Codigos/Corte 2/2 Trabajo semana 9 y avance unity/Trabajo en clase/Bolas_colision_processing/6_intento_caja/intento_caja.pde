ArrayList<Ball> balls = new ArrayList<Ball>();
Box box;

void setup() {
  size(800, 400);
  
  box = new Box(100, 100, 600, 300); // Crea una caja en el centro de la ventana
  
  for (int i = 0; i < 5; i++) { // Cambia el número de bolas aquí
    Ball b = new Ball(random(120, width - 120), random(120, height - 120), random(10, 30));
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
  
  // Dibuja la caja
  box.display();
  
  for (Ball b : balls) {
    b.applyGravity(0.2);
    b.display();
    b.move();
    // Colisión con la caja
    b.collideWithBox(box);
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
    this.vy = random(1, 3); // Inicializa con velocidad hacia abajo
    this.c = color(random(255), random(255), random(255));
  }

  void applyGravity(float g) {
    vy += g;
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

  void collideWithBox(Box box) {
    if (x - radius < box.x || x + radius > box.x + box.width) {
      vx *= -1;
    }
    if (y - radius < box.y || y + radius > box.y + box.height) {
      vy *= -1;
    }
  }
}

class Box {
  float x, y, width, height;

  Box(float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  void display() {
    noFill();
    stroke(0);
    rect(x, y, width, height);
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
