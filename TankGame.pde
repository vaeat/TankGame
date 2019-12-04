//Git TankGame //<>// //<>// //<>//
//Second Commit
//Third Commit


final int numOfTanks = 8;
final int timeLimit = 2700;
final int goal = 100;  //  total number of generations

final int trial = 3;  //  which trial to run
/*
trails:
 0 = Josiah 1
 1 = Josiah 2
 2 = Vaea 1
 3 = Vaea 2
 */


//  import recording package
import com.hamoid.*;

//  create recording
VideoExport videoExport;


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
  size(600, 600);
  createInitialTanks();

  //  set up recording
  videoExport = new VideoExport(this);
  videoExport.startMovie();


  /*
  for (int i = 0; i < 100; i++) {
   finalResults.add(new Tank(0));
   }
   surface.setSize(finalResults.size()*10, 600);
   fight = false;
   */
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
    
    
    
    //  record frame
    videoExport.saveFrame();



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
        //  surface.setSize(1000, 600);
        println("Final results:", finalResults.size());
      }
      //  otherwise, keep going
      else {

        //  increment generation
        generation++;

        //  delete old results
        tankResults = new ArrayList<Tank>();

        //  create new tanks
        breedTanks();
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
