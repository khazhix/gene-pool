
class Person {
  float age;
  int gender;
  float maxAge;
  float deathProbability;
  boolean cancer;
  boolean alive;
  public int[][] gene = new int[9][2];
  int[][] child = new int[9][2];
  
  Person(int[][] g, int gnd){
    for (int i = 1; i <= 8; i++){
      gene[i][0] = g[i][0];
      gene[i][1] = g[i][1];
    }
    age    = 0.0;
    alive  = true;
    gender = gnd;
    deathProbability = 0.0;
    maxAge = random(50, 90);
    cancer = false;
  }
  
  void Copy(Person p){
    for (int i = 1; i <= 8; i++){
      gene[i][0] = p.gene[i][0];
      gene[i][1] = p.gene[i][1];
    }
    age    = p.age;
    alive  = p.alive;
    gender = p.gender;
    maxAge = p.maxAge;
  }
  
  Person sex(Person x){
    int ds = int(random(8));
    int ms = int(random(8));
    int db = int(random(2));
    int mb = int(random(2));
    int de = int(random(4));
    int me = int(random(4));
    int dh = int(random(4));
    int mh = int(random(4));
    int gn = int(random(2));
    
    for (int i = 1; i <= 3; i++){
      child[i][0] = gene[i][(ds >> (3-i)) % 2];
      child[i][1] = x.gene[i][(ms >> (3-i)) % 2];
    }
    child[4][0] = gene[4][db];
    child[4][1] = x.gene[4][mb];
    child[5][0] = gene[5][(de >> 1) % 2];
    child[5][1] = x.gene[5][(me >> 1) % 2];
    child[6][0] = gene[6][de % 2];
    child[6][1] = x.gene[6][me % 2];
    child[7][0] = gene[7][(dh >> 1) % 2];
    child[7][1] = x.gene[7][(mh >> 1) % 2];
    child[8][0] = gene[8][dh % 2];
    child[8][1] = x.gene[8][mh % 2];
    Person newChild = new Person(child, gn);
    return newChild;
  }
  
  boolean isMature(){
    if (age >= 18.0)return true;
    return false;
  }
  
  boolean getOlder(float distance){
    age += 1;
    deathProbability+= 0.007;
    float scolor = (6 - getSkinColor()) / 7.0;
    float rnd = random(distance * scolor);
    float rdeath = random(101);
    if (rdeath <= deathProbability){
      alive = false; 
      return false;
    }
    return true;
  }
  
  float age(){
    return age;
  }
  
  void kill(){
    alive = false;
  }
  
  boolean isAlive(){
    return alive;
  }
  
  int gender(){
    return gender;
  }
  
  int getSkinColor(){
    int skin = 0;
    for (int i = 1; i <= 3; i++){
      skin += gene[i][0] + gene[i][1];
    }
    return skin;
  }
  
  int getBloodType(){
    if (gene[4][0] == 0){
      if (gene[4][1] == 0 || gene[4][1] == 2)return 0;
      if (gene[4][1] == 1)return 2;
    }
    if (gene[4][0] == 1){
      if (gene[4][1] == 1 || gene[4][1] == 2)return 1;
      if (gene[4][1] == 0)return 2;
    }
    if (gene[4][0] == 2){
      if (gene[4][1] == 0)return 0;
      if (gene[4][1] == 1)return 1;
      if (gene[4][1] == 2)return 3;
    }
    return 0;
  }
  
  int getEyeColor(){
    if (gene[5][0] == 0 || gene[5][1] == 0)return 0;
    if (gene[6][0] == 0 || gene[6][1] == 0)return 1;
    return 2;
  }
  
  int getHairColor(){
    int hair = 0;
    hair += gene[7][0] + gene[7][1];
    hair += gene[8][0] + gene[8][1];
    return hair;
  }
} 