boolean mReleased, keyReleased, currentlyPressed;
PVector mVelocity;

StringList keysPressed;

GravityWorld myGravityWorld;
ElectroWorld myElectroWorld;

String state;

void setup() {
  size(1200, 1000);

  mReleased = false;
  mVelocity = new PVector(0, 0);

  keysPressed = new StringList();

  myGravityWorld = new GravityWorld(0.03);
  myElectroWorld = new ElectroWorld(1);

  state = "MENU";

  background(0);
}

void draw() {
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

void mouseReleased() {
  if (state == "GRAVITY_WORLD") {
    mReleased = true;
  }
}
void mousePressed() {
  if (state == "ELECTRO_WORLD") {
    mReleased = true;
  } else {
    mReleased = false;
  }
}

void keyReleased() {
  if (state == "ELECTRO_WORLD") {
    currentlyPressed = false;
  }
}

void mouseDragged() {
  mVelocity.x = mouseX - pmouseX;
  mVelocity.y = mouseY - pmouseY;
}

void keyPressed() {
  keysPressed.append(str(key));
}

void renderMenu() {
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
