class ElectroSettings {

  color fieldColor, posColor, negColor, 
    arrowColor, red, green, blue, 
    white, black;

  PVector settingsGrid = new PVector(200, 25);

  boolean toggleSettings;

  ElectroSettings() {
    red = color(255, 0, 0);
    green = color(0, 255, 0);
    blue = color(0, 0, 255);
    white = color(255);
    black = color(0);
    negColor = red;
    posColor = blue;
    fieldColor = white;
    arrowColor = green;
  }

  void run() {
    // Toggle settings when pressing "i" button
    if (mousePressed && mouseX < 105 && mouseY < 105) {
      toggleSettings = true;
    } else if (mousePressed
      && mouseX < 505
      && mouseX > 415
      && mouseY < 105) {
      toggleSettings = false;
    }
  }

  void renderSettIcon() {
    fill(125);
    stroke(255);
    strokeWeight(5);
    rect(5, 5, 100, 100);
    textAlign(CENTER, CENTER);
    textSize(75);
    fill(0);
    text("i", 55, 50);
  }

  void renderSettings() {
    //Draw the settings screen and border
    noStroke();
    fill(125);
    rectMode(CORNER);
    rect(0, 0, 400, height);
    stroke(255);
    strokeWeight(10);
    line(400, 0, 400, height);

    //Settings for changing color of charges
    fill(posColor);
    textAlign(CENTER, CENTER);
    textSize(30);
    text("posColor", settingsGrid.x, settingsGrid.y);
    strokeWeight(5);
    noFill();
    rectMode(CENTER);
    rect(settingsGrid.x - 100, settingsGrid.y + 5, 50, 50);
    rect(settingsGrid.x + 100, settingsGrid.y + 5, 50, 50);
    fill(255);
    text("<-", settingsGrid.x - 100, settingsGrid.y);
    text("->", settingsGrid.x + 100, settingsGrid.y);
    if (mousePressed 
      && mouseX > settingsGrid.x - 100
      && mouseX < settingsGrid.x - 50
      && mouseY > settingsGrid.y + 5
      && mouseY < settingsGrid.y + 55) {
      if (posColor == blue) {
        posColor = green;
      } else if (posColor == green) {
        posColor = red;
      } else if (posColor == red) {
        posColor = blue;
      }
    }


    //Settings for changing field line color and size
    //

    //Draw the setting toggle
    fill(125);
    stroke(255);
    strokeWeight(5);
    rectMode(CORNER);
    rect(410, 5, 100, 100);
    textAlign(CENTER, CENTER);
    textSize(75);
    fill(0);
    text("i", 460, 50);
  }
}
