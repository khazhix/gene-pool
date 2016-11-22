
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
      man[i]   = new Person(gen, 0, 0.0);
      woman[i] = new Person(gen, 1, 0.0);
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
        if (p.age() < 18)boy++;
        man[deadM[deadM[0]]].Copy(p);
        deadM[0]--;
      } else {
        if (p.age() < 18)girl++;
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
  
  void displayInfo(int[][] history, int[][] cityData, int year, int traits){
    stroke(255);
    strokeWeight(2);
    line(880, 60,  885, 55);
    line(880, 60,  880, 130);
    line(880, 130, 885, 135);
    line(885, 135, 885, 170);
    line(885, 170, 880, 175);
    line(880, 175, 880, 719);
    line(880, 719, 885, 724);
    
    line(1180, 55,  1185, 60);
    line(1185, 60,  1185, 130);
    line(1185, 130, 1180, 135);
    line(1180, 135, 1180, 170);
    line(1180, 170, 1185, 175);
    line(1185, 175, 1185, 719);
    line(1185, 719, 1180, 724);
    
    line(935,  60, 940,  55);
    line(940,  55, 1010, 55);
    line(1010, 55, 1015, 60);
    line(1015, 60, 1040, 60);
    line(1040, 60, 1045, 55);
    line(1045, 55, 1115, 55);
    line(1115, 55, 1120, 60);
    
    stroke(255,100);
    line(885, 152, 1180, 152);
    
    textSize(20);
    fill(255);
    textAlign(CENTER);
    text(cityName, 1027, 110);
    tint(255);
    textSize(14);
    icon = loadImage("visibility_white.png");
    image(icon, 1017,180, 20, 20);
    for (int i = 0; i < 3; i++){
      fill(getEcol(i));
      ellipse(1027, 220 + (i * 20), 10, 10);
      fill(255);
      text(cityData[year][i + 3], 950, 223 + (i * 20));
      text(history[year][i + 3], 1104, 223 + (i * 20));
    }
    
    strokeWeight(1);
    stroke(255,100);
    line(905, 275, 1160, 275);
    
    icon = loadImage("perm_identity_white.png");
    image(icon, 1017,280, 20, 20);
    for (int i = 0; i < 7; i++){
      fill(getScol(i));
      ellipse(1027, 320 + (i * 20), 10, 10);
      fill(255);
      text(cityData[year][i + 6], 950, 323 + (i * 20));
      text(history[year][i + 6], 1104, 323 + (i * 20));
    }
    
    line(905, 455, 1160, 455);
    icon = loadImage("face_white.png");
    image(icon, 1017,460, 20, 20);
    for (int i = 0; i < 5; i++){
      fill(getHcol(i));
      ellipse(1027, 500 + (i * 20), 10, 10);
      fill(255);
      text(cityData[year][i + 13], 950, 503 + (i * 20));
      text(history[year][i + 13], 1104, 503 + (i * 20));
    }
    
    line(905, 595, 1160, 595);
    icon = loadImage("invert_colors_white.png");
    image(icon, 1017, 600, 20, 20);
    text("A",  1027, 650);
    text("B",  1027, 670);
    text("AB", 1027, 690);
    text("O",  1027, 710);
    text(cityData[year][18], 950,  650);
    text(cityData[year][19], 950,  670);
    text(cityData[year][20], 950,  690);
    text(cityData[year][21], 950,  710);
    text(history[year][18],  1104, 650);
    text(history[year][19],  1104, 670);
    text(history[year][20],  1104, 690);
    text(history[year][21],  1104, 710);
    
    stroke(255);
    strokeWeight(1);
    line(imgW+80,  50, imgW+80+ min(disp, 33), 50);
    line(imgW+113, 50, imgW+113+min(disp, 33), 50);
    line(imgW+146, 50, imgW+146+min(disp, 33), 50);
    
    line(x, y + 20, x+5, y + 15);
    line(x, y + 20, x-5, y + 15);
    line(x, y - 20, x+5, y - 15);
    line(x, y - 20, x-5, y - 15);
    line(x - 20, y, x - 15, y+5);
    line(x - 20, y, x - 15, y-5);
    line(x + 20, y, x + 15, y+5);
    line(x + 20, y, x + 15, y-5);
    
    
    strokeWeight(2);
    
    line(450, 534, 455, 529);
    line(450, 534, 450, 604);
    line(450, 604, 455, 609);
    line(455, 609, 455, 644);
    line(455, 644, 450, 649);
    line(450, 649, 450, 719);
    line(450, 719, 455, 724);
    
    line(820, 529, 825, 534);
    line(825, 534, 825, 604);
    line(825, 604, 820, 609);
    line(820, 609, 820, 644);
    line(820, 644, 825, 649);
    line(825, 649, 825, 719);
    line(825, 719, 820, 724);
    
    line(540, 534, 545, 529);
    line(545, 529, 615, 529);
    line(615, 529, 620, 534);
    line(620, 534, 655, 534);
    line(655, 534, 660, 529);
    line(660, 529, 730, 529);
    line(730, 529, 735, 534);
    
    stroke(255,100);
    line(455,626, 820, 626);
    for (int i = 1; i <= year; i++){
      for (int j = 0; j < 7; j++){
        if (traits == 1 && j < 3){
          stroke(getEcol(j), 100);
        }
      }
      stroke(getEcol(0),100);
      line(455+365.0*((i-1.0)/year),719-185.0*(cityData[i-1][3]*1.0/cityData[i-1][0]), 455+365.0*((i*1.0)/year),719-185.0*(cityData[i][3]*1.0/cityData[i][0]));
      stroke(getEcol(1),100);
      line(455+365.0*((i-1.0)/year),719-185.0*(cityData[i-1][4]*1.0/cityData[i-1][0]), 455+365.0*((i*1.0)/year),719-185.0*(cityData[i][4]*1.0/cityData[i][0]));
      stroke(getEcol(2),100);
      line(455+365.0*((i-1.0)/year),719-185.0*(cityData[i-1][5]*1.0/cityData[i-1][0]), 455+365.0*((i*1.0)/year),719-185.0*(cityData[i][5]*1.0/cityData[i][0]));
    }
    textSize(10);
    text(cityData[year][3]*1.0/cityData[year][0], 850, 719-185.0*(cityData[year][3]*1.0/cityData[year][0]));
    noStroke();
    textSize(15);
  }
}