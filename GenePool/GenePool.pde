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
PFont font;
PImage img;
float s = 1;
int imgW = 842;//1684
int imgH = 484;//968
float equator = imgH / 1.65;
int maxPopulation = 20000;
int population;
int year = 0, currentYear = 0;
int numCities = 20;
int[][] genes = new int[10][2];
int[][] history = new int[500][30];
int[][] cityYear = new int[100][30];
PrintWriter output;

City[] city = new City[numCities];
int[] rands = new int[(numCities * (numCities + 1)) / 2];

void setup(){
  //setting up background
   background(0);
  size(1200,720);  smooth(); //1913 968
  img = loadImage("world-2.jpg");
  image(img,0,0, imgW, imgH);

  font = createFont("Raleway-Medium.ttf", 13);
  textFont(font);
  
  int i;
  String[] cities = loadStrings("cities.txt");
  //creating cities
  for (i = 0; i < numCities; ){
    int posx = int(random(imgW));
    int posy = int(random(imgH));
    int name = int(random(cities.length));
    if (blue(get(posx,posy)) != 0){
      city[i] = new City(posx, posy, 20000, 28.6, cities[name]);
      i++;
    }
  }
  
  // creating population
  int gender;
  population = int(random(1000.0, maxPopulation));
  for (i = 0; i < population; ){
    randomTrait();
    gender = int(random(0, 2));
    int cityId = int(random(numCities));
    int rdskin = int(random(8));
      int rmskin = int(random(8));
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
    Person p = new Person(genes, gender);
    if (!city[cityId].overPop(gender)){
      city[cityId].addPerson(p);
      i++;
    }
  } 
  output = createWriter("history/"+ year + ".txt"); 
  saveHistory();
  output.flush();
  output.close();
  String[] strings = loadStrings("history/" + currentYear + ".txt");
    String[] data;
    for (i = 0; i < numCities; i++){
      data = strings[i].split(" ");
      for (int j = 0; j < 21; j++){
        cityYear[i][j] = int(data[j + 1]);
      }
    }
  strokeWeight(2);
  stroke(255);
  line(20, 504, 25, 499);
  line(20, 504, 20, 574);
  line(20, 574, 25, 579);
  line(25, 579, 25, 614);
  line(25, 614, 20, 619);
  line(20, 619, 20, 689);
  line(20, 689, 25, 694);
  
  line(420, 499, 425, 504);
  line(425, 504, 425, 574);
  line(425, 574, 420, 579);
  line(420, 579, 420, 614);
  line(420, 614, 425, 619);
  line(425, 619, 425, 689);
  line(425, 689, 420, 694);
  
  line(125, 504, 130, 499);
  line(130, 499, 200, 499);
  line(200, 499, 205, 504);
  line(205, 504, 240, 504);
  line(240, 504, 245, 499);
  line(245, 499, 315, 499);
  line(315, 499, 320, 504);
  
  stroke(255,100);
  line(25,596, 420, 596);
  stroke(255,50);
  text("YEAR", 125, 530);
  text("CITIES", 125, 545);
  text("POPULATION", 125, 560);
  text("RELOCATIONS", 125, 575);
  text("DEATHS", 125, 630);
  text("BIRTHS", 125, 645);
  text("BIRTH RATE", 125, 660);
  text("DEATH RATE", 125, 675);
  textAlign(CENTER);
  
  for (i = 0; i < numCities; i++){
    history[year][0] += city[i].getPop();
    history[year][1] += city[i].getMale();
    history[year][2] += city[i].getFemale();
    for (int j = 0; j < 7; j++){
      if (j < 3)history[year][j + 3] += city[i].getEye(j);
                history[year][j + 6] += city[i].getSkin(j);
      if (j < 5)history[year][j + 13] += city[i].getHair(j);
      if (j < 4)history[year][j + 18] += city[i].getBlood(j);
    }
  }
}
void draw(){
  tint(255,100);
  image(img,0,0, imgW, imgH);
  noStroke();
  fill(0, 100);
  rect(imgW, 0, width-imgW, height);
  rect(245, 520, 75, 60);
  rect(245, 620, 75, 60);
  for (int i = 0; i < numCities; i++){
    if (city[i].inRange(mouseX, mouseY)){
      city[i].displayInfo(history[currentYear], cityYear[i]);
    }
    city[i].display();
  }
  strokeWeight(2);
  stroke(255);
  for (int i = 0; i < (imgW / 10); i++){
    point((i * 10) + year % 10, equator+1);
  }
  showData();
}

void keyPressed(){
  if (key == CODED && keyCode == RIGHT){
    if (currentYear < year){
      currentYear++;
    }
    else {
      year++;
      currentYear = year;
      population = 0;
      for (int i = 0; i < numCities; i++){
        city[i].update();
        population += city[i].getPop();
        history[year][0] += city[i].getPop();
        history[year][1] += city[i].getMale();
        history[year][2] += city[i].getFemale();
        for (int j = 0; j < 7; j++){
          if (j < 3)history[year][j + 3] += city[i].getEye(j);
                    history[year][j + 6] += city[i].getSkin(j);
          if (j < 5)history[year][j + 13] += city[i].getHair(j);
          if (j < 4)history[year][j + 18] += city[i].getBlood(j);
        }
      }
      int rel = int(population * 0.01);
      while (rel > 0){
        int rct = int(random(numCities));
        int rct2 = int(random(numCities));
        if (city[rct].relocate(city[rct2]))history[year][25]++;
        rel--;
      }
      output = createWriter("history/"+ year + ".txt"); 
      saveHistory();
      output.flush();
      output.close();
    }
  } else if (key == CODED && keyCode == LEFT){
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

void showData(){
  text(currentYear, 280, 530);
  text(numCities, 280, 545);
  text(history[currentYear][0], 280, 560);
  text(history[currentYear][25], 280, 575);
  
  text(currentYear, 280, 630);
  text(history[currentYear][0] - history[max(currentYear - 1, 0)][0], 280, 645);
  text(28.6, 280, 660);
  text(currentYear, 280, 675);
}

void saveHistory(){
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
}