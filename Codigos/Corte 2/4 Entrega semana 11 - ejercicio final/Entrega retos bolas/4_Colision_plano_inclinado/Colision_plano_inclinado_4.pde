/*
DAVID JOSUE PINTO GOMEZ - 1202363

CODIGO DE BOLA COLISIONANDO EN PLANO INCLINADO
RETO 4/5

SE TRABAJO A PUNTA DE VECTORES YA QUE ES EL METODO QUE RETORNA 
DATOS MAS PRECISOS Y SIN FALLAS CUANDO SE UTILIZAN VARIABLES DEPENDIENTES
*/

Bola bola;
Linea linea;

//IMPLEMENTACION DE PERDIDA DE ENERGIA A PARTIR DEL COEFICIENTE DE RESTITUCION
float coeficienteRestitucion = 0.8; // Ajusta el coeficiente según lo desees

void setup() {
  size(800, 600);
  frameRate(60);
  
  // Inicializa la bola y la línea inclinada
  bola = new Bola(width - 600, height - 360, 20);
  linea = new Linea(width - 700, height / 2, radians(20), 600);
}

void draw() {
  background(255);
  
  // Calcula la gravedad
  PVector gravedad = new PVector(0, 0.2);
  bola.aplicarFuerza(gravedad);
  
  // Verifica si la bola colisiona con los bordes de la ventana
  bola.rebotarEnBordes();
  
  // Actualiza la posición de la bola
  bola.actualizar();
  
  // Verifica si la bola colisiona con la línea inclinada
  if (bola.colision(linea)) {
    bola.rebotar(linea);
  }
  
  // Dibuja la línea y la bola
  linea.mostrar();
  bola.mostrar();
}

//CLASES PARA LA BOLA Y LINEA
//=================================================================================
//CLASE PARA LA BOLA
//=================================================================================
class Bola {
  PVector posicion;
  PVector velocidad;
  float radio;
  
  Bola(float x, float y, float r) {
    posicion = new PVector(x, y);
    velocidad = new PVector(0, 0);
    radio = r;
  }
  
  void aplicarFuerza(PVector fuerza) {
    PVector f = fuerza.copy();
    f.div(1); // Divide la fuerza por la masa (que es 1 en este caso)
    velocidad.add(f);
  }
  
  void actualizar() {
    posicion.add(velocidad);
  }
  
  void mostrar() {
    ellipse(posicion.x, posicion.y, radio * 2, radio * 2);
  }
  
    //CALCULA LA COLISION CON LA LINEA
  boolean colision(Linea linea) {
  // Calcula la posición de la bola en relación con la línea inclinada
  PVector puntoDeColision = posicion.copy();
  puntoDeColision.sub(linea.inicio); // Resta la posición inicial de la línea inclinada
  puntoDeColision.rotate(-linea.angulo); // Gira el punto según el ángulo negativo de la línea inclinada
  
  // Comprueba si el punto de colisión está dentro de la longitud de la línea inclinada
  if (puntoDeColision.x >= 0 && puntoDeColision.x <= linea.longitud) {
    // Comprueba si la bola está por debajo de la línea inclinada en la coordenada y
    float distanciaALinea = abs(puntoDeColision.y);
    return distanciaALinea <= radio;
  }
  
  return false;
}

//CALCULA EL REBOTE CON LA LINEA
void rebotar(Linea linea) {
  // Calcula la velocidad en la dirección perpendicular a la línea inclinada
  PVector velocidadNormal = velocidad.copy();
  velocidadNormal.rotate(-linea.angulo);
  
  // Invierte la velocidad normal para el rebote
  velocidadNormal.y *= -1;
  
  // Aplica la rotación inversa al vector de velocidad normal
  velocidadNormal.rotate(linea.angulo);
  
  // Actualiza la velocidad de la bola con la velocidad rebote
  velocidad = velocidadNormal;
}

//CALCULA EL REBOTE EN PAREDES O BORDE DE LA VENTANA
  void rebotarEnBordes() {
    if (posicion.x < radio || posicion.x > width - radio) {
      velocidad.x *= -coeficienteRestitucion; // Pérdida de energía en la dirección x
    }
    if (posicion.y > height - radio) {
      velocidad.y *= -coeficienteRestitucion; // Pérdida de energía en la dirección y
      // Restringe la posición vertical para evitar que la bola "se pegue" al suelo
      posicion.y = height - radio;
    }
  }

  void detener() {
    velocidad.set(0, 0);
  }

  void reanudar() {
    // Continuar con la velocidad anterior
  }

}

//=================================================================================
//CLASE PARA LA LINEA
//=================================================================================
class Linea {
  PVector inicio;
  float longitud;
  float angulo;
  
  Linea(float x, float y, float a, float l) {
    inicio = new PVector(x, y);
    angulo = a;
    longitud = l;
  }
  
  void mostrar() {
    pushMatrix();
    translate(inicio.x, inicio.y);
    rotate(angulo);
    line(0, 0, longitud, 0);
    popMatrix();
  }
}
