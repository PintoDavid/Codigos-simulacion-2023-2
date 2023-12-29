/*
DAVID JOSUE PINTO GOMEZ - 1202363

CODIGO DE BOLAS MULTIPLES COLISIONANDO
RETO 5/5

INCLUYE:
- SOLUCION DEL PROBLEMA DE INTERPOLACION ENTRE RADIOS
*/

ArrayList<Ball> balls;  // ArrayList para almacenar las bolas
int numBalls = 20;  // Número de bolas
float bounce = -1.0;  // Factor de rebote - es "la fuerza del rebote"

void setup() {
  size(800, 600);
  balls = new ArrayList<Ball>();  // Inicializar el ArrayList
  
  // Crear las bolas y agregarlas al ArrayList
  //Debido a que son varias - en vez de hacer uno en uno, usamos un arreglo para poner todas alli y que sean aleatorias
  for (int i = 0; i < numBalls; i++) {
    float radius = random(15, 35);  // Radio aleatorio
    Ball ball = new Ball(radius, color(random(255), random(255), random(255)));  // Crear una nueva bola
    ball.mass = radius;  // Asignar masa basada en el radio
    ball.x = random(width);  // Posición x aleatoria
    ball.y = random(height);  // Posición y aleatoria
    ball.vx = random(-5, 5);  // Velocidad x aleatoria
    ball.vy = random(-5, 5);  // Velocidad y aleatoria
    balls.add(ball);  // Agregar la bola al ArrayList
  }
}

void draw() {
  background(255);
  
  // Mover y verificar las paredes para cada bola
  for (int i = 0; i < balls.size(); i++) {
    Ball ball = balls.get(i);
    ball.move();  // Mover la bola
    ball.checkWalls();  // Verificar las paredes para la bola
  }
  
  // Comprobar colisiones entre bolas
  for (int i = 0; i < balls.size() - 1; i++) {
    Ball ballA = balls.get(i);
    for (int j = i + 1; j < balls.size(); j++) {
      Ball ballB = balls.get(j);
      ballA.checkCollision(ballB);  // Comprobar colisión entre dos bolas
    }
  }
  
  // Dibujar cada bola
  for (int i = 0; i < balls.size(); i++) {
    Ball ball = balls.get(i);
    ball.display();  // Llamar a la función display() de la clase Ball.
  }
}


class Ball {
  float radius;
  color col;
  float mass;
  float x, y;
  float vx, vy;
  
  Ball(float radius, color col) {
    this.radius = radius;
    this.col = col;
  }
  
  void display() {
    fill(col);
    ellipse(x, y, radius * 2, radius * 2);
  }
  
  //Tiene ne cuenta la otra bola al momento de colisionar - sin importar si hay 2 o 3 cerca de la otra
  void checkCollision(Ball other) {
    //Trigonometria
    float dx = other.x - this.x;
    float dy = other.y - this.y;
    float distance = sqrt(dx * dx + dy * dy);
    
    //Hallar el angulo cuando la distancia provoca colision
    if (distance < this.radius + other.radius) {
      // Calcular ángulo, seno y coseno
      float angle = atan2(dy, dx);
      float sinValue = sin(angle);
      float cosValue = cos(angle);
      
      // Rotar las posiciones y velocidades
      PVector pos0 = new PVector(0, 0);
      PVector pos1 = rotate(dx, dy, sinValue, cosValue, true);
      PVector vel0 = rotate(this.vx, this.vy, sinValue, cosValue, true);
      PVector vel1 = rotate(other.vx, other.vy, sinValue, cosValue, true);
      
      // Calcular la velocidad total en la dirección x
      float vxTotal = vel0.x - vel1.x;
      
      // Actualizar las velocidades después de la colisión
      vel0.x = ((this.mass - other.mass) * vel0.x + 2 * other.mass * vel1.x) / (this.mass + other.mass);  //Ecuacion de la conservacion o del momentum pero "globalizada" o general para todas las bolas
      vel1.x = vxTotal + vel0.x;  //Actualizacion de la velocidad de la otra bola - depende de la anterior
      
      // Calcular la superposición y ajustar las posiciones
      float absV = abs(vel0.x) + abs(vel1.x);
      float overlap = (this.radius + other.radius) - abs(pos0.x - pos1.x);    //OVERLAP ES LA SOLUCION DE LA INTERPOLACION
      pos0.x += vel0.x / absV * overlap;  //OVERLAP RE HACE EL CALCULO ENTRE LAS COLISIONES PARA ALEJARLAS Y NO SE FUSIONEN
      pos1.x += vel1.x / absV * overlap;
      
      // Rotar las posiciones de vuelta
      PVector pos0F = rotate(pos0.x, pos0.y, sinValue, cosValue, false);
      PVector pos1F = rotate(pos1.x, pos1.y, sinValue, cosValue, false);
      
      // Ajustar las posiciones finales
      other.x = this.x + pos1F.x;
      other.y = this.y + pos1F.y;
      this.x = this.x + pos0F.x;
      this.y = this.y + pos0F.y;
      
      // Rotar las velocidades de vuelta
      PVector vel0F = rotate(vel0.x, vel0.y, sinValue, cosValue, false);
      PVector vel1F = rotate(vel1.x, vel1.y, sinValue, cosValue, false);
      
      // Actualizar las velocidades finales
      this.vx = vel0F.x;
      this.vy = vel0F.y;
      other.vx = vel1F.x;
      other.vy = vel1F.y;
    }
  }
  
  //PARA QUE REBOTEN CONTRA LA PARED O BORDES DE VENTANA
  void checkWalls() {
    if (x + radius > width) {
      x = width - radius;
      vx *= bounce;
    } else if (x - radius < 0) {
      x = radius;
      vx *= bounce;
    }
    
    if (y + radius > height) {
      y = height - radius;
      vy *= bounce;
    } else if (y - radius < 0) {
      y = radius;
      vy *= bounce;
    }
  }
  
  //ACTUALIZA EL MOVIMIENTO O POSICION DE LAS BOLAS
  void move() {
    x += vx;
    y += vy;
  }
  
  //OTRO VECTOR ENCARGADO DE HACER LA ROTACION FINAL PARA APLICARLA LUEGO DE LA COLISION
  //LUEGO DE LA COLISION, SE ROTA DEPENDIENDO DE SU POSICION PARA SU ANGULO Y SI ESTAS DEBEN HACER REBOTA CONTRAPUESTO
  PVector rotate(float x, float y, float sinValue, float cosValue, boolean reverse) {
    if (reverse) {
      return new PVector(x * cosValue + y * sinValue, y * cosValue - x * sinValue);
    } else {
      return new PVector(x * cosValue - y * sinValue, y * cosValue + x * sinValue);
    }
  }
}
