final int LIMIT = 25;
final int numOfValues = 7;  //  number of attributes bred through the tanks



class Tank {

  int id;

  int[] values = new int[numOfValues];
  /*
  Attributes:
   speed:
   0 = movement speed
   1 = bullet speed
   attack:
   2 = damage adder
   3 = firing rate
   defense:
   4 = durability
   5 = size
   other:
   6 = courage
   */

  float mspeed;
  float bspeed;
  int damage;
  int fspeed;  //  # of frames of wait between shots
  int health;
  int size;
  float distance;  //  the distance that a tank will attempt to stay back from its target

  //  positioning info
  PVector pos;
  float dir;

  //  colour
  color colour;

  //  hitbox
  Hitbox hitbox;

  //  agro values (increases based on being attacked)
  int[] agro = new int[numOfTanks];

  //  target tank
  Tank target;



  //  creates a random tank
  Tank(int ident) {
    //  set id value
    id = ident;

    //  create minimum
    for (int i = 0; i < values.length; i++)
      values[i] = 1;

    //  divide remainer randomly
    for (int i = 0; i < LIMIT - values.length; i++)
      values[int(random(values.length))] += 1;

    //  report result
    println("new tank created");
    String printout = str(values[0]);
    for (int i = 1; i < values.length; i++)
      printout += ", " + str(values[i]);
    println(printout);

    setValues();
  }


  //  creates a mutation of the input tank depending on the mutation factor
  Tank(int ident, Tank base, int factor) {
    //  set id value
    id = ident;

    //  copy base tank
    for (int i = 0; i < values.length; i++)
      values[i] = base.values[i];

    //  switch value placement randomly
    for (int i = 0; i < factor; i++) {
      //  get variable to take 1 from
      int from = int(random(values.length));
      //  make sure that 'from' can be taken from (is >1)
      while (values[from] <= 1)
        from = int(random(values.length));
      //  get variable to move value to
      int to = int(random(values.length));
      //  make sure that 'to' is different than 'from'
      while (from == to)
        to = int(random(values.length));
      //  move 1 from 'from' to 'to'
      values[from] -= 1;
      values[to] += 1;
    }

    //  report result
    println("new tank mutation (by factor of " + str(factor) + ") created");
    String printout = str(values[0]);
    for (int i = 1; i < values.length; i++)
      printout += ", " + str(values[i]);
    println(printout);

    setValues();
  }


  //  creates a clone of the input tank
  Tank(int ident, Tank base) {
    //  set id value
    id = ident;

    //  copy base tank
    for (int i = 0; i < values.length; i++)
      values[i] = base.values[i];


    //  report result
    println("new tank clone created");
    String printout = str(values[0]);
    for (int i = 1; i < values.length; i++)
      printout += ", " + str(values[i]);
    println(printout);

    setValues();
  }


  //  crossbreeds the input tanks by taking the maximum values of each and then subtracting until within the limit
  Tank(int ident, Tank base1, Tank base2) {
    //  set id value
    id = ident;

    //  set values to maximums of each parent tank
    for (int i = 0; i < values.length; i++)
      values[i] = max(base1.values[i], base2.values[i]);

    //  decrement until within limit
    while (total() > LIMIT) {
      //  get random variable
      int v = int(random(values.length));
      //  check that value can be decremented from
      if (values[v] > 1)
        values[v] -= 1;
    }

    //  report result
    println("new tank crossbreed created");
    String printout = str(values[0]);
    for (int i = 1; i < values.length; i++)
      printout += ", " + str(values[i]);
    println(printout);

    setValues();
  }


  //  finishes setting up the parameters according to the now set values
  void setValues() {
    /*
  float mspeed;
     float bspeed;
     int damage;
     float fspeed;
     int health;
     int size;
     */

    mspeed = values[0]/2;
    bspeed = values[1];
    damage = int(0.5 + values[2]/2);
    fspeed = int(max(120 - 10*values[5], 0) + 30);  //  the max function means that the even if 120 - 10*values[5] becomes less than 0, it will still be 0, making the fastest possible firing rate 30 fps
    health = values[4]+1;
    size = int(50/values[5] + 50);
    distance = int(max(120 - 10*values[6], 0) + 100);

    colour = colour();

    for (int i = 0; i < numOfTanks; i++)
      agro[i] = 0;

    hitbox = new Hitbox(pos, size);
  }


  //  colour selector based on values
  color colour() {
    //  gets the total level of each type (speed, attack, and defense)
    int totalSpeed = values[0] + values[1];
    int totalAttack = values[2] + values[3];
    int totalDefense = values[4] + values[5];

    //  gets the relative amount with the highest being 255 and the rest being proportional to the highest
    int speed = int(255 * totalSpeed / max(totalSpeed, totalAttack, totalAttack));
    int attack = int(255 * totalAttack / max(totalSpeed, totalAttack, totalAttack));
    int defense = int(255 * totalDefense / max(totalSpeed, totalAttack, totalAttack));

    //  creates a new RGB colour
    return color(attack, speed, defense);
  }


  //  get hit
  void getHit(Bullet b) {
    health -= b.damage;  //  take damage
    agro[b.id] += b.damage;  //  modify agro
    pickTarget();  //  reevaluate target
  }

  //  gets a tank to target based on agro
  void pickTarget() {
    //  get base tank
    if (tanks.get(0) != this)
      target = tanks.get(0);
    else
      target = tanks.get(1);
      //  compares through tanks for which tank to target
    for (int i = 1; i < tanks.size(); i++) {
      //  if the tank being checked has a higher agro than the current tank
      if (agro[i] > agro[target.id] && tanks.get(i) != this)
        target = tanks.get(i);
      //  if the tank being checked has the same agro as the current tank
      else if (agro[i] == agro[target.id] && tanks.get(i) != this)
        if (random(1) > 0.5)  //  gives a 50/50 chance to picking the tieing tank
          target = tanks.get(i);
    }
  }


  //  returns the total of all values (used for crossbreeding
  int total() {
    int total = 0;
    for (int i = 0; i < values.length; i++)
      total += values[i];
    return total;
  }
}