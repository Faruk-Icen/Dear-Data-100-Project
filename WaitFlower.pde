class WaitFlower {
  String date;
  String time;
  String placeType;
  String waitFor;
  String outcome;
  String activity;

  int durationMinutes;
  int moodStart;
  int moodEnd;

  float x;
  float y;
  float flowerRadius = 13;
  float stemLength = 48;

  WaitFlower(TableRow row) {
    date = row.getString("date");
    time = row.getString("time");
    placeType = row.getString("place_type");
    waitFor = row.getString("wait_for");
    durationMinutes = row.getInt("duration_minutes");
    moodStart = row.getInt("mood_start");
    moodEnd = row.getInt("mood_end");
    outcome = row.getString("outcome");
    activity = row.getString("activity");

    // Date plants a flower along the X-axis
    x = map(dateToKey(date), minDateKey, maxDateKey, 18, gardenWidth - 18);

    // Time plants a flower along the Y-axis
    y = gardenTimeY(timeToMinutes(time));
  }

  void display() {
    pushMatrix();
    translate(x, y);
    scale(FLOWER_SCALE);

    drawStem();
    drawPetals();
    drawOutcomeFace();

    popMatrix();
  }

  void drawStem() {
    stroke(activityColour());
    strokeWeight(3);
    line(0, flowerRadius, 0, stemLength);
  }

  void drawPetals() {
    noStroke();
    fill(placeColour());

    int petalCount = petalsFromDuration();

    for (int i = 0; i < petalCount; i++) {
      float angle = TWO_PI * i / petalCount;

      pushMatrix();
      rotate(angle);
      ellipse(flowerRadius + 9, 0, 23, 11);
      popMatrix();
    }
  }

  void drawOutcomeFace() {
    noStroke();
    fill(outcomeColour());
    ellipse(0, 0, flowerRadius * 2, flowerRadius * 2);

    fill(35);
    ellipse(-4, -3, 2.5, 2.5);
    ellipse(4, -3, 2.5, 2.5);

    noFill();
    stroke(35);
    strokeWeight(1.5);

    if (outcome.equals("succeeded")) {
      // Happy
      arc(0, 3, 9, 7, 0, PI);
    } else if (outcome.equals("missed")) {
      // Unhappy
      arc(0, 7, 9, 7, PI, TWO_PI);
    } else {
      // Neutral 
      line(-4, 5, 4, 5);
    }
  }

  int petalsFromDuration() {
    return max(3, durationMinutes);
  }

  color placeColour() {
    if (placeType.equals("station") || placeType.equals("bus_stop")) {
      return color(85, 150, 240); //blue
    } else if (placeType.equals("cafeteria") || placeType.equals("restaurant") || placeType.equals("cafe") || placeType.equals("takeaway")) {
      return color(242, 140, 110); //orange
    } else if (placeType.equals("library")) {
      return color(160, 120, 205); //purple
    } else if (placeType.equals("school") || placeType.equals("lecture_hall")) {
      return color(245, 190, 80); //yellow
    } else {
      return color(130, 195, 140); //green
    }
  }

  color activityColour() {
    if (activity.equals("listening_music")) {
      return color(80, 150, 210); //blue
    } else if (activity.equals("reading")) {
      return color(70, 165, 135); //teal
    } else if (activity.equals("talking")) {
      return color(180, 110, 190); //purple
    } else if (activity.equals("chatting")) {
      return color(194, 71, 107); //pink
    } else if (activity.equals("watching_tv")) {
      return color(119, 89, 65); //brown
    } else if (activity.equals("checking_phone") || activity.equals("scrolling")) {
      return color(235, 165, 75); //orange
    } else {
      return color(96, 175, 90); //green
    }
  }

  color outcomeColour() {
    if (outcome.equals("succeeded")) {
      return color(255, 220, 75); //yellow
    } else if (outcome.equals("missed")) {
      return color(240, 110, 105); //red
    } else {
      return color(190, 195, 205); //grey
    }
  }
}
