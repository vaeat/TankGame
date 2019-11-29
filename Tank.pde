final int LIMIT = 25;
final int numOfValues = 7;  //  number of attributes bred through the tanks



//  functions to create functions
Tank randomTank(int id) {
  return new Tank(id);
}
Tank cloneTank(int id, Tank base) {
  return new Tank(id, base);
}
Tank mutateTank(int id, Tank base, int factor) {
  return new Tank(id, base, factor);
}
Tank breedTank(int id, Tank base1, Tank base2) {
  return new Tank(id, base1, base2);
}



String[] statNames = {"MSPD", "BSPD", "DMOD", "FSPD", "DEFN", "SIZE", "CRAG"};



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

  //  for firing cooldown
  int cooldown = 0;

  //  death tracker
  boolean dead = false;

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

    //  report result -> this is not the reult, it is the sepcs of the tank created 
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

    //  report result -> this is not the reult, it is the sepcs of the tank created 
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


    //  report result -> this is not the reult, it is the sepcs of the tank created 
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

    //  report result -> this is not the reult, it is the sepcs of the tank created 
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
    bspeed = values[1]*2;
    damage = int(1 + values[2]/2);
    fspeed = int(max(120 - 10*values[5], 0) + 30);  //  the max function means that the even if 120 - 10*values[5] becomes less than 0, it will still be 0, making the fastest possible firing rate 30 fps
    health = values[4]+1;
    size = int(20/values[5] + 20);
    distance = int(max(120 - 10*values[6], 0) + 100);

    colour = colour();

    for (int i = 0; i < numOfTanks; i++)
      agro[i] = 0;
  }

  //  sets the position of the tank
  void setPos(PVector p) {
    pos = p;
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

  void drawTank() {
    //  actual tank
    fill(colour());
    ellipse(pos.x, pos.y, size*2, size*2);
    //  health bar
    fill(255, 0, 0, 50);
    rect(pos.x-health*10, pos.y-5, health*20, 10);
  }


  //  updates the tank once per frame to do various functions
  void updateTank() {

    //  cooldown
    if (cooldown > 0)
      cooldown--;

    //  if currently fighting another tank
    if (target != null) {
      //  check if tank is still alive
      if (target.dead)
        //  get new target
        pickTarget();
      //  otherwise, focus on current target
      else {
        //  move
        move();
        //  fire
        if (cooldown <= 0)
          fire();
      }
    }
    //  otherwise, if no target, pick a target
    else {
      pickTarget();
    }
  }


  //  moves tank a set distance
  void move(PVector distance) {
    pos.add(distance);
  }

  //  move tank
  void move() {

    //  assuming that target isn't null as this function shouldn't accessed if it is

    PVector vel = new PVector(0, 0);

    //  move away
    if (dist(pos.x, pos.y, target.pos.x, target.pos.y) < distance*0.9) {
      vel = target.pos.copy();
      vel.sub(pos);
      vel.normalize();
      vel.mult(-1);
      vel.mult(mspeed);
    }
    //  move closer
    else if (dist(pos.x, pos.y, target.pos.x, target.pos.y) > distance*1.1) {
      vel = target.pos.copy();
      vel.sub(pos);
      vel.normalize();
      vel.mult(mspeed);
    }
    pos.add(vel);

    //  modify dir
    while (dir < 0)
      dir += 2*PI;
    while (dir > 2*PI)
      dir -= 2*PI;

    //  move back into bounds
    while (pos.x-size < 0)
      pos.add(new PVector(1, 0));
    while (pos.x+size > width)
      pos.add(new PVector(-1, 0));
    while (pos.y-size < 0)
      pos.add(new PVector(0, 1));
    while (pos.y+size > height)
      pos.add(new PVector(0, -1));
  }


  //  fire a bullet at the current target (assumes target is not null)
  void fire() {
    //  get bullet direction
    PVector vel = target.pos.copy();
    vel.sub(pos);
    vel.normalize();
    //  add bullet speed
    vel.mult(bspeed);
    //  fire
    bullets.add(new Bullet(pos.copy(), vel, damage, id));
    //  reset cooldown
    cooldown = fspeed;
  }


  //  get hit
  void getHit(Bullet b) {
    println(b.damage);
    if (b.damage == 0)
      println("HERE");
    health -= b.damage;  //  take damage
    //  otherwise, check if should target a new tank{
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
      if (agro[i] > agro[target.id] && tanks.get(i) != this && !tanks.get(i).dead)
        target = tanks.get(i);
      //  if the tank being checked has the same agro as the current tank
      else if (agro[i] == agro[target.id] && tanks.get(i) != this && !tanks.get(i).dead) {
        if (random(1) > 0.5) {  //  gives a 50/50 chance to picking the tieing tank
          target = tanks.get(i);
        }
      }
    }
  }


  //  returns the total of all values (used for crossbreeding)
  int total() {
    int total = 0;
    for (int i = 0; i < values.length; i++)
      total += values[i];
    return total;
  }

  //  returns a string of the tank's states
  String stats() {
    String s = "";

    if (values[0] < 10)
      s += " " + str(values[0]);
    else
      s += str(values[0]);

    for (int i = 1; i < values.length; i++) {
      if (values[i] < 10)
        s += ",  " + str(values[i]);
      else
        s += ", " + str(values[i]);
    }
    return s;
  }

  //  prints the ratio of types
  String ratio() {
    int totalSpeed = values[0] + values[1];
    int totalAttack = values[2] + values[3];
    int totalDefense = values[4] + values[5];

    //  gets the relative amount with the highest being 100 and the rest being proportional to the highest
    int speed = int(100 * totalSpeed / max(totalSpeed, totalAttack, totalAttack));
    int attack = int(100 * totalAttack / max(totalSpeed, totalAttack, totalAttack));
    int defense = int(100 * totalDefense / max(totalSpeed, totalAttack, totalAttack));

    return ("SPEED: " + speed + "%, ATTACK: " + attack + "%, DEFENSE: " + defense + "%");
  }

  //  prints the overall type
  String overall() {
    int totalSpeed = values[0] + values[1];
    int totalAttack = values[2] + values[3];
    int totalDefense = values[4] + values[5];

    //  check ties
    if (totalSpeed == totalAttack) {
      if (totalDefense == totalAttack)
        return "ALL BALANCED";
      else if (totalDefense < totalAttack)
        return "SPEED/ATTACK BALANCED";
    }
    if (totalDefense == totalAttack) {
      if (totalSpeed < totalAttack)
        return "DEFENSE/ATTACK BALANCED";
    }
    if (totalSpeed == totalDefense) {
      if (totalAttack < totalDefense)
        return "SPEED/DEFENSE BALANCED";
    }

    //  check for max
    if (totalDefense > totalAttack && totalDefense > totalSpeed)
      return "DEFENSE";
    if (totalSpeed > totalDefense && totalSpeed > totalAttack)
      return "SPEED";
    if (totalAttack > totalDefense && totalAttack > totalSpeed)
      return "ATTACK";

    //  this part should never be reached as the above search should be exhaustive
    return "SOMETHING WENT WRONG CATAGORIZING THIS ONE";
  }

  //  a short description for the final results
  String description() {
    int totalSpeed = values[0] + values[1];
    int totalAttack = values[2] + values[3];
    int totalDefense = values[4] + values[5];

    String type = "";

    //  check ties
    if (totalSpeed == totalAttack) {
      if (totalDefense == totalAttack)
        type = "FULL BALANCED";
      else if (totalDefense < totalAttack)
        type = "SPEED/ATTACK";
    }
    if (totalDefense == totalAttack) {
      if (totalSpeed < totalAttack)
        type = "DEFENSE/ATTACK";
    }
    if (totalSpeed == totalDefense) {
      if (totalAttack < totalDefense)
        type = "SPEED/DEFENSE";
    }

    //  check for max
    if (totalDefense > totalAttack && totalDefense > totalSpeed)
      type = "DEFENSE";
    if (totalSpeed > totalDefense && totalSpeed > totalAttack)
      type = "SPEED";
    if (totalAttack > totalDefense && totalAttack > totalSpeed)
      type = "ATTACK";

    //  gets the relative amount with the highest being 100 and the rest being proportional to the highest
    int speed = int(100 * totalSpeed / max(totalSpeed, totalAttack, totalAttack));
    int attack = int(100 * totalAttack / max(totalSpeed, totalAttack, totalAttack));
    int defense = int(100 * totalDefense / max(totalSpeed, totalAttack, totalAttack));

    type += " " + speed + " " + attack + " " + defense;

    return type;
  }

  //  returns true if the input tank is the same (value-wise) as this tank
  boolean isSame(Tank other) {
    for (int i = 0; i < values.length; i++)
      if (other.values[i] != values[i])
        return false;
    return true;
  }
}


//  a function that will move tanks away from wach other (will only be used on tanks that are overlapping)
void seperate(Tank a, Tank b) {
  PVector dir = a.pos.copy().sub(b.pos);
  dir.normalize();
  a.move(dir);
  dir.mult(-1);
  b.move(dir);
}