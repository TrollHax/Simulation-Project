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
  color col;

  MassObject(
    PVector _pos, 
    PVector _vel, 
    PVector _acc, 
    float _mass, 
    float _size, 
    color _col) {

    position = _pos;
    velocity = _vel;
    acceleration = _acc;
    mass = _mass;
    size = _size;
    col = _col;

    totalForce = new PVector(0, 0);
  }

  void run() {
    update();
    render();
  }

  void update() {
    // Updates acceleration, velocity and position
    acceleration = totalForce.div(mass); // Newtons second law
    velocity.add(acceleration);
    position.add(velocity);

    // Resets acceleration and force
    acceleration.mult(0);
    totalForce.mult(0);
  }

  void render() {
    // Renders the object as a circle
    fill(col);
    ellipse(position.x, position.y, size, size);
  }

  void applyForce(PVector force) {
    // Applies a force to the object
    totalForce.add(force);
  }
}
