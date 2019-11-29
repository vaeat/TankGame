//Git TankGame //<>// //<>// //<>//
//Second Commit
//Third Commit


final int numOfTanks = 8;
final int timeLimit = 2700;
final int goal = 17;  //  total number of generations

ArrayList<Tank> tanks = new ArrayList<Tank>();
ArrayList<Tank> tankResults = new ArrayList<Tank>();
int[] fake_scores = new int[numOfTanks];
ArrayList<Tank> finalResults = new ArrayList<Tank>();  //  used to store first place of each fight

ArrayList<Bullet> bullets = new ArrayList<Bullet>();

int timer = timeLimit;

int generation = 0;

StringList log = new StringList();

boolean fight = true;



void setup() {
  /*
  createInitialTanks(); 
   println("teeeeeest");
   createVaeaTanks(); 
   println("Vaea done");
   */


  size(600, 600);



  createInitialTanks();



  /*

   Tank t1 = new Tank(1);
   Tank t2 = new Tank(2);
   Tank t3 = new Tank(3);
   Tank t4 = new Tank(4);
   Tank t5 = new Tank(5);
   
   println();
   
   
   Tank base = new Tank(1);
   //Clone
   Tank clone1 = new Tank(3, base);
   Tank clone2 = new Tank(6, base);
   
   println();
   
   Tank mother = new Tank(1);
   Tank father = new Tank(0);
   //CorssBread
   Tank crossbed1 = new Tank(0, mother, father);
   Tank crossbred2 = new Tank(1, mother, father);
   
   
   Tank mother1 = new Tank(5);
   //Mutation
   Tank mutated1 = new Tank(0, mother1, 3);
   Tank mutated2 = new Tank(1, mother1, 4);
   
   ellipseMode(CENTER);
   
   */
}


//  function to create initial tanks
void createInitialTanks() {
  ArrayList<Tank> newTanks = new ArrayList<Tank>();
  for (int i = 0; i < numOfTanks; i++)
    newTanks.add(new Tank(i));
  tanks = newTanks;

  //  log tanks
  logTankSetup();

  //  set tank positions
  positionTanks();
}

//  function to create tanks
void createJosiahTanks() {  
  ArrayList<Tank> newTanks = new ArrayList<Tank>();

  newTanks.add(new Tank(0, tanks.get(0)));
  newTanks.add(new Tank(1, tanks.get(1)));
  newTanks.add(new Tank(2, tanks.get(2)));

  newTanks.add(new Tank(3, tanks.get(0), 2));
  newTanks.add(new Tank(4, tanks.get(0), 4));

  newTanks.add(new Tank(5, tanks.get(0), tanks.get(1)));
  newTanks.add(new Tank(6, tanks.get(0), tanks.get(2)));

  newTanks.add(new Tank(7));

  tanks = newTanks;

  //  log new tanks
  logTankSetup();

  //  set tank positions
  positionTanks();
}


//  sets the position of 8 tanks for the 600x600 sized area
void positionTanks() {
  for (int i = 0; i < 4; i++)
    for (int j = 0; j < 2; j++)
      tanks.get(i*2+j).setPos(new PVector(200*(j+1), 125*(i+1)));
}


void fakeWinner() {

  for (int i = 0; i < tanks.size(); i++) { //for each tank
    int temp = 0; 
    for (int j = 0; j < 3; j++) { //take first 3 values and add them 
      temp = temp + tanks.get(0).values[j];
    }
    fake_scores[i]=temp;
  }
}


void createVaeaTanks() {  
  //Create a new empty array to add then tanks later
  ArrayList<Tank> newTanks = new ArrayList<Tank>();
  //Creates a fake winner 
  fakeWinner(); 
  //gest the index of the winner
  int maximum = max(fake_scores); 
  int ind_winner = 0 ; //to get index of the first winner
  int ind_second_winner = 0 ; //to get index of second winner
  int max_score = 0; //initialize score for the first winner
  int max_score2 = 0; //initialize scorre for the second winner
  while (ind_winner < fake_scores.length && max_score<maximum) { //loop to get first winner 
    max_score = fake_scores[ind_winner]; 
    ind_winner++;
  }
  //remove winner from the array, to get the secind winner using max function 
  fake_scores[ind_winner] = 0 ; 
  int maximum2 = max(fake_scores); 
  while (ind_second_winner < fake_scores.length && max_score2<maximum2) { //loop to get first winner 
    max_score2 = fake_scores[ind_second_winner]; 
    ind_second_winner++;
  }

  //2 mutations of the best, 2 mutation of 2nd best , 1 clone , 1 new random, 2 crossover of two bests
  Tank winner = tanks.get(ind_winner); 
  Tank second_winner = tanks.get(ind_second_winner); 

  //One Random 
  //Tank tank = new Tank(0);
  newTanks.add(new Tank(0));
  //One Clone
  Tank base = tanks.get(int(random(8))); 
  Tank clone = new Tank(1, base);
  newTanks.add(new Tank(1, base));
  println(clone); 

  println();

  //2 CorssBread
  Tank crossbred1 = new Tank(2, winner, second_winner);
  Tank crossbred2 = new Tank(3, winner, second_winner);
  newTanks.add(crossbred1);
  newTanks.add(crossbred2);


  //2 Mutations of the best

  Tank mutated1 = new Tank(4, winner, int(random(4)));
  Tank mutated2 = new Tank(5, winner, int(random(3)));
  newTanks.add(mutated1);
  newTanks.add(mutated2);

  //2 Mutations of the 2nd best
  Tank mutated3 = new Tank(6, second_winner, int(random(2)));
  Tank mutated4 = new Tank(7, second_winner, int(random(8)));
  newTanks.add(mutated3);
  newTanks.add(mutated4);

  tanks = newTanks;
}



