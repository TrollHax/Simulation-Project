class ElectroWorld {
  //Settings for electro world
  ElectroSettings settings = new ElectroSettings();
  int fieldSize;
  color fieldColor, posColor, negColor,
        chargeColor, arrowColor;

  float k_e; // electrostatic constant (Not the real one :p )

  ArrayList<ElectroObject> things; // Arraylist for all the things
  boolean fieldOn, toggleFieldOn, toggleSettings;
  float stepLen = 5;

  PVector field, settingsGrid;

  ElectroWorld(float _k_e) {
    k_e = _k_e;

    things = new ArrayList<ElectroObject>();

    field = new PVector(0, 0);


    fieldOn = false;
    toggleFieldOn = false;
    keyReleased = false;
    settingsGrid = new PVector(200, 25);
  }

  void run() {
    fieldColor = settings.fieldColor;
    posColor = settings.posColor;
    negColor = settings.negColor;
    chargeColor = settings.white;
    arrowColor = settings.arrowColor;

    // Add a thing if key is pressed
    if (keyPressed && !currentlyPressed) {
      float charge = 0;
      color objColor = color(0, 0, 0);
      if (key == 'q' || key == 'Q') {
        charge = 100;
        objColor = negColor;
      } else if (key == 'e' || key == 'E') {
        charge = -100;
        objColor = posColor;
      }

      if (charge != 0) {
        things.add(new ElectroObject(
          new PVector(mouseX, mouseY), 
          new PVector(0, 0), 
          new PVector(0, 0), 
          50, 
          charge, 
          50, 
          objColor, 
          true));

        currentlyPressed = true;
      }
    }

    // Control electrostatic constant
    if (keysPressed.hasValue("w")) {
      k_e = k_e + 0.001;
    } else if (keysPressed.hasValue("s")) {
      k_e = k_e - 0.001;
    }

    // Toggle field on
    if (keysPressed.hasValue("t") && !toggleFieldOn) {
      fieldOn = !fieldOn;
      toggleFieldOn = true;
    } else {
      toggleFieldOn = false;
    }

    // Run settings class
    settings.run();

    // Render and update the world
    render();
    update();
  }

  void update() {

    // Apply electroforce to all things
    for (ElectroObject currentThing : things) {
      for (ElectroObject thing : things) {
        if (currentThing != thing) {
          currentThing.applyForce(calculateElectrostaticForce(currentThing, thing));
        }
      }
    }

    // Enable settingsConfig when toggleSettings is true
    if (settings.toggleSettings) {
      toggleSettings = true;
    } else if (!settings.toggleSettings) {
      toggleSettings = false;
    }
  }

  void render() {
    background(0);

    // Draw feld lines if an electro object is present
    if (things.size() > 0) {
      drawField();
    }

    // Run all things
    for (ElectroObject currentThing : things) {
      currentThing.run();
    }

    // Render the dashboard with the k_e-value
    //fill(50);
    //rect(0, 0, 500, 70);
    //fill(255);
    //textSize(30);
    //textAlign(LEFT, TOP);
    //text("electrostatic constant = " + nf(k_e, 0, 3), 20, 20);

    // Render settings icon
    if (!toggleSettings) {
      settings.renderSettIcon();
    } else if (toggleSettings) {
      settings.renderSettings();
    }
  }

  PVector calculateElectrostaticForce(ElectroObject currentThing, ElectroObject thing) {

    PVector distanceVector = PVector.sub(thing.position, currentThing.position);
    float distanceMagnitude = distanceVector.mag();
    float forceMagnitude = (-1)*k_e*currentThing.charge*thing.charge/sq(distanceMagnitude);
    return distanceVector.setMag(forceMagnitude);
  }

  PVector eField(PVector location, ArrayList<ElectroObject> things) {

    PVector eField = new PVector(0, 0);

    for (ElectroObject currentThing : things) {
      PVector cont = PVector.sub(currentThing.position, location);
      float distanceMagnitude = cont.mag();
      float contMag = k_e*currentThing.charge/sq(distanceMagnitude);
      cont.setMag(contMag);

      eField.add(cont);
    }
    return eField;
  }

  void drawArrow(float cx, float cy, float len, float angle, float strength) {
    stroke(settings.arrowColor);
    strokeWeight(1);
    pushMatrix();
    translate(cx, cy);
    rotate(angle);
    line(0, 0, len, 0);
    line(len, 0, len - 8, -8);
    line(len, 0, len - 8, 8);
    popMatrix();
  }

  void drawField() {

    for (ElectroObject thing : things) {

      if (thing.charge > 0) {
        for (int i = 0; i < 30; i++) {
          float dir = i * (2*3.14) / 30;
          PVector firstStep = PVector.fromAngle(dir);
          firstStep.setMag(20);
          PVector startPos = PVector.add(thing.position, firstStep);
          fieldLine(startPos, dir);
        }
      }
    }
  }

  void fieldLine(PVector startPos, float startDir) {

    // Draw first step in direction startDir (radians)
    stroke(fieldColor);
    PVector step = PVector.fromAngle(startDir);
    step.setMag(stepLen);
    PVector newPos = PVector.add(startPos, step);
    line(startPos.x, startPos.y, newPos.x, newPos.y);

    PVector pos = newPos;
    boolean stop = false;

    while (!stop) {
      step = eField(pos, things);
      step.setMag(stepLen);
      step.rotate(PI);
      newPos = PVector.add(pos, step);
      
      line(pos.x, pos.y, newPos.x, newPos.y);

      pos = newPos;

      // Stop drawing line if far away or reaching other charge
      if (pos.dist(new PVector(width/2, height/2)) > 5000) {
        stop = true;
      } else if (checkInThing(pos, things, 10)) {
        stop = true;
      }
    }
  }

  boolean checkInThing(PVector pos, ArrayList<ElectroObject> things, float collisionDistance) {

    for (ElectroObject thing : things) {
      if (pos.dist(thing.position) < collisionDistance) {
        return true;
      }
    }

    return false;
  }
}
