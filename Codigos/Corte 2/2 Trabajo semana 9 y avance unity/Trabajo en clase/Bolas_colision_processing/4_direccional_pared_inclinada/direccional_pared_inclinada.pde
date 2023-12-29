PVector[] polygonVertices; // Coordenadas de los vértices del polígono
PVector ballPosition; // Posición de la bola
PVector ballVelocity; // Velocidad de la bola
float ballRadius = 20; // Radio de la bola
float restitution = 0.9; // Coeficiente de restitución

void setup() {
  size(800, 600);
  
  // Definir las coordenadas de los vértices del polígono (triángulo rectángulo grande)
  polygonVertices = new PVector[3];
  polygonVertices[0] = new PVector(500, height); // Esquina inferior izquierda
  polygonVertices[1] = new PVector(1, height - 300); // Esquina superior izquierda
  polygonVertices[2] = new PVector(1, height); // Esquina inferior derecha

  // Inicializar la posición y velocidad de la bola
  ballPosition = new PVector(300, 400); // Posición inicial de la bola
  ballVelocity = new PVector(3, 0); // Velocidad inicial de la bola
}

void draw() {
  background(220);

  // Actualizar la posición de la bola
  ballPosition.add(ballVelocity);

  // Comprobar colisiones con el polígono
  if (collidesWithPolygon(ballPosition, ballRadius, polygonVertices)) {
    // Aplicar restitución y cambiar dirección
    PVector normal = getPolygonCollisionNormal(ballPosition, ballRadius, polygonVertices);
    ballVelocity = ballVelocity.sub(normal.mult(2 * ballVelocity.dot(normal))).mult(restitution);
  }

  // Comprobar colisiones con los bordes de la ventana
  if (ballPosition.x + ballRadius > width) {
    ballPosition.x = width - ballRadius;
    ballVelocity.x *= -restitution;
  }
  if (ballPosition.x - ballRadius < 0) {
    ballPosition.x = ballRadius;
    ballVelocity.x *= -restitution;
  }
  if (ballPosition.y + ballRadius > height) {
    ballPosition.y = height - ballRadius;
    ballVelocity.y *= -restitution;
  }
  if (ballPosition.y - ballRadius < 0) {
    ballPosition.y = ballRadius;
    ballVelocity.y *= -restitution;
  }

  // Dibujar el polígono (triángulo rectángulo grande)
  fill(127);
  beginShape();
  for (PVector vertex : polygonVertices) {
    vertex(vertex.x, vertex.y);
  }
  endShape(CLOSE);

  // Dibujar la bola
  fill(0, 0, 255);
  ellipse(ballPosition.x, ballPosition.y, ballRadius * 2, ballRadius * 2);
}

boolean collidesWithPolygon(PVector ballPosition, float ballRadius, PVector[] vertices) {
  // Comprobar si la bola colisiona con el polígono
  for (int i = 0; i < vertices.length; i++) {
    int j = (i + 1) % vertices.length;
    PVector a = vertices[i];
    PVector b = vertices[j];
    PVector edge = PVector.sub(b, a);
    PVector normal = new PVector(-edge.y, edge.x);
    normal.normalize();

    PVector toBall = PVector.sub(ballPosition, a);
    if (toBall.mag() < ballRadius && toBall.dot(normal) < 0) {
      return true;
    }
  }
  return false;
}

PVector getPolygonCollisionNormal(PVector ballPosition, float ballRadius, PVector[] vertices) {
  // Obtener la normal de colisión con el polígono
  for (int i = 0; i < vertices.length; i++) {
    int j = (i + 1) % vertices.length;
    PVector a = vertices[i];
    PVector b = vertices[j];
    PVector edge = PVector.sub(b, a);
    PVector normal = new PVector(-edge.y, edge.x);
    normal.normalize();

    PVector toBall = PVector.sub(ballPosition, a);
    if (toBall.mag() < ballRadius && toBall.dot(normal) < 0) {
      return normal;
    }
  }
  return new PVector(0, 0);
}
