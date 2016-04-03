class Card
{
  float posX=0;
  float posY=0;
  float cardWidth=0;
  float cardHeight=0;
  Symbol face;
  PShape back=loadShape("back.svg");
  boolean side=false; //back=false, front=true
  boolean half=false;
  boolean faceReady=false;
  boolean backReady=true;
  float pX;
  boolean isAway=false;
  
  Card(float x, float y, float cW, float cH, Symbol f)
  {
    posX=x;
    posY=y;
    cardWidth=cW;
    cardHeight=cH;
    face=f;
    pX=x;
  }
  
  void flip()
  {
    if(side==true)
    {
      side=false;
    }
    else
    {
      side=true;
    }
  }
  
  void flipAni()
  {
    if(side==false && backReady == true)
    {
      backReady = false;    
    }
    else if(side == true && faceReady == true)
    {
      faceReady = false;
    }
      
    if(half==false)
    {
      if(cardWidth>0||posX<=pX)
      {
        cardWidth=cardWidth-2*speed;
        posX=posX+speed;
      }
      else
      {
        cardWidth=0;  
        half=true;
        posX=50+pX;
        flip();
      }
    }
    
    if(half==true)
    {
      if(cardWidth<100||posX>=pX)
      {
        cardWidth=cardWidth+2*speed; 
        posX=posX-speed;
      }
      else
      {
        cardWidth=100;
        half=false;
        posX=pX;
        if(side==false)
        { 
          backReady=true;         
        }
        else
        { 
          faceReady=true;
        } 
      }
    }
  }
  
  void goAway()
  {
    if(cardHeight>0)
    {
      posX=posX+speed;
      posY=posY+speed;
      cardWidth=cardWidth-2*speed;
      cardHeight=cardHeight-2*speed;
    }
    else
    {
      cardHeight=0;
      cardWidth=0;
      isAway=true;
    }
  }
  
  void showMe()
  {
    if(cardWidth<100)
    {
      posX=posX-speed;
      cardWidth=cardWidth+2*speed;
      posY=posY-speed;
      cardHeight=cardHeight+2*speed+2;
    }
    else
    {
      cardHeight=130;
      cardWidth=100;
    }
  }

  
  void displayBack()  //displays the back side of the card
  {
    shape(back,posX,posY,cardWidth,cardHeight);
  }
  void displayFace()
  {
    face.displaySymbol(posX,posY,cardWidth,cardHeight);
  }
  
  void displayCards()
  {
    if(side==true)
    {
      displayFace();
    }
    else
    {
      displayBack();
    }
  }
  
}  

    
