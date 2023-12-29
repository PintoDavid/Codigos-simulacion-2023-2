class Bola{
  float x,y,radio;
  float vx,vy,masa;
  Bola(float x_, float y_, float radio_){
    x=x_;
    y=y_;
    radio=radio_;
    vy=0;  //solo es  para colision horizontal
    vx=random(3,10);  //la velocidad en x puede ver cualquiera para las bolas entre 3 a 5
    
    //la masa es proporcional al radio
    masa= radio/50;  //la masa de toda la vida y sencilla de calcular para su respectiva colision
  }
  void muestra(){  //dibuja las bolas en pantalla
    fill(255,0,0);
    ellipse(x,y,2*radio,2*radio);
  }
  void movimiento(){  //le da movimiento a las bolas en sus respectivos ejes
    x += vx;
    y += vy;
    if(x > width - radio){
        x = width - radio;
        vx = -vx;
    }
    if(x < radio){
        x = radio;
        vx = -vx;
    }
    
  }
}
