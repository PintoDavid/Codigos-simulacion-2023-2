//========================================================================================
/*
CODIGO HECHO POR DAVID JOSUE PINTO GOMEZ + AYUDA DE LA INTERNET - FOROS - VIDEOS - ETC

NOMBRE DEL PROYECTO: ATRAPAME SI PUEDES

- ATRAPA Y MUEVE LA PELOTA QUE ESTA REALIZANDO SU RESPECTIVA TRAYECTORIA EN MOVIMIENTO

RECURSOS QUE FALTARON:
Implementacion de Euler

PROBLEMAS DURANTE EL DESARROLLO:
Improvizacion del codigo cambiando las ecuaciones con if para detectar las colisiones

*/
//========================================================================================

//========================================================================================
//SE LLAMA LA CLASE DE PELOTA QUE SE ENCUENTRA CASI AL FINAL DEL CODIGO
//========================================================================================
Ball pelota;
ArrayList<PVector> estela = new ArrayList<PVector>();
int longitudEstela = 100; // Longitud de la estela

//========================================================================================
//DECLARACION DE VARIABLES
//========================================================================================
float techo;
float paredIzquierda;
float paredDerecha;
float suelo;
float pendienteSuelo;

boolean reiniciarPelota = false; // Bandera para reiniciar la pelota
boolean arrastrandoPelota = false; // Bandera para arrastrar la pelota con el ratón
PVector offset; // Vector de desplazamiento al hacer clic

void setup() {
  size(1000, 600); // Pantalla más grande
  techo = 20;
  paredIzquierda = 50; // Pared izquierda más delgada
  paredDerecha = width - 50; // Pared derecha más delgada
  suelo = height - 20;
  pendienteSuelo = 0.1; // Pendiente del suelo

//========================================================================================
//ANGULO AL MOMENTO DE SOLTAR Y REALIZAR TRAYECTORIA
//========================================================================================
  float angulo = radians(45); // Ángulo en radianes
  float velocidadInicial = 10; // Velocidad inicial

  float velocidadX = cos(angulo) * velocidadInicial;
  float velocidadY = sin(angulo) * velocidadInicial;

  // Inicializa la pelota con posición y velocidad iniciales
  pelota = new Ball(width / 4, techo + 15, 15, velocidadX, velocidadY);
}

void draw() {
  background(220);

  // Dibuja el techo
  fill(100);
  rect(0, 0, width, techo);

  // Dibuja las paredes más delgadas
  fill(100);
  rect(0, techo, paredIzquierda, height - techo);
  rect(paredDerecha, techo, width - paredDerecha, height - techo);

  // Dibuja el suelo con pendiente
  stroke(100); // Color del trazo
  for (float x = paredIzquierda; x <= paredDerecha; x += 1) {
    float y = suelo - (x - paredIzquierda) * pendienteSuelo;
    line(x, suelo, x, y);
  }

//========================================================================================
//IMPLEMENBTACION ESTELA PUNTO 2.2
//========================================================================================
  // Actualiza la pelota y la estela
  if (!arrastrandoPelota) {
    pelota.actualizar();
  }
  pelota.mostrar();

  // Colisión con el techo
  if (pelota.posicion.y - pelota.radio < techo) {
    pelota.velocidad.y *= -1;
    pelota.posicion.y = techo + pelota.radio;
  }

  // Colisión con las paredes
  if (pelota.posicion.x - pelota.radio < paredIzquierda || pelota.posicion.x + pelota.radio > paredDerecha) {
    pelota.velocidad.x *= -1;
    // Corrige la posición de la pelota para evitar que quede atrapada en las paredes
    if (pelota.posicion.x - pelota.radio < paredIzquierda) {
      pelota.posicion.x = paredIzquierda + pelota.radio;
    } else {
      pelota.posicion.x = paredDerecha - pelota.radio;
    }
  }

//========================================================================================
//ESTELA PUNTO 2.2
//========================================================================================
  // Agrega la posición actual de la pelota a la estela
  estela.add(pelota.posicion.copy());

  // Limita la longitud de la estela
  if (estela.size() > longitudEstela) {
    estela.remove(0);
  }
 
  // Dibuja la estela de partículas
  for (int i = 0; i < estela.size(); i++) {
    float alpha = map(i, 0, estela.size() - 1, 255, 0); // Opacidad decreciente
    fill(255, 0, 0, alpha);
    noStroke();
    PVector punto = estela.get(i);
    ellipse(punto.x, punto.y, 5, 5);
  }


//========================================================================================
//TEXTOS EN PANTALLA -> VELOCIDAD + DISTANCIA RECORRIDA PUNTO 2.1
//========================================================================================
  // Muestra la distancia recorrida y velocidad
  float distanciaRecorrida = dist(width / 4, techo + 15, pelota.posicion.x, pelota.posicion.y);
  String distanciaTexto = "Distancia recorrida: " + nf(distanciaRecorrida, 0, 2) + " px";
  String velocidadTexto = "Velocidad: " + nf(pelota.velocidad.mag(), 0, 2) + " px/frame";
  fill(0);
  textSize(20);
  text(distanciaTexto, 20, height - 560);
  text(velocidadTexto, 20, height - 535);

  // Texto para ESC - cerrar
  textSize(20);
  text("Presione ESC para cerrar", width - 300, height - 560);

  // Texto para reiniciar
  textSize(20);
  text("Presione R para reiniciar la pelota", width - 300, height - 535);
  
  // Texto para CLICK
  textSize(20);
  text("Click en la pelota para moverla", width - 300, height - 510);
}