void draw() {
  background(255);

  if (fight) {

    //  FIGHT LOOP

    //  update fight
    timer--;

    //  update bullets
    for (Bullet b : bullets)
      //  simply update
      b.updateBullet();

    //  update tanks (for just for update)
    for (Tank t : tanks) {
      //  update if not dead
      if (!t.dead) {
        //  update
        t.updateTank();
        //  move out of way of overlapping tank
        for (Tank t2 : tanks)
          if (overlapping(t.hitbox, t2.hitbox) && !t2.dead && t != t2)
            //  while (overlapping(t.hitbox, t2.hitbox))
            seperate(t, t2);
      }
      //  check for bullet collisions
      for (Bullet b : bullets)
        if (overlapping(b.hitbox, t.hitbox) && !t.dead && b.id != t.id) {
          t.getHit(b);
          b.dead = true;
        }
    }
    //  remove dead bullets
    for (int i = 0; i < bullets.size(); i++)
      if (bullets.get(i).dead) {
        bullets.remove(i);
        i--;
      }
    //  update tanks (declare dead and place into results arraylist)
    for (Tank t : tanks)
      //  place in results if health <= 0 and declare dead if not already dead
      if (t.health <= 0 && !t.dead) {
        t.dead = true;
        tankResults.add(t);
      }

    //  draw tanks and bullets
    for (Tank t : tanks)
      if (!t.dead)
        t.drawTank();
    for (Bullet b : bullets)
      b.drawBullet();

    //  draw info
    fill(0);
    textSize(20);
    text("Generation: " + generation, 10, 30);
    textSize(20);
    text(int(timer/60), 10, 50);

    //  determine end of fight with there only being one tank left or timer has hit 0
    if (tanksLeft() <= 1 || timer == 0) {

      //  log results before adding in final tanks
      logTankResult1();

      //  reset timer
      timer = timeLimit;

      //  reset bullets
      bullets = new ArrayList<Bullet>();

      //  add remaining tanks into results
      while (tanksLeft() > 0) {
        Tank lowestHealth = null;
        for (Tank t : tanks)
          if (!t.dead) {
            if (lowestHealth == null) {
              lowestHealth = t;
            } else if (lowestHealth.health > t.health)
              lowestHealth = t;
          }
        //  add lowest health tank into results and then kill it
        if (lowestHealth != null) {
          tankResults.add(lowestHealth);
          lowestHealth.dead = true;
        }
      }

      //  reverse results (so that the last tanks to die are now at the front of the list rather than the back
      //  reverse(tankResults);
      ArrayList<Tank> tankResultsReversed = new ArrayList<Tank>();
      for (int i = tankResults.size()-1; i >= 0; i--)
        tankResultsReversed.add(tankResults.get(i));
      tankResults = tankResultsReversed;
      tanks = tankResultsReversed;  //  also save tank results to just tanks (as results will be overwritten)

      //  save first place tank
      finalResults.add(tanks.get(0));

      //  log results of the winning tanks
      logTankResult2();

      //  check if end generation has been met
      if (generation == goal) {
        logFinal();
        printLog();
        //  exit();
        fight = false;
        //  resize for graph displaying
        //  frame.resize(finalResults.size()*10, 600);
        surface.setSize(finalResults.size()*10, 600);
      }
      //  otherwise, keep going
      else {

        //  increment generation
        generation++;

        //  delete old results
        tankResults = new ArrayList<Tank>();

        //  create new tanks
        createJosiahTanks();
      }
    }
  } else {
    //  DRAW GRAPH

    rectMode(CORNER);

    for (int i = 0; i < finalResults.size(); i++) {
      Tank t = finalResults.get(i);

      int totalSpeed = t.values[0] + t.values[1];
      totalSpeed *= height/LIMIT;
      int totalAttack = t.values[2] + t.values[3];
      totalAttack *= height/LIMIT;
      int totalDefense = t.values[4] + t.values[5];
      totalDefense *= height/LIMIT;

      int total = totalSpeed + totalAttack + totalDefense;

      noStroke();
      fill(0, 255, 0);
      rect(i*10, height-totalSpeed, 10, totalSpeed);
      fill(255, 0, 0);
      rect(i*10, height-totalAttack-totalSpeed, 10, totalAttack);
      fill(0, 0, 255);
      rect(i*10, height-totalAttack-totalSpeed-totalDefense, 10, totalDefense);
      fill(0, 0);
      stroke(0);
      rect(i*10, height-total, 10, total);
    }
  }
}


//  returns the number of tanks still alive
int tanksLeft() {
  int counter = 0;
  for (Tank t : tanks)
    if (!t.dead)
      counter++;
  return counter;
}