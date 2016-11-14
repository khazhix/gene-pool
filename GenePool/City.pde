
class City {
  float x, y, birthRate;
  int maxP;
  int pop;
  float Arc;
  String cityName;
  Person[] man;
  Person[] woman;
  
  int[] eyeCol    = new int[6];
  int[] hairCol   = new int[6];
  int[] skinCol   = new int[8];
  int[] bloodType =  new int[5];
  int[] deadM;
  int[] deadW;
  int male;
  int female;
  int boy;
  int girl;
  int disp;
  
  City(float posX, float posY, int mxP, float bRate, String ctName){
    x      = posX;
    y      = posY;
    maxP   = mxP;
    male   = 0;
    female = 0;
    boy    = 0;
    girl   = 0;
    pop    = 0;
    Arc    = 0;
    disp   = 0;
    man    = new Person[mxP/2];
    woman  = new Person[mxP/2];
    deadM  = new int[(mxP/2)+1];
    deadW  = new int[(mxP/2)+1];
    birthRate = bRate;
    cityName  = ctName; 
    int[][] gen = new int[10][2];
    for (int i = 0; i < maxP / 2; i++){
      man[i]   = new Person(gen, 0);
      woman[i] = new Person(gen, 1);
      man[i].kill();
      woman[i].kill();
      deadM[i + 1] = i;
      deadW[i + 1] = i;
    }
    deadM[0] = maxP/2;
    deadW[0] = maxP/2;
  }
  
  void display(){
    fill(255,255, 255,200);
    noStroke();
    ellipse(x,y,5,5);
    noFill();
    smooth();
    stroke(150);
    arc(x,y, Arc,Arc, 0, TWO_PI);
    Arc += 2;
    if (Arc > 30){
      Arc = 0;
    }
    noStroke();
  }
  
  void addPerson(Person p){
    if (pop < maxP && (p.gender() == 0 && deadM[0] != 0 
    || p.gender() == 1 && deadW[0] != 0)){
      pop++;
      eyeCol[p.getEyeColor()]++;
      skinCol[p.getSkinColor()]++;
      hairCol[p.getHairColor()]++;
      bloodType[p.getBloodType()]++;
      
      if (p.gender() == 0){
        male++;
        boy++;
        man[deadM[deadM[0]]].Copy(p);
        deadM[0]--;
      } else {
        girl++;
        female++;
        woman[deadW[deadW[0]]].Copy(p);
        deadW[0]--;
      }
    }
  }
  
  void update(){
    for (int i = 0; i < maxP / 2; i++){
      if (man[i].isAlive()){
        if (!man[i].getOlder()){
          kill(i, 0);
        }
      }
      if (woman[i].isAlive()){
        if (!woman[i].getOlder()){
          kill(i, 1);
        }
      }
    }
    
    int childs = int((pop / 1000.0) * birthRate);
    while (pop < maxP && childs > 0 && male != 0 && female != 0){
      int m = int(random(maxP/2));
      int w = int(random(maxP/2));
      if (man[m].isAlive() && woman[w].isAlive()) {
        addPerson(man[m].sex(woman[w]));
        childs--;
      }
    }
  }
  
  void kill(int cId, int gnd){
    if (gnd == 0){
      hairCol[man[cId].getHairColor()]--;
      eyeCol[man[cId].getEyeColor()]--;
      bloodType[man[cId].getBloodType()]--;
      skinCol[man[cId].getSkinColor()]--;
      male--;
      deadM[++deadM[0]] = cId;
      man[cId].kill();
    } else {
      hairCol[woman[cId].getHairColor()]--;
      eyeCol[woman[cId].getEyeColor()]--;
      bloodType[woman[cId].getBloodType()]--;
      skinCol[woman[cId].getSkinColor()]--;
      female--;
      deadW[++deadW[0]] = cId;
      woman[cId].kill();
    }
    pop--;
  }
  
