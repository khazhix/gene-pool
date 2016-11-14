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
int year = 0;
int numCities = 20;
int[][] genes = new int[10][2];
int[][] history = new int[500][20];

City[] city = new City[numCities];
int[] rands = new int[(numCities * (numCities + 1)) / 2];

void setup(){
  //setting up background
   background(0);
  size(1300,700);  smooth(); //1913 968
  img = loadImage("world-2.jpg");
  image(img,0,0, imgW, imgH);

  font = createFont("Raleway-Regular.ttf", 32);
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
  stroke(255, 150);
  line(20, imgH + 20, (imgW / 2) - 20, imgH + 20);
  line(imgW / 2 + 20, imgH + 20, imgW, imgH + 20);
  line(20, imgH + 100, (imgW / 2) - 20, imgH + 100);
  line(imgW / 2 + 20, imgH + 100, imgW, imgH + 100);
  
}
void draw(){
  fill(0);
  population = 0;
  tint(255,100);
  image(img,0,0, imgW, imgH);
  noStroke();
  rect(imgW, 0, width-imgW, height);

  for (int i = 0; i < numCities; i++){
    if (city[i].inRange(mouseX, mouseY)){
      city[i].displayInfo();
    }
    city[i].display();
  }
  stroke(255);
  for (int i = 0; i < (imgW / 10); i++){
    point((i * 10) + year % 10, equator+1);
  }
}

void mousePressed(){
  year++;
  for (int i = 0; i < numCities; i++){
    city[i].update();
    population += city[i].getPop();
    history[year][1] += city[i].getMale();
    history[year][2] += city[i].getFemale();
    for (int j = 0; j < 7; j++){
      if (j < 3)history[year][j + 3] += city[i].getEye(j);
                history[year][j + 6] += city[i].getSkin(j);
      if (j < 5)history[year][j + 13] += city[i].getHair(j);
      if (j < 4)history[year][j + 18] += city[i].getBlood(j);
    }
  }
  int rel = int(population * 0.001);
  while (rel > 0){
    int rct = int(random(numCities));
    int rct2 = int(random(numCities));
    if (city[rct].relocate(city[rct2]))rel--;
  }
  history[year][0] = population;
  for (int i = 1; i <= year; i++){
    line((imgW * 1.0 * (i - 1)) / year, 20 + (history[year - 1][3] * 80.0 / history[year - 1][0]), 
         (imgW * 1.0 * (i)) / year, 20 + (history[year][3] * 80.0 / history[year][0]));
  }
}