final int LIMIT = 25;
final int numOfValues = 6;



class Tank {

  int id;

  int[] values = new int[numOfValues];

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
  }


  //  returns the total of all values (used for crossbreeding
  int total() {
    int total = 0;
    for (int i = 0; i < values.length; i++)
      total += values[i];
    return total;
  }
}