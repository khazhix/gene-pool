
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
    ellipse(x,y,pop/10,pop/10);
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
    if ((px - x) * (px - x) + (py - y) * (py - y) <= pop*pop/400.0){
      return true;
    }
    return false;
  }
  
  void displayInfo(){
    fill(0);
    rect(imgW, 0, width-imgW,800);
    textSize(20);
    fill(255);
    text("CITY INFO", imgW+50, 40);
    text("Eye color:", imgW+50, 70);
    text("Blue   " + eCol[0], imgW+50, 100);
    text("Brown " + eCol[1], imgW+50, 130);
    text("Green " + eCol[2], imgW+50, 160);
    text("Gray  " + eCol[3], imgW+50, 190);
    text("Skin color:", imgW+50, 220);
    text("Light  " + sCol[0], imgW+50, 250);
    text("White  " + sCol[1], imgW+50, 280);
    text("Medium " + sCol[2], imgW+50, 310);
    text("Olive  " + sCol[3], imgW+50, 340);
    text("Brown  " + sCol[4], imgW+50, 370);
    text("Black  " + sCol[5], imgW+50, 400);
    
  }
}
