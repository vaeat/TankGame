//Git TankGame
//Second Commit
//Third Commit


final int numOfTanks = 8;

ArrayList<Tank> tanks = new ArrayList<Tank>();
ArrayList<Tank> tankResults = new ArrayList<Tank>();
int[] fake_scores = new int[numOfTanks];



void setup() {
  createInitialTanks(); 
  println("teeeeeest");
  createVaeaTanks(); 
  println("Vaea done");


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

void fakeWinner() {

  for (int i = 0; i < tanks.size(); i++) { //for each tank //<>//
    int temp = 0; 
    for (int j = 0; j < 3; j++) { //take first 3 values and add them  //<>//
      temp = temp + tanks.get(0).values[j];
    }
    fake_scores[i]=temp; //<>//
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
  //    createJosiahTanks();
  //  update fight
  //  update tanks
  for (int i = 0; i < tanks.size(); i++) {
    // tanks.get(i);
  }
  //  update bullets
  for (int i = 0; i < tanks.size(); i++) {
  }
}
