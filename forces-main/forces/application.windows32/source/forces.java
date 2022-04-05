import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class forces extends PApplet {

boolean mReleased, keyReleased, currentlyPressed;
PVector mVelocity;

StringList keysPressed;

GravityWorld myGravityWorld;
ElectroWorld myElectroWorld;

String state;

public void setup() {
  

  mReleased = false;
  mVelocity = new PVector(0, 0);

  keysPressed = new StringList();

  myGravityWorld = new GravityWorld(0.03f);
  myElectroWorld = new ElectroWorld(1);

  state = "MENU";

  background(0);
}

public void draw() {
  switch (state) {

  case "MENU":
    renderMenu();
    break;

  case "GRAVITY_WORLD":
    myGravityWorld.run();
    break;

  case "ELECTRO_WORLD":
    myElectroWorld.run();
    break;
  }

  keysPressed.clear();
}

public void mouseReleased() {
  if (state == "GRAVITY_WORLD") {
    mReleased = true;
  }
}
public void mousePressed() {
  if (state == "ELECTRO_WORLD") {
    mReleased = true;
  } else {
    mReleased = false;
  }
}

public void keyReleased() {
  if (state == "ELECTRO_WORLD") {
    currentlyPressed = false;
  }
}

public void mouseDragged() {
  mVelocity.x = mouseX - pmouseX;
  mVelocity.y = mouseY - pmouseY;
}

public void keyPressed() {
  keysPressed.append(str(key));
}

public void renderMenu() {
  textAlign(CENTER);
  textSize(50);
  fill(255, 255, 0);
  text("1: Gravity, 2: Electro", width/2, height/2);

  if (keysPressed.hasValue("1")) {
    state = "GRAVITY_WORLD";
    background(0);
  } else if (keysPressed.hasValue("2")) {
    state = "ELECTRO_WORLD";
    background(0);
  }
}
/**
 * The electroObject class implements a simple object with charge that can
 * respond to a force applied to it.
 * This is done by every frame first sum all forces, then calculate
 * acceleration, velocity and position.
 *
 * @author  Reymond T (original author: Andreas W)
 * @version 1.1
 * @since   2022-02-14
 */

class ElectroObject {

  PVector position;
  PVector velocity;
  PVector acceleration;

  PVector totalForce;

  boolean stationary;

  float charge;
  float mass;
  float size;
  int col;

  ElectroObject(
    PVector _pos, 
    PVector _vel, 
    PVector _acc, 
    float _mass, 
    float _charge, 
    float _size, 
    int _col, 
    boolean _stationary) {

    position = _pos;
    velocity = _vel;
    acceleration = _acc;
    charge = _charge;
    mass = _mass;
    size = _size;
    col = _col;
    stationary =  _stationary;

    totalForce = new PVector(0, 0);
    //if (charge > 0) {
    //  col = color(negColor);
    //}
    //else {
    //  col = color(posColor);
    //}
  }

  public void run() {
    render();
    update();
  }

  public void update() {
    // Updates acceleration, velocity and position if not stationary
    if (!stationary) {
      acceleration = totalForce.div(mass); // Newtons second law
      velocity.add(acceleration);
      position.add(velocity);
    }
    // Resets acceleration and force
    acceleration.mult(0);
    totalForce.mult(0);
  }

  public void render() {
    // Renders the object as a circle and force arrow
    char icon = ' ';
    if (charge > 0) {
      fill(myElectroWorld.negColor);
      icon = '-';
    } else if (charge < 0) {
      fill(myElectroWorld.posColor);
      icon = '+';
    }
    float forceLen;
    float maxLen;
    noStroke();
    ellipse(position.x, position.y, size, size);
    textAlign(CENTER, CENTER);
    fill(myElectroWorld.chargeColor);
    textSize(50);
    text(icon, position.x, position.y - 7.5f);
    forceLen = 1000 * totalForce.mag();
    maxLen = constrain(forceLen, 0, 125);
    drawArrow(position.x, position.y, maxLen, totalForce.heading());
  }

  public void applyForce(PVector force) {
    // Applies a force to the object
    totalForce.add(force);
  }

  public void drawArrow(float cx, float cy, float len, float angle) {
    stroke(0, 255, 0);
    strokeWeight(5);
    pushMatrix();
    translate(cx, cy);
    rotate(angle);
    line(0, 0, len, 0);
    line(len, 0, len - 8, -8);
    line(len, 0, len - 8, 8);
    popMatrix();
  }

  public void update(PVector _pos, 
    PVector _vel, 
    PVector _acc, 
    float _mass, 
    float _charge, 
    float _size, 
    int _col, 
    boolean _stationary) {
  }
}
class ElectroSettings {

  int fieldColor, posColor, negColor, 
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

  public void run() {
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

  public void renderSettIcon() {
    fill(125);
    stroke(255);
    strokeWeight(5);
    rect(5, 5, 100, 100);
    textAlign(CENTER, CENTER);
    textSize(75);
    fill(0);
    text("i", 55, 50);
  }

  public void renderSettings() {
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
/**
 * The electroTObject class creates a grid of simple test objects with a positive charge
 * that shows the current electric force on that spot.
 * This is done by every frame first sum all forces, excluding the test objects
 * themselves, then calculate
 * acceleration, velocity and position.
 *
 * @author  Reymond T
 * @version 1.3
 * @since   2022-02-23
 */

class ElectroTObject {

  PVector position;
  PVector velocity;
  PVector acceleration;

  PVector totalForce;

  float charge;
  float mass;

  ElectroTObject(
    PVector _pos, 
    PVector _vel, 
    PVector _acc, 
    float _mass, 
    float _charge) {

    position = _pos;
    velocity = _vel;
    acceleration = _acc;
    charge = _charge;
    mass = _mass;

    totalForce = new PVector(0, 0);
  }

  public void run() {
    render();
    update();
  }

  public void update() {
    // Resets acceleration and force to not extend the force arrow
    acceleration.mult(0);
    totalForce.mult(0);
  }

  public void render() {
    // Renders the force arrow
    float forceLen;
    float maxLen;
    stroke(255);
    float strength = map(totalForce.mag(), 0, 0.1f, 0, 100);
    drawArrow(position.x, position.y, 50, totalForce.heading(), strength);
  }

  public void applyForce(PVector force) {
    // Applies a force to the object
    totalForce.add(force);
  }

  public void drawArrow(float cx, float cy, float len, float angle, float strength) {
    stroke(strength);
    strokeWeight(1);
    pushMatrix();
    translate(cx, cy);
    rotate(angle);
    line(0, 0, len, 0);
    line(len, 0, len - 8, -8);
    line(len, 0, len - 8, 8);
    popMatrix();
  }
}
class ElectroWorld {
  //Settings for electro world
  ElectroSettings settings = new ElectroSettings();
  int fieldSize;
  int fieldColor, posColor, negColor,
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

  public void run() {
    fieldColor = settings.fieldColor;
    posColor = settings.posColor;
    negColor = settings.negColor;
    chargeColor = settings.white;
    arrowColor = settings.arrowColor;

    // Add a thing if key is pressed
    if (keyPressed && !currentlyPressed) {
      float charge = 0;
      int objColor = color(0, 0, 0);
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
      k_e = k_e + 0.001f;
    } else if (keysPressed.hasValue("s")) {
      k_e = k_e - 0.001f;
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

  public void update() {

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

  public void render() {
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

  public PVector calculateElectrostaticForce(ElectroObject currentThing, ElectroObject thing) {

    PVector distanceVector = PVector.sub(thing.position, currentThing.position);
    float distanceMagnitude = distanceVector.mag();
    float forceMagnitude = (-1)*k_e*currentThing.charge*thing.charge/sq(distanceMagnitude);
    return distanceVector.setMag(forceMagnitude);
  }

  public PVector eField(PVector location, ArrayList<ElectroObject> things) {

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

  public void drawArrow(float cx, float cy, float len, float angle, float strength) {
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

  public void drawField() {

    for (ElectroObject thing : things) {

      if (thing.charge > 0) {
        for (int i = 0; i < 30; i++) {
          float dir = i * (2*3.14f) / 30;
          PVector firstStep = PVector.fromAngle(dir);
          firstStep.setMag(20);
          PVector startPos = PVector.add(thing.position, firstStep);
          fieldLine(startPos, dir);
        }
      }
    }
  }

  public void fieldLine(PVector startPos, float startDir) {

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

  public boolean checkInThing(PVector pos, ArrayList<ElectroObject> things, float collisionDistance) {

    for (ElectroObject thing : things) {
      if (pos.dist(thing.position) < collisionDistance) {
        return true;
      }
    }

    return false;
  }
}
class GravityWorld {

  float gravity; // Gravity constant (Not the real one :-) )

  ArrayList<MassObject> things; // Arraylist for all the things

  boolean tracing, toggleTracing;

  GravityWorld(float _gravity) {
    gravity = _gravity;

    things = new ArrayList<MassObject>();

    tracing = false;
    toggleTracing = false;

    // Add a star
    things.add(new MassObject(
      new PVector(width/2, height/2), 
      new PVector(0, 0), 
      new PVector(0, 0), 
      100000, 
      100, 
      color(255, 255, 0)));
  }

  public void run() {

    // Add a thing if mouse released, with speed as mouse dragged
    if (mReleased) {

      things.add(new MassObject(
        new PVector(mouseX, mouseY), 
        new PVector(mVelocity.x, mVelocity.y), 
        new PVector(0, 0), 
        100, 
        10, 
        color(random(128, 255), random(128, 255), random(128, 255))));

      mReleased = false;
    }

    // Control gravity value
    if (keysPressed.hasValue("w")) {
      gravity = gravity + 0.001f;
    } else if (keysPressed.hasValue("s")) {
      gravity = gravity - 0.001f;
    }

    // Toggle tracing
    if (keysPressed.hasValue("t") && !toggleTracing) {
      tracing = !tracing;
      toggleTracing = true;
    } else {
      toggleTracing = false;
    }

    // Render and update the world
    render();
    update();
  }

  public void update() {

    // Apply gravity to all things
    for (MassObject currentThing : things) {
      for (MassObject thing : things) {
        if (currentThing != thing) {
          currentThing.applyForce(calculateGravity(currentThing, thing));
        }
      }
    }

    // Run all things
    for (MassObject currentThing : things) {
      currentThing.run();
    }
  }

  public void render() {

    //Trace the things - or not
    if (!tracing) {
      background(0);
    }

    // Render the dashboard with gravity value
    fill(50);
    rect(0, 0, 300, 70);
    fill(255);
    textSize(30);
    textAlign(LEFT, TOP);
    text("gravity = " + nf(gravity, 0, 3), 20, 20);
  }

  public PVector calculateGravity(MassObject currentThing, MassObject thing) {
    PVector distanceVector = PVector.sub(thing.position, currentThing.position);
    float distanceMagnitude = distanceVector.mag();
    float forceMagnitude = gravity*currentThing.mass*thing.mass/sq(distanceMagnitude);
    return distanceVector.setMag(forceMagnitude);
  }
}
/**
 * The massObject class implements a simple object with mass that can
 * respond to a force applied to it.
 * This is done by every frame first sum all forces, then calculate
 * acceleration, velocity and position.
 *
 * @author  Andreas W
 * @version 1.0
 * @since   2022-02-14
 */

class MassObject {

  PVector position;
  PVector velocity;
  PVector acceleration;

  PVector totalForce;

  float mass;
  float size;
  int col;

  MassObject(
    PVector _pos, 
    PVector _vel, 
    PVector _acc, 
    float _mass, 
    float _size, 
    int _col) {

    position = _pos;
    velocity = _vel;
    acceleration = _acc;
    mass = _mass;
    size = _size;
    col = _col;

    totalForce = new PVector(0, 0);
  }

  public void run() {
    update();
    render();
  }

  public void update() {
    // Updates acceleration, velocity and position
    acceleration = totalForce.div(mass); // Newtons second law
    velocity.add(acceleration);
    position.add(velocity);

    // Resets acceleration and force
    acceleration.mult(0);
    totalForce.mult(0);
  }

  public void render() {
    // Renders the object as a circle
    fill(col);
    ellipse(position.x, position.y, size, size);
  }

  public void applyForce(PVector force) {
    // Applies a force to the object
    totalForce.add(force);
  }
}
  public void settings() {  size(1200, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "forces" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
