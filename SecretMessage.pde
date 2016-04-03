import controlP5.*;
//input
ControlP5 cp5; 
String secretMessage="";
PFont inputFont=createFont("Nyala",30);
String a;
String[] words;

int numCards;
int columns;
int rows;
ArrayList<Card> cards= new ArrayList<Card>();
float playX=20;
float playY=20;
float cardWidth=100;
float cardHeight=130;
ArrayList<Symbol> letters= new ArrayList<Symbol>();
ArrayList<Symbol> mixed=new ArrayList<Symbol>();
ArrayList<Symbol> pictures=new ArrayList<Symbol>();
String[] picturesNames={"flower.svg","house.svg","birdy.svg","mydeer.svg","sheep.svg","mouse.svg","mysun.svg","person.svg"};
boolean textDisplay=true;

ArrayList<Card> cardsClicked = new ArrayList<Card>();
float time, delay;

ArrayList<Card> message = new ArrayList<Card>();
float mesX=30;
float mesY=30;
float speed=4;
boolean timerSet = false;
boolean facesFinished=false; //face ready for all
boolean backsFinished=false; //back ready for all
 
 
void setup()
{
  size(1550, 800);  

  //input
  cp5 = new ControlP5(this);
  cp5.addTextfield("input").setPosition(190, 750).setSize(810, 40).setAutoClear(false).setFont(inputFont);
  cp5.addBang("Submit").setPosition(1010, 750).setSize(100, 40).getCaptionLabel().setFont(inputFont).align(ControlP5.CENTER, ControlP5.CENTER);
}
 
 
void draw ()
{
  //PImage cloth=loadImage("1.jpg");
  // cloth.resize(1550,800);
  //background(cloth);
 
 // background(250,250,210);
 background(245,239,204);
  
  //input
  fill(0);
  textFont(inputFont);
  if(textDisplay==false) {textSize(0);}
  text("Please enter you secret message here and then press the Submit button!", 190,730);
 
  if(cards.size()>letters.size())
  {
    //display cards
    displayCardsTable();
    
    if(facesFinished==false)
    {
      for(int i=0;i<cardsClicked.size();i++)
      {
        if(cardsClicked.get(i).faceReady==false)
        cardsClicked.get(i).flipAni();
      }
      if(cardsClicked.size()==2 && cardsClicked.get(0).faceReady==true && cardsClicked.get(1).faceReady==true)
      {
        facesFinished=true;
      }
    }
      if((millis()-time)>=1000 && facesFinished==true)
      {
        //letter found -> flip back
        if(cardsClicked.get(0).face.type.equals("letter") || cardsClicked.get(1).face.type.equals("letter"))
        {
          for(int i=0;i<2;i++)
          {
            if(cardsClicked.get(i).backReady==false)
            cardsClicked.get(i).flipAni();
          }
          if(cardsClicked.get(0).backReady==true && cardsClicked.get(1).backReady==true)
          {
            backsFinished=true;
          }
        }
        
        //match found -> remove
        else if(cardsClicked.get(0).face.isEqual(cardsClicked.get(1).face) && facesFinished==true)
        {
          for(int i=0;i<2;i++)
          {
            if(cardsClicked.get(i).isAway==false)
            {
              cardsClicked.get(i).goAway();
            }
            if(cardsClicked.get(i).isAway==true)
            {
              cards.remove(cards.indexOf(cardsClicked.get(i)));
            }
          }
          if(cardsClicked.get(0).isAway==true && cardsClicked.get(1).isAway==true)
          {
            backsFinished=true;
          }
        }
        //two different pictures -> turn backs
        else
        {
           for(int i=0;i<2;i++)
          {
            if(cardsClicked.get(i).backReady==false)
            cardsClicked.get(i).flipAni();
          }
          if(cardsClicked.get(0).backReady==true && cardsClicked.get(1).backReady==true)
          {
            backsFinished=true;
          }
        }
        
        if(backsFinished==true)
        {
          backsFinished=false;
          facesFinished=false;
          cardsClicked.clear();
        }
      }
      
    //joker
    if(cardsClicked.size()==1 && cardsClicked.get(0).face.type.equals("joker") && cardsClicked.get(0).faceReady)
    {
      if((millis()-time)>=1000)
      {    
        if(cardsClicked.get(0).isAway==false)
        {
          cardsClicked.get(0).goAway();
        }
        if(cardsClicked.get(0).isAway==true)
        {
          println("delete joker");
          cards.remove(cards.indexOf(cardsClicked.get(0)));
          cardsClicked.clear();
        }
      }
    }
    
    
  }
  
  else if(cards.size()==letters.size() && letters.size() > 0)
  {
    if(!timerSet){
      delay = millis();
      timerSet = true;
    }
    
     if(millis()-delay<=2000){
       for(int i=0; i<cards.size(); i++)
       {
         if(cards.get(i).faceReady==false) {cards.get(i).flipAni();}
         else if (cards.get(i).isAway==false && millis()-delay>=1500) cards.get(i).goAway();
         cards.get(i).displayCards();   
       }
     }
     else
     {
        showMessage();   
     }
  }
}


void displayCardsTable()
{
  for(int i=0;i<cards.size();i++) { cards.get(i).displayCards();}
}

 
//input
void Submit()
{
    textDisplay=false;
    secretMessage = cp5.get(Textfield.class,"input").getText();
    println("You submitted your secret message: '"+secretMessage+"', which has legth "+secretMessage.length());
    cp5.hide();
    createPlayTable();
    createMessageTable();
}

