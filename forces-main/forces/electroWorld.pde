class ElectroWorld {
  //Settings for electro world
  int fieldSize;
  color fieldColor, posColor, negColor,
        arrowColor, red, green, blue, 
        white, black;

  float k_e; // electrostatic constant (Not the real one :p )
  
  ArrayList<ElectroObject> things; // Arraylist for all the things
  boolean fieldOn, toggleFieldOn, toggleSettings;
  float stepLen = 5;

  PVector field, settingsGrid;

  ElectroWorld(float _k_e) {
    k_e = _k_e;

    things = new ArrayList<ElectroObject>();

    field = new PVector(0, 0);
    red = color(255, 0 ,0);
    green = color(0, 255,0);
    blue = color(0, 0, 255);
    white = color(255);
    black = color(0);

    fieldOn = false;
    toggleFieldOn = false;
    keyReleased = false;
    toggleSettings = false;
    negColor = red;
    posColor = blue;
    fieldColor = white;
    arrowColor = green;
    settingsGrid = new PVector(200, 25);
  }

  void run() {

    // Add a thing if key is pressed
    if (keyPressed && currentlyPressed == false) {
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

    // Toggle settings when pressing "i" button
    if (mousePressed && mouseX < 105 && mouseY < 105){
      toggleSettings = true;
    } else if (mousePressed
    && mouseX < 505
    && mouseX > 415
    && mouseY < 105) {
      toggleSettings = false;
    }

    // Enable settingsConfig when toggleSettings is true
    if (toggleSettings){
      if (mousePressed 
          && mouseX > settingsGrid.x - 100
          && mouseX < settingsGrid.x - 50
          && mouseY > settingsGrid.y + 5
          && mouseY < settingsGrid.y + 55) {
        posColor = green;
      }
    }
  }

  void render() {
    background(0);

    // Draw feld lines if an electro object is present
    if (things.size() > 0){
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
    if (!toggleSettings){
      renderSettIcon();
    } else if (toggleSettings) {
      renderSettings();
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
    stroke(arrowColor);
    strokeWeight(1);
    pushMatrix();
    translate(cx, cy);
    rotate(angle);
    line(0, 0, len, 0);
    line(len, 0, len - 8, -8);
    line(len, 0, len - 8, 8);
    popMatrix();
  }

  void drawField(){

    for (ElectroObject thing : things) {

      if (thing.charge > 0){
        for(int i = 0 ; i < 30 ; i++){
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
    fill(fieldColor);
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
        if (pos.dist(new PVector(width/2, height/2)) > 5000){
         stop = true;
       } else if (checkInThing(pos, things, 10)){
         stop = true;
       }
    }
  }

  boolean checkInThing(PVector pos, ArrayList<ElectroObject> things, float collisionDistance){

    for (ElectroObject thing : things) {
      if (pos.dist(thing.position) < collisionDistance) {
        return true;
      }
    }
  
    return false;
  }

  void renderSettIcon(){
    fill(125);
    stroke(255);
    strokeWeight(5);
    rect(5, 5, 100, 100);
    textAlign(CENTER, CENTER);
    textSize(75);
    fill(0);
    text("i", 55, 50);
  }

  void renderSettings(){
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