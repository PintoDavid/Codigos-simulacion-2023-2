float ballRadius = 30;     // Radio de la pelota
float ballX, ballY;        // Posición de la pelota
float ballSpeedX = 0;      // Velocidad horizontal de la pelota
float ballSpeedY = 0;      // Velocidad vertical de la pelota
float ballGravity = 0.5;   // Gravedad que afecta a la pelota
float damping = 0.8;       // Coeficiente de amortiguación

float springHeight = 200;  // Altura inicial del resorte
float springStiffness = 0.1; // Rigidez del resorte
float springDamping = 0.9; // Amortiguación del resorte

boolean isDraggingBall = false;
float ballOffsetX = 0;
float ballOffsetY = 0;

boolean isDraggingCamera = false;
float cameraOffsetX = 0;
float cameraOffsetY = 0;

boolean isReleased = false;

float zoom = 1.0;          // Nivel de zoom

void setup() {
  size(800, 600);
  ballX = width / 2;
  ballY = springHeight + ballRadius;
}

void draw() {
  background(220);

  // Manejo del zoom
  scale(zoom);

  // Si estamos arrastrando la cámara, actualizamos su posición con la posición del ratón
  if (isDraggingCamera) {
    translate(cameraOffsetX, cameraOffsetY);
  }

  // Si estamos arrastrando la pelota, actualizamos su posición con la posición del ratón
  if (isDraggingBall) {
    ballX = mouseX / zoom + ballOffsetX;
    ballY = mouseY / zoom + ballOffsetY;
    ballSpeedX = 0;
    ballSpeedY = 0;
  }

  // Si la pelota fue soltada y ha vuelto a su posición original
  if (isReleased && abs(ballX - width / 2) < 1 && abs(ballY - springHeight - ballRadius) < 1) {
    isReleased = false;
    ballSpeedY = -10; // Aplicar una velocidad inicial hacia arriba para generar la ondulación
  }

  // Calcular la fuerza del resorte
  float springForceY = -springStiffness * (ballY - springHeight);
  float springForceX = -springStiffness * (ballX - width / 2);

  // Calcular la fuerza de amortiguación
  float dampingForceY = -springDamping * ballSpeedY;
  float dampingForceX = -springDamping * ballSpeedX;

  // Sumar las fuerzas para obtener la fuerza total
  float totalForceY = springForceY + dampingForceY + ballGravity;
  float totalForceX = springForceX + dampingForceX;

  // Calcular la aceleración de la pelota
  float ballAccelerationY = totalForceY;
  float ballAccelerationX = totalForceX;

  // Actualizar la velocidad y posición de la pelota
  ballSpeedY += ballAccelerationY;
  ballY += ballSpeedY;
  ballSpeedX += ballAccelerationX;
  ballX += ballSpeedX;

  // Colisiones con paredes y techo
  if (ballX - ballRadius < 0 || ballX + ballRadius > width) {
    ballSpeedX *= -damping; // Rebote con pérdida de energía
  }
  if (ballY - ballRadius < 0) {
    ballY = ballRadius;
    ballSpeedY *= -damping; // Rebote con pérdida de energía
  }

  // Dibujar el resorte
  line(ballX, ballY, ballX, springHeight);

  // Dibujar la pelota
  ellipse(ballX, ballY, ballRadius * 2, ballRadius * 2);
}

void mousePressed() {
  // Verificar si el ratón está sobre la pelota
  float distance = dist(ballX, ballY, mouseX / zoom, mouseY / zoom);
  if (distance < ballRadius) {
    isDraggingBall = true;
    ballOffsetX = ballX - mouseX / zoom;
    ballOffsetY = ballY - mouseY / zoom;
  }
  // Verificar si se está arrastrando la cámara
  else {
    isDraggingCamera = true;
    cameraOffsetX = mouseX - width / 2;
    cameraOffsetY = mouseY - height / 2;
  }
}

void mouseReleased() {
  isDraggingBall = false;
  isDraggingCamera = false;
  if (!isReleased) {
    isReleased = true;
  }
}

void mouseWheel(MouseEvent event) {
  float delta = event.getCount();
  zoom += delta * 0.05;
  zoom = constrain(zoom, 0.2, 3.0);
}
