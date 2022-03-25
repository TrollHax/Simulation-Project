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

  void run() {
    render();
    update();
  }

  void update() {
    // Resets acceleration and force to not extend the force arrow
    acceleration.mult(0);
    totalForce.mult(0);
  }

  void render() {
    // Renders the force arrow
    float forceLen;
    float maxLen;
    stroke(255);
    float strength = map(totalForce.mag(), 0, 0.1, 0, 100);
    drawArrow(position.x, position.y, 50, totalForce.heading(), strength);
  }

  void applyForce(PVector force) {
    // Applies a force to the object
    totalForce.add(force);
  }

  void drawArrow(float cx, float cy, float len, float angle, float strength) {
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