  boolean relocate(City ct){
     int r_guy = int(random(maxP/2));
     int gn    = int(random(2));
     if (!ct.overPop(gn)){
       if (gn == 0 && man[r_guy].isAlive()){
         ct.addPerson(man[r_guy]);
         kill(r_guy, gn);
         stroke(255, 50);
         line(x,y,ct.getX(),ct.getY());
         noStroke();
         return true;
       }
       else if (gn == 1 && woman[r_guy].isAlive()){
         ct.addPerson(man[r_guy]);
         kill(r_guy, gn);
         stroke(255, 50);
         line(x,y,ct.getX(),ct.getY());
         noStroke();
         return true;
       }
     } else {
       return true;
     }
     return false;
  }
  
  int getPop(){
    return pop;
  }
  
  float getX() {return x;}
  float getY() {return y;}
  
  boolean overPop(int gender){
    if (gender == 0 && male < maxP / 2
     || gender == 1 && female < maxP / 2){
      return false;
    }
    return true;
  }
  
  boolean inRange(float px, float py){
    if ((px - x) * (px - x) + (py - y) * (py - y) <= 100){
      return true;
    }
    disp = 0;
    return false;
  }
  
  int getMale(){
    return male;
  }
  int getFemale(){
    return female;
  }
  int getEye(int id){
    return eyeCol[id];
  }
  int getSkin(int id){
    return skinCol[id];
  }
  int getHair(int id){
    return hairCol[id];
  }
  int getBlood(int id){
    return bloodType[id];
  }
  
  color getEcol(int id){
    switch (id){
      case 2: return color(52,152,219);
      case 0: return color(211,84,0);
      case 1: return color(46,204,113);
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
      case 6: return color(20,20,20);
      default: return color(0,0,0);
    }
  }
  
  color getHcol(int id){
    switch (id){
      case 0: return color(67,56,54);
      case 1: return color(101,68,53);
      case 2: return color(127,85,47);
      case 3: return color(201,153,71);
      case 4: return color(224,199,159);
      default: return color(0,0,0);
    }
  }
  
  void displayInfo(){
    fill(0);
    noStroke();
    rect(imgW, 0, width-imgW,800);
    fill(255);
    disp+=3;
    textSize(20);
    text(cityName, imgW+80, 40);
    noFill();
    strokeWeight(4);
    PImage icon;
    icon = loadImage("eye.png");
    image(icon,imgW+20,60, 30, 30);
    for (int i = 0; i < 3; i++){
      stroke(getEcol(i));
      line(imgW+82, 70+(i*20), imgW+92,70+(i*20));
      text(eyeCol[i], imgW+112, 75+(i*20));
    }
    icon = loadImage("skin.png");
    image(icon,imgW+20,160,30,30);
    for (int i = 0; i < 7; i++){
      stroke(getScol(i));
      line(imgW+82, 170+(i*20), imgW+92,170+(i*20));
      text(skinCol[i], imgW+112, 175+(i*20));
    }
    
    icon = loadImage("hair.png");
    image(icon,imgW+20,320,30,30);
    for (int i = 0; i < 5; i++){
      stroke(getHcol(i));
      line(imgW+82, 330+(i*20), imgW+92,330+(i*20));
      text(hairCol[i], imgW+112, 335+(i*20));
    }
    
    icon = loadImage("blood.png");
    image(icon,imgW+20,440,30,30);
    text("A", imgW+82, 455);
    text("B", imgW+80, 475);
    text("AB", imgW+82, 495);
    text("O", imgW+82, 515);
    text(bloodType[0], imgW+112, 455);
    text(bloodType[1], imgW+112, 475);
    text(bloodType[2], imgW+112, 495);
    text(bloodType[3], imgW+112, 515);
    stroke(255);
    strokeWeight(1);
    line(imgW+80, 20, imgW+80+min(disp, 33), 20);
    line(imgW+113, 20, imgW+113+min(disp, 33), 20);
    line(imgW+146, 20, imgW+146+min(disp, 33), 20);
    line(x, y + 20, x+5, y + 15);
    line(x, y + 20, x-5, y + 15);
    line(x, y - 20, x+5, y - 15);
    line(x, y - 20, x-5, y - 15);
    line(x - 20, y, x - 15, y+5);
    line(x - 20, y, x - 15, y-5);
    line(x + 20, y, x + 15, y+5);
    line(x + 20, y, x + 15, y-5);
    noStroke();
  }
}