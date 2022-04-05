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
    white = color(255, 255, 255);
    black = color(0, 0, 0);
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
    mouseReleased();
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
      && mouseX > settingsGrid.x - 125
      && mouseX < settingsGrid.x - 75
      && mouseY > settingsGrid.y - 25
      && mouseY < settingsGrid.y + 25
      && mReleased) {
      if (posColor == red) {
        posColor = green;
      } else if (posColor == blue) {
        posColor = red;
      } else if (posColor == green) {
        posColor = blue;
      }
      mReleased = false;
    }
    if (mousePressed 
      && mouseX > settingsGrid.x + 75
      && mouseX < settingsGrid.x + 125
      && mouseY > settingsGrid.y - 25
      && mouseY < settingsGrid.y + 25
      && mReleased) {
      if (posColor == red) {
        posColor = blue;
      } else if (posColor == blue) {
        posColor = green;
      } else if (posColor == green) {
        posColor = red;
      }
      mReleased = false;
    }
    fill(negColor);
    textAlign(CENTER, CENTER);
    textSize(30);
    text("negColor", settingsGrid.x, settingsGrid.y + 50);
    strokeWeight(5);
    noFill();
    rectMode(CENTER);
    rect(settingsGrid.x - 100, settingsGrid.y + 55, 50, 50);
    rect(settingsGrid.x + 100, settingsGrid.y + 55, 50, 50);
    fill(255);
    text("<-", settingsGrid.x - 100, settingsGrid.y + 50);
    text("->", settingsGrid.x + 100, settingsGrid.y + 50);
    if (mousePressed 
      && mouseX > settingsGrid.x - 125
      && mouseX < settingsGrid.x - 75
      && mouseY > settingsGrid.y + 25
      && mouseY < settingsGrid.y + 75
      && mReleased) {
      if (negColor == red) {
        negColor = green;
      } else if (negColor == blue) {
        negColor = red;
      } else if (negColor == green) {
        negColor = blue;
      }
      mReleased = false;
    }
    if (mousePressed 
      && mouseX > settingsGrid.x + 75
      && mouseX < settingsGrid.x + 125
      && mouseY > settingsGrid.y + 25
      && mouseY < settingsGrid.y + 75
      && mReleased) {
      if (negColor == red) {
        negColor = blue;
      } else if (negColor == blue) {
        negColor = green;
      } else if (negColor == green) {
        negColor = red;
      }
      mReleased = false;
    }


    //Settings for changing field line color
    fill(fieldColor);
    textAlign(CENTER, CENTER);
    textSize(30);
    text("fieldColor", settingsGrid.x, settingsGrid.y + 100);
    strokeWeight(5);
    noFill();
    rectMode(CENTER);
    rect(settingsGrid.x - 100, settingsGrid.y + 105, 50, 50);
    rect(settingsGrid.x + 100, settingsGrid.y + 105, 50, 50);
    fill(255);
    text("<-", settingsGrid.x - 100, settingsGrid.y + 100);
    text("->", settingsGrid.x + 100, settingsGrid.y + 100);
    if (mousePressed 
      && mouseX > settingsGrid.x - 125
      && mouseX < settingsGrid.x - 75
      && mouseY > settingsGrid.y + 75
      && mouseY < settingsGrid.y + 125
      && mReleased) {
      if (fieldColor == white) {
        fieldColor = black;
      } else if (fieldColor == red) {
        fieldColor = white;
      } else if (fieldColor == green) {
        fieldColor = red;
      } else if (fieldColor == blue) {
        fieldColor = green;
      } else if (fieldColor == black) {
        fieldColor = blue;
      }
      mReleased = false;
    }
    if (mousePressed 
      && mouseX > settingsGrid.x + 75
      && mouseX < settingsGrid.x + 125
      && mouseY > settingsGrid.y + 75
      && mouseY < settingsGrid.y + 125
      && mReleased) {
      if (fieldColor == white) {
        fieldColor = red;
      } else if (fieldColor == red) {
        fieldColor = green;
      } else if (fieldColor == green) {
        fieldColor = blue;
      } else if (fieldColor == blue) {
        fieldColor = black;
      } else if (fieldColor == black) {
        fieldColor = white;
      }
      mReleased = false;
    }

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
