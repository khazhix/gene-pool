
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
  
  boolean addPerson(Person p){
    if (pop < maxP && (p.gender() == 0 && deadM[0] > 0 
    || p.gender() == 1 && deadW[0] > 0)){
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
      return true;
    }
    return false;
  }
  
  void update(){
    for (int i = 0; i < maxP / 2; i++){
      if (man[i].isAlive()){
        if (!man[i].getOlder(1 - (abs(y - equator) / equator))){
          kill(i, 0);
        } else if (man[i].age() == 18.0){
          boy--;
        }
      }
      if (woman[i].isAlive()){
        if (!woman[i].getOlder(1 - (abs(y - equator) / equator))){
          kill(i, 1);
        } else if (woman[i].age() == 18.0){
          girl--;
        }
      }
    }
    
    int childs = int((pop / 1000.0) * birthRate);
    while (pop < maxP && childs > 0 && male != 0 && female != 0 && male - boy > 0 && female - girl > 0){
      int m = int(random(maxP/2));
      int w = int(random(maxP/2));
      if (man[m].isAlive() && woman[w].isAlive() && man[m].isMature() && woman[w].isMature() && abs(man[m].age() - woman[w].age()) <= 20) {
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
      if (man[cId].age < 18)boy--;
      deadM[++deadM[0]] = cId;
      man[cId].kill();
    } else {
      hairCol[woman[cId].getHairColor()]--;
      eyeCol[woman[cId].getEyeColor()]--;
      bloodType[woman[cId].getBloodType()]--;
      skinCol[woman[cId].getSkinColor()]--;
      female--;
      if (woman[cId].age < 18)girl--;
      deadW[++deadW[0]] = cId;
      woman[cId].kill();
    }
    pop--;
  }
  
  boolean relocate(City ct){
     int r_guy = int(random(maxP/2));
     int gn    = int(random(2));
     if (!ct.overPop(gn)){
       if (gn == 0 && man[r_guy].isAlive() && ct.addPerson(man[r_guy])){
         kill(r_guy, gn);
         stroke(255, 50);
         line(x,y,ct.getX(),ct.getY());
         noStroke();
         return true;
       }
       else if (gn == 1 && woman[r_guy].isAlive() && ct.addPerson(woman[r_guy])){
         kill(r_guy, gn);
         stroke(255, 50);
         line(x,y,ct.getX(),ct.getY());
         noStroke();
         return true;
       }
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
  
  void displayInfo(int[] history, int[] cityData){
    stroke(255);
    strokeWeight(2);
    line(880, 30, 885,25);
    line(880, 30, 880,100);
    line(880, 100, 885,105);
    line(885, 105, 885,140);
    line(885, 140, 880,145);
    line(880, 145, 880,689);
    line(880, 689, 885,694);
    
    line(1180, 25, 1185,30);
    line(1185, 30, 1185,100);
    line(1185, 100, 1180,105);
    line(1180, 105, 1180,140);
    line(1180, 140, 1185,145);
    line(1185, 145, 1185,689);
    line(1185, 689, 1180,694);
    
    line(935, 30, 940, 25);
    line(940, 25, 1010, 25);
    line(1010, 25, 1015, 30);
    line(1015, 30, 1040, 30);
    line(1040, 30, 1045, 25);
    line(1045, 25, 1115, 25);
    line(1115, 25, 1120, 30);
    stroke(255,100);
    line(885, 122, 1180, 122);
    
    textSize(18);
    fill(255);
    textAlign(CENTER);
    text(cityName, 1027, 70);
    
    PImage icon;
    textSize(14);
    icon = loadImage("eye.png");
    image(icon, 1017,150, 20, 20);
    for (int i = 0; i < 3; i++){
      fill(getEcol(i));
      ellipse(1027, 190 + (i * 20), 10, 10);
      fill(255);
      text(cityData[i + 2], 950, 193 + (i * 20));
      text(history[i + 3], 1104, 193 + (i * 20));
    }
    
    strokeWeight(1);
    stroke(255,100);
    line(905, 245, 1160, 245);
    
    icon = loadImage("skin.png");
    image(icon, 1017,250, 20, 20);
    for (int i = 0; i < 7; i++){
      fill(getScol(i));
      ellipse(1027, 290 + (i * 20), 10, 10);
      fill(255);
      text(cityData[i + 5], 950, 293 + (i * 20));
      text(history[i + 6], 1104, 293 + (i * 20));
    }
    
    line(905, 425, 1160, 425);
    icon = loadImage("hair.png");
    image(icon, 1017,430, 20, 20);
    for (int i = 0; i < 5; i++){
      fill(getHcol(i));
      ellipse(1027, 470 + (i * 20), 10, 10);
      fill(255);
      text(cityData[i + 12], 950, 473 + (i * 20));
      text(history[i + 13], 1104, 473 + (i * 20));
    }
    
    line(905, 565, 1160, 565);
    icon = loadImage("blood.png");
    image(icon, 1017, 570, 20, 20);
    text("A",  1027, 620);
    text("A",  1027, 640);
    text("AB", 1027, 660);
    text("O",  1027, 680);
    text(cityData[17], 950, 620);
    text(cityData[18], 950, 640);
    text(cityData[19], 950, 660);
    text(cityData[20], 950, 680);
    text(history[18], 1104, 620);
    text(history[19], 1104, 640);
    text(history[20], 1104, 660);
    text(history[21], 1104, 680);
    
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