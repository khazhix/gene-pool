
class Person {
  long trait;
  int[] epr = new int[6];
  int[] spr = new int[6];
  int[] hpr = new int[6];
  int[] bld = new int[5];
  Person partner;
  
  Person(long newT){
    trait = newT;
    epr[int((trait >> 15) & 3)] = 100;
    spr[int((trait >> 12) & 7)] = 100;
    hpr[int((trait >> 10) & 3)] = 100;
    bld[int(trait & 3)] = 100;
  }
  
  void married(Person x){
     partner = x;
     x.partner = this;
  }
  
  String getEye(){
    switch (int((trait >> 15) & 3)){
      case 0: return "Blue";
      case 1: return "Brown";
      case 2: return "Green";
      case 3: return "Gray";
      default: return "";
    }
  }
  String getSkin(){
    switch (int((trait >> 12) & 7)){
      case 0: return "Light";
      case 1: return "White";
      case 2: return "Medium";
      case 3: return "Olive";
      case 4: return "Brown";
      case 5: return "Black";
      default: return "";
    }
  }
  String getHair(){
    switch (int((trait >> 10) & 3)){
      case 0: return "Black";
      case 1: return "Brown";
      case 2: return "Red";
      case 3: return "Blonde";
      default: return "";
    }
  }
  float getHeight(){
    return (trait >> 12) & 255;
  }
  String getBlood(){
    switch (int(trait & 3)){
      case 0: return "A";
      case 1: return "B";
      case 2: return "AB";
      case 3: return "O";
      default: return "";
    }
  }
  
  long getTrait(){
    return trait;
  }
} 