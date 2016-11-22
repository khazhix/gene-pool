PFont font;
PImage img, icon;
PrintWriter output;

int imgW = 842;//1684
int imgH = 484;//968
float equator = (imgH + 60) / 1.65;

int population = 20000;
int numCities = 20;
float rRate;
float bRate;
int traits = 1;
String relocRate = "00.03";
String birthRate = "028.8";

int curArea = 1;
float flow = 0;
int year = 0, currentYear = 0;
int[][] genes = new int[10][2];
int[][] history = new int[500][30];
int[][] cityYear = new int[100][30];
int[][][] cityHistory = new int[101][301][30];
boolean flag;

City[] city = new City[150];

void setup(){
  //setting up background
  smooth();
  background(0);
  size(1200,750);   //1913 968
  img = loadImage("world-2.jpg");
  image(img, 0,30,imgW, imgH);
  
  font = createFont("Orbitron-Medium.ttf", 16);
  textFont(font);
  textAlign(CENTER);
  
  flag = false;
  strokeWeight(2);
}
void draw(){
  if (flag){
    tint(255,100);
    image(img,0,30, imgW, imgH);
    
    noStroke();
    fill(0, 100);
    rect(imgW, 30, width-imgW, height);
    rect(245, 540, 95,  70);
    rect(245, 650, 95,  60);
    rect(448, 527, 855, 724);
    
    for (int i = 0; i < numCities; i++){
      if (city[i].inRange(mouseX, mouseY)){
        city[i].displayInfo(history, cityHistory[i], currentYear, traits);
      }
      city[i].display();
    }
    strokeWeight(2);
    stroke(255);
    for (int i = 0; i < (imgW / 10); i++){
      point((i * 10) + year % 10, equator+1);
    }
    showData();
  } else {
    choose();
  }
  fill(0);
  noStroke();
  rect(0,0,width, 30);
  stroke(141, 205, 239, 200);
  line(0, 30, width, 30);
  topbar();
  noStroke();
  
}

void mousePressed(){
  if (!flag && mouseX >= imgW){
    if (mouseY <= 120 && mouseY >= 90){
      curArea = 1;
    }
    else if (mouseY <= 220 && mouseY >= 190){
      curArea = 2;
    }
    else if (mouseY <= 320 && mouseY >= 290){
      curArea = 3;
    }
    else if (mouseY <= 420 && mouseY >= 390){
      curArea = 4;
    } 
    else if (mouseY <= 520 && mouseY >= 490){
      curArea = 5;
      flag = true;
      rRate = float(relocRate);
      bRate = float(birthRate);
      startGame();
    }
  }
  if (mouseY <= 30){}
    if (mouseX >= 78 && mouseX <= 113)traits = 1;
    if (mouseX > 113 && mouseX <= 148)traits = 2;
    if (mouseX > 148 && mouseX <= 183)traits = 3;
    if (mouseX > 183 && mouseX <= 218)traits = 4;
}

void choose(){
  fill(0, 15);
  rect(imgW, 0, width, height);
  stroke(141, 205, 239, 200);
  
  typeArea(imgW + 80, 90,  165, 30, 7);
  typeArea(imgW + 80, 190, 165, 30, 7);
  typeArea(imgW + 80, 290, 165, 30, 7);
  typeArea(imgW + 80, 390, 165, 30, 7);
  typeArea(imgW + 80, 490, 165, 30, 7);
  
  int typeY = 105;
  switch (curArea){
    case 1: typeY = 105; break;
    case 2: typeY = 205; break;
    case 3: typeY = 305; break;
    case 4: typeY = 405; break;
  }
  ellipse(imgW + 40, typeY, flow, flow);
  flow = flow > 20.0 ? 0 : flow + 0.5;
  
  noStroke();
  fill(141, 205, 239, 200);
  text("NUMBER OF CITIES", imgW + 162, 80);
  text("POPULATION",       imgW + 162, 180);
  text("BIRTH RATE",       imgW + 162, 280);
  text("RELOCATION RATE",  imgW + 162, 380);
  
  text(numCities,  imgW + 162, 112);
  text(population, imgW + 162, 212);
  text(birthRate.substring(1, birthRate.length()),  imgW + 162, 312);
  text(relocRate.substring(1, relocRate.length()),  imgW + 162, 412);
  text("START",    imgW + 162, 512);
}


void typeArea(int x, int y, int w, int h, int l){
  line(x, y, x + l, y);
  line(x, y + h, x + l, y + h);
  line(x + w - l, y, x + w, y);
  line(x + w - l, y + h, x + w, y + h);
  
  line(x, y, x, y + l);
  line(x + w, y, x + w, y + l);
  line(x, y + h - l, x, y + h);
  line(x + w, y + h - l, x + w, y + h);
}

