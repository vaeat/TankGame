//Git TankGame
//Second Commit
//Third Commit


void setup() {

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
}


void draw() {
}