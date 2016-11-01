

long randomTrait() {
  long nt = int(random(0,1.9));
  nt <<= 2;
  nt += int(random(0,3.9));
  nt <<= 3;
  nt += int(random(0,5.9));
  nt <<= 2;
  nt += int(random(0,3.9));
  nt <<= 8;
  nt += int(random(150,255));
  nt <<= 2;
  nt += int(random(0,3.9));
  return nt;
}

PImage img;
float s = 1;
int imgW = 1684;
int imgH = 968;
int maxPopulation = 200000;
int population;
int numCities = 20;

City[] city = new City[numCities];

void setup(){
  //setting up background
   background(0);
  size(1913,968);  smooth();
  img = loadImage("world-2.jpg");
  image(img,0,0, imgW, imgH);

  
  /*PFont font = createFont("Ormont_Light.otf", 42);
  textFont(font);*/
  
  int i;
  //creating cities
  for (i = 0; i < numCities; ){
    int posx = int(random(imgW));
    int posy = int(random(imgH));
    
    if (blue(get(posx,posy)) != 0){
      city[i] = new City(posx, posy, 20000);
      i++;
    }
  }
  
  // creating population
  population = int(random(1000.0, maxPopulation));
  for (i = 0; i < population; ){
    Person p = new Person(randomTrait());
    int cityId = int(random(numCities));
    if (!city[cityId].overPop()){
      city[cityId].addPerson(p);
      i++;
    }
  }
  for (i = 0; i < numCities; i++){
    city[i].display();
  }
}
int jpg = 0;
void draw(){
  fill(0);
  tint(255,50);
  image(img,0,0, imgW, imgH);
  rect(imgW, 0, width-imgW, height);
  
  tint(255,50);
  image(img,0,0, imgW, imgH);
  for (int i = 0; i < numCities; i++){
    if (city[i].inRange(mouseX, mouseY)){
      city[i].displayInfo();
    }
    city[i].update();
  }
  
  for (int i = 0; i < numCities; i++){
    city[i].display();
  }
  
  int rel = int(population * 0.03);
  while (rel > 0){
    int rct = int(random(numCities - 0.1));
    int rct2 = int(random(numCities- 0.1));
    city[rct].relocate(city[rct2]);
    rel--;
  }
}