void keyPressed(){
  if (!flag){
    if (keyCode == BACKSPACE){
      switch (curArea) {
        case 1: numCities /= 10; break;
        case 2: population /= 10; break;
        case 3: birthRate = birthRate.substring(0, max(birthRate.length() - 1, 1)); break;
        case 4: relocRate = relocRate.substring(0, max(relocRate.length() - 1, 1)); break;
      }
    } else if (key >= '0' && key <= '9'){
      switch (curArea) {
        case 1: numCities = numCities * 10 + (key - '0'); break;
        case 2: population = population * 10 + (key - '0'); break;
        case 3: birthRate = birthRate + key; break;
        case 4: relocRate = relocRate + key; break;
      }
    } else if (key == '.'){
      switch (curArea) {
        case 3: birthRate = birthRate + key; break;
        case 4: relocRate = relocRate + key; break;
      }
    }
  } else {
    if (keyCode == RIGHT){
    if (currentYear < year){
      currentYear++;
    }
    else {
      year++;
      currentYear = year;
      for (int i = 0; i < numCities; i++){
        city[i].update();
        cityHistory[i][year][0] = city[i].getPop();
        cityHistory[i][year][1] = city[i].getMale();
        cityHistory[i][year][2] = city[i].getFemale();
        for (int j = 0; j < 7; j++){
          if (j < 3)cityHistory[i][year][j + 3 ] = city[i].getEye(j);
                    cityHistory[i][year][j + 6 ] = city[i].getSkin(j);
          if (j < 5)cityHistory[i][year][j + 13] = city[i].getHair(j);
          if (j < 4)cityHistory[i][year][j + 18] = city[i].getBlood(j);
        }
        for (int j = 0; j < 25; j++){
          history[year][j] += cityHistory[i][year][j];
        }
      }
      int rel = int(history[year][0] * rRate);
      while (rel > 0){
        int rct = int(random(numCities));
        int rct2 = int(random(numCities));
        if (city[rct].relocate(city[rct2])){history[year][25]++;rel--;}
        
      }
      saveHistory();
    }
  } else if (keyCode == LEFT){
    currentYear--;
    currentYear = max(currentYear, 0);
  }
  String[] strings = loadStrings("history/" + currentYear + ".txt");
    String[] data;
    for (int i = 0; i < numCities; i++){
      data = strings[i].split(" ");
      for (int j = 0; j < 21; j++){
        cityYear[i][j] = int(data[j + 1]);
      }
    }
  }
}

void startGame(){
  int i, gender;
  String[] cities = loadStrings("cities.txt");
  
  //creating cities
  for (i = 0; i < numCities; ){
    int posx = int(random(imgW));
    int posy = int(random(35, imgH+30));
    int name = int(random(cities.length));
    
    if (blue(get(posx,posy)) != 0){
      city[i] = new City(posx, posy, 20000, bRate, cities[name]);
      i++;
    }
  }
  
  // creating population
  for (i = 0; i < population; ){
    randomTrait();
    gender = int(random(0, 2));
    int cityId = int(random(numCities));
    changeSkin(cityId, int(random(8))); 
    
    Person p = new Person(genes, gender, 18.0);
    if (!city[cityId].overPop(gender)){
      city[cityId].addPerson(p);
      i++;
    }
  } 
  // saving first generation 
  saveHistory();
  String[] strings = loadStrings("history/" + currentYear + ".txt");
  String[] data;
  for (i = 0; i < numCities; i++){
    data = strings[i].split(" ");
    for (int j = 0; j < 21; j++){ 
       cityYear[i][j] = int(data[j + 1]);
    }
  }
  stroke(255);
  line(20, 534, 25, 529);
  line(20, 534, 20, 604);
  line(20, 604, 25, 609);
  line(25, 609, 25, 644);
  line(25, 644, 20, 649);
  line(20, 649, 20, 719);
  line(20, 719, 25, 724);
  
  line(420, 529, 425, 534);
  line(425, 534, 425, 604);
  line(425, 604, 420, 609);
  line(420, 609, 420, 644);
  line(420, 644, 425, 649);
  line(425, 649, 425, 719);
  line(425, 719, 420, 724);
  
  line(125, 534, 130, 529);
  line(130, 529, 200, 529);
  line(200, 529, 205, 534);
  line(205, 534, 240, 534);
  line(240, 534, 245, 529);
  line(245, 529, 315, 529);
  line(315, 529, 320, 534);
  
  stroke(255,100);
  line(25,626, 420, 626);
  textAlign(LEFT);
  fill(141, 205, 239, 200);
  text("YEAR",        125, 560);
  text("CITIES",      125, 575);
  text("POPULATION",  125, 590);
  text("RELOCATIONS", 125, 605);
  text("BIRTHS",      125, 675);
  text("BIRTH RATE",  125, 690);
  textAlign(CENTER);
  for (i = 0; i < numCities; i++){
    cityHistory[i][year][0] = city[i].getPop();
    cityHistory[i][year][1] = city[i].getMale();
    cityHistory[i][year][2] = city[i].getFemale();
    for (int j = 0; j < 7; j++){
      if (j < 3)cityHistory[i][year][j + 3 ] = city[i].getEye(j);
                cityHistory[i][year][j + 6 ] = city[i].getSkin(j);
      if (j < 5)cityHistory[i][year][j + 13] = city[i].getHair(j);
      if (j < 4)cityHistory[i][year][j + 18] = city[i].getBlood(j);
    }
    for (int j = 0; j < 25; j++){
      history[year][j] += cityHistory[i][year][j];
    }
  }
}



