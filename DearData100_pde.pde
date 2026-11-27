ArrayList<WaitFlower> flowers = new ArrayList<WaitFlower>();
ArrayList<String> activities = new ArrayList<String>();

final int gardenColumns = 2;
final int gardenGap = 12;
final float flowerScale = 0.5f;

int minDateKey = Integer.MAX_VALUE;
int maxDateKey = Integer.MIN_VALUE;
float gardenWidth;
float gardenHeight;

void setup() {
  size(1100, 750);
  smooth();

  Table waits = loadTable("waits.csv", "header");
  for (TableRow row : waits.rows()) {
    int dateKey = dateToKey(row.getString("date"));
    minDateKey = min(minDateKey, dateKey);
    maxDateKey = max(maxDateKey, dateKey);
    String activity = row.getString("activity");
    if (!activities.contains(activity)) {
      activities.add(activity);
    }
  }

  if (minDateKey == maxDateKey) {
    maxDateKey++;
  }

  int gardenRows = max(1, (activities.size() + gardenColumns - 1) / gardenColumns);
  float availableWidth = (width - gardenGap * (gardenColumns + 1)) / (float) gardenColumns;
  float availableHeight = (height - gardenGap * (gardenRows + 1)) / (float) gardenRows;
  gardenWidth = min(availableWidth, availableHeight);
  gardenHeight = gardenWidth;

  for (TableRow row : waits.rows()) {
    flowers.add(new WaitFlower(row));
  }
}

void draw() {
  background(240);
  for (int i = 0; i < activities.size(); i++) {
    String activity = activities.get(i);
    float left = (width - gardenColumns * gardenWidth - (gardenColumns - 1) * gardenGap) / 2 + (i % gardenColumns) * (gardenWidth + gardenGap);
    float top = gardenGap + (i / gardenColumns) * (gardenHeight + gardenGap);

    pushMatrix();
    translate(left, top);
    drawGarden(activity);
    popMatrix();
  }
}

void drawGarden(String activity) {
  noStroke();
  fill(250);
  rect(0, 0, gardenWidth, gardenHeight, 8);

  stroke(205, 217, 205);
  strokeWeight(1);
  for (int hour = 0; hour <= 24; hour += 4) {
    float y = gardenTimeY(min(hour * 60, 1439));
    line(18, y, gardenWidth - 18, y);
  }

  for (WaitFlower flower : flowers) {
    if (flower.activity.equals(activity)) {
      flower.display();
    }
  }
}

float gardenTimeY(int minutes) {
  return map(minutes, 0, 1439, 44, gardenHeight - 30);
}

int dateToKey(String date) {
  String[] parts = split(date, "-");
  return int(parts[0]) * 31 * 12 + int(parts[1]) * 31 + int(parts[2]);
}

int timeToMinutes(String time) {
  String[] parts = split(time, ":");
  return int(parts[0]) * 60 + int(parts[1]);
}

color activityColour(String activity) {
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
