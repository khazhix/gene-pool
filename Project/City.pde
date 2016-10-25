
class City {
  float x, y;
  int maxP;
  int pop = 0;
  Person[] citizen;
  
  int[] eCol = new int[5];
  int[] hCol = new int[6];
  int[] sCol = new int[6];
  int[] bTp =  new int[5];
  
  City(float posX, float posY, int mxP){
    x = posX;
    y = posY;
    maxP = mxP;
    citizen = new Person[mxP];
  }
  
  void display(){
    fill(127,220, 247,100);
    noStroke();
    ellipse(x,y,pop/100,pop/100);
  }
  
  void addPerson(Person p){
    if (pop < maxP){
      citizen[pop] = p;
      pop++;
      
      eCol[int((p.getTrait() >> 15) & 3)]++;
      sCol[int((p.getTrait() >> 12) & 7)]++;
      hCol[int((p.getTrait() >> 10) & 3)]++;
      bTp[int(p.getTrait() & 3)]++;
    }
  }
  
  int getPop(){
    return pop;
  }
  
  boolean overPop(){
    if (pop < maxP){
      return false;
    }
    return true;
  }
  
  boolean inRange(float px, float py){
    if ((px - x) * (px - x) + (py - y) * (py - y) <= pop*pop/40000){
      return true;
    }
    return false;
  }
  
  color getEcol(int id){
    switch (id){
      case 0: return color(52,152,219);
      case 1: return color(211,84,0);
      case 2: return color(46,204,113);
      case 3: return color(149,165,166);
      default: return color(0,0,0);
    }
  }
  
  color getScol(int id){
    switch (id){
      case 0: return color(255,247,234);
      case 1: return color(243,229,200);
      case 2: return color(226,194,119);
      case 3: return color(152,107,76);
      case 4: return color(97,52,31);
      case 5: return color(66,51,56);
      default: return color(0,0,0);
    }
  }
  
  void displayInfo(){
    fill(0);
    rect(imgW, 0, width-imgW,800);
    fill(255);
    text("CITY INFO", imgW+80, 40);
    
    float prev = 0;
    noFill();
    strokeWeight(8);
    PImage icon;
    icon = loadImage("remove_red_eye_white_72x72.png");
    image(icon,imgW,50, 72, 72);
    for (int i = 0; i < 4; i++){
      stroke(getEcol(i));
      line(imgW+82, 70+(i*20), imgW+102,70+(i*20));
      text(eCol[i], imgW+112, 75+(i*20));
    }
    icon = loadImage("person_outline_white_72x72.png");
    image(icon,imgW,150,72,72);
    for (int i = 0; i < 6; i++){
      stroke(getScol(i));
      line(imgW+82, 170+(i*20), imgW+102,170+(i*20));
      text(sCol[i], imgW+112, 175+(i*20));
    }
    noStroke();
    
    println(prev);
  }
}