void showData(){
  text(currentYear, 300, 560);
  text(numCities,   300, 575);
  
  text(history[currentYear][0], 300, 590);
  text(history[currentYear][25], 300, 605);
  
  text(max(history[currentYear][0] - history[max(currentYear - 1, 0)][0], 0), 300, 675);
  text(bRate, 300, 690);
}


void saveHistory(){
  
  output = createWriter("history/"+ year + ".txt"); 
  for (int j = 0; j < numCities; j++){
    output.print(j + " ");
    output.print(city[j].getMale() + " ");
    output.print(city[j].getFemale() + " ");
    for (int i = 0; i < 3; i++)output.print(city[j].getEye(i) + " ");
    for (int i = 0; i < 7; i++)output.print(city[j].getSkin(i) + " ");
    for (int i = 0; i < 5; i++)output.print(city[j].getHair(i) + " ");
    for (int i = 0; i < 4; i++)output.print(city[j].getBlood(i) + " ");
    output.println();
  }
  output.flush();
  output.close();
}

void randomTrait(){
  int dskin = int(random(8));
  int mskin = int(random(8));
  int deye = int(random(4));
  int meye = int(random(4));
  int dhair = int(random(4));
  int mhair = int(random(4));
  for (int i = 1; i <= 3; i++){
    genes[i][0] = (dskin >> (3 - i)) % 2;
    genes[i][1] = (mskin >> (3 - i)) % 2;
  }
  genes[4][0] = int(random(3));
  genes[4][1] = int(random(3));
  genes[5][0] = (deye >> 1) % 2;
  genes[5][1] = (meye >> 1) % 2;
  genes[6][0] = deye % 2;
  genes[6][1] = meye % 2;
  genes[7][0] = (dhair >> 1) % 2;
  genes[7][1] = (mhair >> 1) % 2;
  genes[8][0] = dhair % 2;
  genes[8][1] = mhair % 2;
}

void changeSkin(int cityId, int rmskin){
  genes[1][1] = genes[1][(rmskin >> 2) % 2];
    genes[2][1] = genes[2][(rmskin >> 1) % 2];
    genes[3][1] = genes[3][rmskin % 2];
    
    if (abs(city[cityId].getY() - equator) / equator * 100.0 <= 25.0){ 
      genes[1][0] = 1;
      genes[2][0] = 1;
      genes[3][0] = 1;
    } else if (abs(city[cityId].getY() - equator) / equator * 100.0 <= 35.0){ 
      genes[1][0] = 1;
      genes[2][0] = 0;
      genes[3][0] = 1;
    } else if (abs(city[cityId].getY() - equator) / equator * 100.0 <= 60.0){ 
      genes[1][0] = 0;
      genes[2][0] = 0;
      genes[3][0] = 1;
    } else { 
      genes[1][0] = 0;
      genes[2][0] = 0;
      genes[3][0] = 0;
    }
}

void topbar(){
  noStroke();
  fill(52,152,219);
  rect(78, 0, 140,30);
  fill(231,76,60);
  rect(0, 0, 78,30);
  fill(255);
  switch (traits){
    case 1: rect(78,  0, 35, 4);  break;
    case 2: rect(113, 0, 35, 4);  break;
    case 3: rect(148, 0, 35, 4);  break;
    case 4: rect(183, 0, 35, 4);  break;
  }
  noFill();
  stroke(255, 250);
  arc(25,15,12,12, 0, TWO_PI);
  line(25, 12, 25, 6);
  line(60, 12, 60, 6);
  line(60, 18, 60, 24);
  line(57, 15, 51, 15);
  line(63, 15, 69, 15);
  line(78,0,78,30);
  
  tint(255);
  icon = loadImage("visibility_white.png");
  image(icon, 85, 5, 20, 20);
  icon = loadImage("face_white.png");
  image(icon, 120, 5, 20, 20);
  icon = loadImage("perm_identity_white.png");
  image(icon, 155, 5, 20, 20);
  icon = loadImage("invert_colors_white.png");
  image(icon, 190, 5, 20, 20);
}