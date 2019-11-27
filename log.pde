//  tab for log functions



//  for loging the initial set up of the tanks before a fight
void logTankSetup() {
  log.append("");
  log.append("GENERATION " + generation);
  log.append("");
  log.append("Tanks: " + tanks.size());
  log.append("");
  for (Tank t : tanks) {
    log.append("Tanks " + t.id + ": " + t.stats());
    log.append(t.ratio() + ", OVERALL: " + t.overall());
  }
}

void logTankResult1() {
  log.append("");
  log.append("FIGHT END");
  log.append("");
  //  write result time of fight
  log.append("Remaining time: " + timer);
  log.append("Tanks left: " + tanksLeft());
  log.append("");
}

void logTankResult2() {
  log.append("");
  log.append("fight result:");
  log.append("");
  //  write ids of tanks in winning order
  String result = "";
  for (int i = 0; i < tankResults.size(); i++)
    if (i == 0)
      result += "Winning Order: " + tankResults.get(i).id;
    else
      result += ", " + tankResults.get(i).id;

  log.append(result);
  log.append("");
}

//  print the log to a txt file
void printLog() {
  //  find first available log position
  boolean found = false;
  int counter = 1;
  while (!found) {
    String[] file = loadStrings("log_" + counter + ".txt");
    if (file == null)
      found = true;
    else
      counter++;
    }
    saveStrings("log_" + counter + ".txt", log.array());
}