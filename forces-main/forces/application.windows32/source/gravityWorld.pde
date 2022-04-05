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

  void run() {

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
      gravity = gravity + 0.001;
    } else if (keysPressed.hasValue("s")) {
      gravity = gravity - 0.001;
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

  void update() {

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

  void render() {

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

  PVector calculateGravity(MassObject currentThing, MassObject thing) {
    PVector distanceVector = PVector.sub(thing.position, currentThing.position);
    float distanceMagnitude = distanceVector.mag();
    float forceMagnitude = gravity*currentThing.mass*thing.mass/sq(distanceMagnitude);
    return distanceVector.setMag(forceMagnitude);
  }
}
