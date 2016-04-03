class Symbol
{
  PShape symbol;
  String name;
  String type;
  
  Symbol(String n)
  {
    name=n;

    if(name.equals("joker.svg")) type="joker";
    else if(name.length()<=8) type="letter";
    else if(name.length()>8) type="picture";
    
    symbol=loadShape(name);
   
  }
  
  boolean isEqual(Symbol symbol)
  {
    if(this.type.equals("letter") || symbol.type.equals("letter")) {return false;}
    if(this.type.equals(symbol.type)==false) {return false;}
    else if(this.name.equals(symbol.name)==false) {return false;}
    return true;
  }
  
  void displaySymbol(float posX, float posY, float cW, float cH)
  {
    shape(symbol,posX,posY,cW,cH);
  }
}
