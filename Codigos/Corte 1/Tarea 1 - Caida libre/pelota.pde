class pelota{
  float m_xPos;
  float m_yPos;
  float m_rX = 50;
  float m_rY = 50;
  
  pelota(int xPos, int yPos, int rX, int rY){
    m_xPos = xPos;
    m_yPos = yPos;
    m_rX = rX;
    m_rY = rY;
  }
  
  void actualizarPos(float distX, float distY){
    m_xPos += distX;
    m_yPos += distY;
  }
  
  void dibujar(){
    ellipse(m_xPos,m_yPos,m_rX,m_rY);
  }
}