void controlEvent(ControlEvent theEvent)
{
  if(theEvent.isAssignableFrom(Textfield.class))
  {
    println("controlEvent: accessing a string from controller '"+theEvent.getName()+"': "+theEvent.getStringValue());
  }
}


void createMessageTable()
{
  int numChar=secretMessage.replaceAll(" ", "").length();
   mesY=30;
   words=split(secretMessage," ");
   
   int iter=0;
   
   for(int i=0;i<words.length;i++)
   {
     for(int j=iter;j<letters.size();j++)
     {
       message.add(new Card(mesX+cardWidth/2, mesY+cardHeight/2, 0, 0, letters.get(j)));
       mesX+=(cardWidth+10);
       
       if(j==iter+words[i].length()-1){
         iter+=words[i].length();
         break;
       }     
     }
     mesX=30;
     mesY+=(cardHeight+10);
   } 
   for(int i=0;i<message.size();i++)
   {
     message.get(i).flip();
   }
}

void showMessage()
{
 for(int i=0;i<message.size();i++)
 {
   message.get(i).showMe();
   message.get(i).displayCards();
 }
}


void createPlayTable()
{
  int numChar=secretMessage.replaceAll(" ", "").length();
  String lettersInMessage=secretMessage.replaceAll(" ","");
  //println("Num characters to work with: "+numChar+" and letters: "+lettersInMessage);
  
  for(int i=0;i<numChar;i++)
  {
    //create Letter Symbols an put them in an array
    if(lettersInMessage.charAt(i)!='!' && lettersInMessage.charAt(i)!='.' && lettersInMessage.charAt(i)!='?' && lettersInMessage.charAt(i)!=',')
    {
      if(lettersInMessage.charAt(i)==lettersInMessage.toUpperCase().charAt(i)) {letters.add(new Symbol(lettersInMessage.toLowerCase().charAt(i)+"big.svg"));}
      else letters.add(new Symbol(lettersInMessage.charAt(i)+".svg"));
    }
    else if(lettersInMessage.charAt(i)=='!') letters.add(new Symbol("wow.svg"));
    else if(lettersInMessage.charAt(i)=='.') letters.add(new Symbol("dot.svg"));
    else if(lettersInMessage.charAt(i)=='?') letters.add(new Symbol("why.svg"));
    else if(lettersInMessage.charAt(i)==',') letters.add(new Symbol("komm.svg"));
  }
  //println("The letters array has "+letters.size()+" symbols in it!");
  
  columns= numChar/2+3;
  numCards= numChar*2;
  rows=0;
  
  while(rows==0)
  {
    if(numCards % columns == 0)
    {
      rows=numCards/columns;
    }
    else{numCards+=2;}
  }
  //println("Table with Columns: "+columns+" and Rows: "+rows+" and Number of Cards: "+numCards);
  
  
  //create array with the pictures needed
  int numPics=numCards-numChar;
  pictures=new ArrayList<Symbol>(numPics);
  if(numPics%2!=0)
  {
    pictures.add(new Symbol("joker.svg"));
    for(int i=1;i<numPics;i+=2)
    {
      String randomName = picturesNames[int(random(picturesNames.length))];
      pictures.add(new Symbol(randomName));
      pictures.add(new Symbol(randomName));
    }
  }
  else
  {
    for(int i=0;i<numPics;i+=2)
    {
      String randomName = picturesNames[int(random(picturesNames.length))];
      pictures.add(new Symbol(randomName));
      pictures.add(new Symbol(randomName));
    }
  }
  
  //create mixed array with all symbols
  mixed=new ArrayList<Symbol>(numCards);
  //fill the letters in the mixed array
  for(int i=0;i<letters.size();i++) { mixed.add(letters.get(i));}
  for(int i=0;i<pictures.size();i++) { mixed.add(pictures.get(i));}
  //println("Array Mixed has "+mixed.size()+" symbols out of "+numCards);
  
  
  //create all cards in an array
  cards= new ArrayList<Card>(numCards);
  for(int k=0;k<rows;k++)
  {
    for(int j=0;j<columns;j++)
    {
      int index=int(random(mixed.size()));
      cards.add(new Card(playX,playY,cardWidth,cardHeight,mixed.get(index)));
      mixed.remove(index);
      //println("Size of Mixed: "+mixed.size());
      
      playX+=(cardWidth+20);
    }
    
    playX=20;
    playY+=(cardHeight+20);
  }
  //for(int i=0;i<cards.size();i++) { println("Card Name: "+cards.get(i).face.name+" with coordinates "+cards.get(i).posX+" and "+cards.get(i).posY+" and type "+cards.get(i).face.type);}
  
}


void mouseClicked()
{
  if(cardsClicked.size()<2)
  {
    for(int i=0;i<cards.size();i++)
    {
      if(mouseX>cards.get(i).posX && mouseX<(cards.get(i).posX+cardWidth) && mouseY>cards.get(i).posY && mouseY<(cards.get(i).posY+cardHeight))
      {
        time=millis();
       if(cardsClicked.contains(cards.get(i))==false)
       {
         cardsClicked.add(cards.get(i));
       }        
        break;
      }
    }
     
  }

}