//========================================================================================
//RESET SOFTWARE
//========================================================================================
void keyPressed() {
  if (key == 'r' || key == 'R') {
    pelota.reiniciar(); // Reiniciar la pelota al presionar la tecla "R"
    estela.clear(); // Limpiar la estela al reiniciar
  }
}

void mousePressed() {
  // Verifica si se hizo clic en la pelota
  float d = dist(mouseX, mouseY, pelota.posicion.x, pelota.posicion.y);
  if (d < pelota.radio) {
    arrastrandoPelota = true;
    offset = new PVector(pelota.posicion.x - mouseX, pelota.posicion.y - mouseY);
  }
}

void mouseReleased() {
  arrastrandoPelota = false;
}

//========================================================================================
//MUEVE LA PELOTA CON EL MOUSE
//========================================================================================
void mouseDragged() {
  // Arrastra la pelota con el ratón si se está haciendo clic en ella
  if (arrastrandoPelota) {
    pelota.posicion.x = mouseX + offset.x;
    pelota.posicion.y = mouseY + offset.y;
  }
}

//========================================================================================
//CLASE PELOTA QUE CONTIENE SUS RESPECTIVAS PROPIEDADES
//PUNTO 2.1
//========================================================================================

class Ball {
  PVector posicion;
  PVector velocidad;
  float radio;
  PVector posicionInicial;
  PVector velocidadInicial;

  Ball(float x, float y, float radio, float velocidadX, float velocidadY) {
    posicion = new PVector(x, y);
    velocidad = new PVector(velocidadX, velocidadY);
    this.radio = radio;
    posicionInicial = new PVector(x, y); // Guarda la posición inicial
    velocidadInicial = new PVector(velocidadX, velocidadY); // Guarda la velocidad inicial
  }

//========================================================================================
//ACTUALIZA LA GRAVEDAD Y POSICION + VELOCIDAD
//========================================================================================
  void actualizar() {
    // Aplicar gravedad
    velocidad.add(0, 0.5); // Gravedad
    posicion.add(velocidad);

    // Colisión con el suelo
    float ySuelo = suelo - (posicion.x - paredIzquierda) * pendienteSuelo;
    if (posicion.y > ySuelo - radio) {
      posicion.y = ySuelo - radio;
      velocidad.y *= -0.8; // Rebote
    }
  }


//========================================================================================
//PELOTA FISICA 2D
//========================================================================================
  void mostrar() {
    fill(255, 0, 0);
    ellipse(posicion.x, posicion.y, radio * 2, radio * 2);
  }

//========================================================================================
//REINICIA LA PELOTA Y SUS CORDENADAS
//========================================================================================
  void reiniciar() {
    posicion.set(posicionInicial); // Restablece la posición
    velocidad.set(velocidadInicial); // Restablece la velocidad
  }
}
