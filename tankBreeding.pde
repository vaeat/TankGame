
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
void breedTanks() {  
  ArrayList<Tank> newTanks = new ArrayList<Tank>();

  if (trial == 0)
    newTanks = JosiahTanks1();
  else if (trial == 1)
    newTanks = JosiahTanks2();
  else if (trial == 2)
    newTanks = VaeaTanks1();
  else if (trial == 3)
    newTanks = VaeaTanks2();
  else if (trial == 4)
    newTanks = VaeaTanks3();

  tanks = newTanks;

  //  log new tanks
  logTankSetup();

  //  set tank positions
  positionTanks();
}

//  function to create tanks
/*
This breeding pattern strives to create a small ammount of variance by cloning the best 3,
mutating the best by factors of 2 and 4, breeding the best with the second and third, and adding just 1 random
*/
ArrayList<Tank> JosiahTanks1() {  
  ArrayList<Tank> newTanks = new ArrayList<Tank>();

  newTanks.add(new Tank(0, tanks.get(0)));
  newTanks.add(new Tank(1, tanks.get(1)));
  newTanks.add(new Tank(2, tanks.get(2)));

  newTanks.add(new Tank(3, tanks.get(0), 2));
  newTanks.add(new Tank(4, tanks.get(0), 4));

  newTanks.add(new Tank(5, tanks.get(0), tanks.get(1)));
  newTanks.add(new Tank(6, tanks.get(0), tanks.get(2)));

  newTanks.add(new Tank(7));

  return newTanks;
}

//  function to create tanks
/*
This breeding pattern strives to create greater variance than the previous by cloning just the best 3,
mutating the best by factors of 3 and 6, only breeding the best with the second and a random, and adding 2 random
*/
ArrayList<Tank> JosiahTanks2() {  
  ArrayList<Tank> newTanks = new ArrayList<Tank>();

  newTanks.add(new Tank(0, tanks.get(0)));
  newTanks.add(new Tank(1, tanks.get(1)));

  newTanks.add(new Tank(2, tanks.get(0), 3));
  newTanks.add(new Tank(3, tanks.get(0), 6));

  newTanks.add(new Tank(4, tanks.get(0), tanks.get(1)));
  newTanks.add(new Tank(5, tanks.get(0), new Tank(0)));

  newTanks.add(new Tank(6));
  newTanks.add(new Tank(7));

  return newTanks;
}

ArrayList<Tank> VaeaTanks1() {  
  //Create a new empty array to add then tanks later
  ArrayList<Tank> newTanks = new ArrayList<Tank>();
  
  /*
  //Creates a fake winner 
  //  fakeWinner(); 
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
  
  */
  
  //  random tank
  newTanks.add(new Tank(0));
  
  //  cloned first place
  newTanks.add(new Tank(1, tanks.get(0)));
  

  //2 CorssBread
  Tank crossbred1 = new Tank(2, tanks.get(0), tanks.get(1));
  Tank crossbred2 = new Tank(3, tanks.get(0), tanks.get(1));
  newTanks.add(crossbred1);
  newTanks.add(crossbred2);


  //2 Mutations of the best
  //degree of mutation of 1 because best, and of 2 because 2nd mutation
  Tank mutated1 = new Tank(4, tanks.get(0), 1);           
  Tank mutated2 = new Tank(5, tanks.get(0), 2);
  newTanks.add(mutated1);
  newTanks.add(mutated2);

  //2 Mutations of the 2nd best
  //same pattern for the degree of mutation
  Tank mutated3 = new Tank(6, tanks.get(1), 1);
  Tank mutated4 = new Tank(7, tanks.get(1), 2);
  newTanks.add(mutated3);
  newTanks.add(mutated4);

  return newTanks;
}




ArrayList<Tank> VaeaTanks2() {  
  //Create a new empty array to add then tanks later
  ArrayList<Tank> newTanks = new ArrayList<Tank>();  
  //  random tank
  newTanks.add(new Tank(0));
  
  //cloned first place
  newTanks.add(new Tank(1, tanks.get(0)));
  
  //CrossBreeding and mutation of first and secondbest
  Tank crossbred = new Tank(1, tanks.get(0), tanks.get(1));
  Tank crossmutate = new Tank(2, crossbred, 1);  
  newTanks.add(crossmutate);

  //2 CorssBread
  Tank crossbred1 = new Tank(3, tanks.get(0), tanks.get(1));
  Tank crossbred2 = new Tank(4, tanks.get(0), tanks.get(1));
  Tank crossbred3 = new Tank(5, tanks.get(1), tanks.get(2));
  newTanks.add(crossbred1);
  newTanks.add(crossbred2);
  newTanks.add(crossbred3);


  //2 Mutations of the best
  //degree of mutation of 7 because wand to see if best of not, and of 8 because same
  //Tank mutated1 = new Tank(5, tanks.get(0), 7);           
  Tank mutated2 = new Tank(6, tanks.get(0), 8);
  //newTanks.add(mutated1);
  newTanks.add(mutated2);

  //1 Mutations of the 2nd best
  //same pattern for the degree of mutation
 // Tank mutated3 = new Tank(6, tanks.get(1), 7);
  Tank mutated4 = new Tank(7, tanks.get(1), 8);
  //newTanks.add(mutated3);
  newTanks.add(mutated4);

  return newTanks;
}



ArrayList<Tank> VaeaTanks3() { 
  /*
  This is the 'baseline' one with every pattern taken randomly and every specs chosen randomly as well
  */
  //Create a new empty array to add then tanks later
  ArrayList<Tank> newTanks = new ArrayList<Tank>();
  
  //Initialise randomness
  String[] genetics_types  = { "breed", "clone", "mutate", "random" };
  print("Genetics Tipes");
 
  //Pick a random genetic type and add the new completely random tank based on the random genetic type chosen
   for (int i = 0; i < 8; i++) {
       int index = int(random(genetics_types.length)); 
       if (genetics_types[index]=="breed"){
          Tank crossbred = new Tank(i, tanks.get(int(random(8))), tanks.get(int(random(8))));
          newTanks.add(crossbred);
       }
       if (genetics_types[index]=="clone"){
         Tank base = tanks.get(int(random(8))); 
         newTanks.add(new Tank(i, base));
       }
       if (genetics_types[index]=="mutate"){
           Tank mutated = new Tank(i, tanks.get(int(random(8))), int(random(6)));
           newTanks.add(mutated);
       }
       if (genetics_types[index]=="random"){
         newTanks.add(new Tank(i));
       }
   }
  
  return newTanks;
}


//  sets the position of 8 tanks for the 600x600 sized area
void positionTanks() {
  for (int i = 0; i < 4; i++)
    for (int j = 0; j < 2; j++)
      tanks.get(i*2+j).setPos(new PVector(200*(j+1), 125*(i+1)));
}


/*
void fakeWinner() {

  for (int i = 0; i < tanks.size(); i++) { //for each tank
    int temp = 0; 
    for (int j = 0; j < 3; j++) { //take first 3 values and add them 
      temp = temp + tanks.get(0).values[j];
    }
    fake_scores[i]=temp;
  }
}
*/
