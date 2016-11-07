
class City {
  float x, y;
  int maxP;
  int pop;
  Person[] citizen;
  int male;
  int female;
  
  int[] eCol = new int[5];
  int[] hCol = new int[6];
  int[] sCol = new int[6];
  int[] bTp =  new int[5];
  int[] deadC;
  
  City(float posX, float posY, int mxP){
    x = posX;
    y = posY;
    maxP = mxP;
    pop = 0;
    citizen = new Person[mxP];
    deadC = new int[mxP + 1];
    male = 0;
    female = 0;
    for (int i = 0; i < maxP; i++){
      citizen[i] = new Person(0);
      citizen[i].kill();
      deadC[i + 1] = i;
    }
    deadC[0] = maxP;
  }
  
  void display(){
    fill(127,220, 247,100);
    noStroke();
    ellipse(x,y,pop/1000.0,pop/1000.0);
  }
  
  void addPerson(Person p){
    if (pop < maxP){
      pop++;
      
      eCol[int((p.getTrait() >> 15) & 3)]++;
      sCol[int((p.getTrait() >> 12) & 7)]++;
      hCol[int((p.getTrait() >> 10) & 3)]++;
      bTp[int(p.getTrait() & 3)]++;
      if (int(p.getTrait() >> 17) == 1){
        male++;
        citizen[deadC[deadC[0]]] = p;
        deadC[0]--;
      } else {
        female++;
        citizen[deadC[deadC[0]]] = p;
        deadC[0]--;
      }
    }
  }
  
  void update(){
    for (int i = 0; i < maxP; i++){
      if (citizen[i].isAlive()){
        citizen[i].getOlder();
        if (!citizen[i].isAlive()){
          pop--;
          eCol[int((citizen[i].getTrait() >> 15) & 3)]--;
          sCol[int((citizen[i].getTrait() >> 12) & 7)]--;
          hCol[int((citizen[i].getTrait() >> 10) & 3)]--;
          bTp[int(citizen[i].getTrait() & 3)]--;
          deadC[++deadC[0]] = i;
          if (int(citizen[i].getTrait() >> 17) == 1) male--;
          else female--;
        }
      }
      
    }
    
    int childs = int((pop / 1000.0) * 28.6);
    while (pop < maxP && childs > 0 && male != 0 && female != 0){
      int man = int(random(maxP-0.1));
      int woman = int(random(maxP-0.1));
      addPerson(citizen[man].sex(citizen[woman]));
      childs--;
    }
  }
  
  void relocate(City ct){
     int r_guy = int(random(maxP-0.1));
     if (!ct.overPop() && citizen[r_guy].isAlive()){
       eCol[int((citizen[r_guy].getTrait() >> 15) & 3)]--;
       sCol[int((citizen[r_guy].getTrait() >> 12) & 7)]--;
       hCol[int((citizen[r_guy].getTrait() >> 10) & 3)]--;
       bTp[int(citizen[r_guy].getTrait() & 3)]--;
       ct.addPerson(citizen[r_guy]);
       citizen[r_guy].kill();
       pop--;
       deadC[++deadC[0]] = r_guy;
     }
     stroke(255, 50);
     line(x,y,ct.getX(),ct.getY());
     noStroke();
  }
  
  int getPop(){
    return pop;
  }
  
  float getX() {return x;}
  float getY() {return y;}
  
  boolean overPop(){
    if (pop < maxP){
      return false;
    }
    return true;
  }
  
  boolean inRange(float px, float py){
    if ((px - x) * (px - x) + (py - y) * (py - y) <= pop*pop/1000000.0){
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
  
  color getHcol(int id){
    switch (id){
      case 0: return color(38,50,56);
      case 1: return color(62,39,35);
      case 2: return color(191,54,12);
      case 3: return color(255,241,118);
      default: return color(0,0,0);
    }
  }
  
  void displayInfo(){
    fill(0);
    rect(imgW, 0, width-imgW,800);
    fill(255);
    text("CITY INFO", imgW+80, 40);
    noFill();
    strokeWeight(8);
    PImage icon;
    icon = loadImage("eye.png");
    image(icon,imgW,60, 52, 52);
    for (int i = 0; i < 4; i++){
      stroke(getEcol(i));
      line(imgW+82, 70+(i*20), imgW+102,70+(i*20));
      text(eCol[i], imgW+112, 75+(i*20));
    }
    icon = loadImage("skin.png");
    image(icon,imgW,160,52,52);
    for (int i = 0; i < 6; i++){
      stroke(getScol(i));
      line(imgW+82, 170+(i*20), imgW+102,170+(i*20));
      text(sCol[i], imgW+112, 175+(i*20));
    }
    
    icon = loadImage("hair.png");
    image(icon,imgW,300,52,52);
    for (int i = 0; i < 4; i++){
      stroke(getHcol(i));
      line(imgW+82, 310+(i*20), imgW+102,310+(i*20));
      text(hCol[i], imgW+112, 315+(i*20));
    }
    
    icon = loadImage("blood.png");
    image(icon,imgW,400,52,52);
    text("A", imgW+82, 415);
    text("B", imgW+80, 435);
    text("AB", imgW+82, 455);
    text("O", imgW+82, 475);
    text(bTp[0], imgW+112, 415);
    text(bTp[1], imgW+112, 435);
    text(bTp[2], imgW+112, 455);
    text(bTp[3], imgW+112, 475);
    
    noStroke();
    strokeWeight(1);
  }
}