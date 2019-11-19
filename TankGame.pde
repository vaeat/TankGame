//Git TankGame
//Second Commit
//Third Commit



ArrayList<Tank> tanks = new ArrayList<Tank>();
ArrayList<Tank> tankResults = new ArrayList<Tank>();



void setup() {
  /*
  Tank t1 = new Tank();
   Tank t2 = new Tank();
   Tank t3 = new Tank();
   Tank t4 = new Tank();
   Tank t5 = new Tank();
   
   println();
   
   Tank base = new Tank();
   Tank child1 = new Tank(base, 2);
   Tank child2 = new Tank(base, 4);
   
   println();
   
   Tank mother = new Tank();
   Tank father = new Tank();
   Tank brother = new Tank(mother, father);
   Tank sister = new Tank(mother, father);
   */
}


//  function to create initial tanks
void createInitialTanks() {
  ArrayList<Tank> newTanks = new ArrayList<Tank>();
  for (int i = 0; i < 8; i++)
    newTanks.add(new Tank(i));
  tanks = newTanks;
}

//  function to create tanks
void createJosiahTanks() {
  ArrayList<Tank> newTanks = new ArrayList<Tank>();

  newTanks.add(new Tank(0, tankResults.get(0)));
  newTanks.add(new Tank(1, tankResults.get(1)));
  newTanks.add(new Tank(2, tankResults.get(2)));

  newTanks.add(new Tank(3, tankResults.get(0), 2));
  newTanks.add(new Tank(4, tankResults.get(0), 4));

  newTanks.add(new Tank(5, tankResults.get(0), tankResults.get(1)));
  newTanks.add(new Tank(6, tankResults.get(0), tankResults.get(2)));

  newTanks.add(new Tank(7));

  tanks = newTanks;
}


void draw() {
}