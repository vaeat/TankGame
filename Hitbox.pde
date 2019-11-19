//  actually a hitball
class Hitbox {

  PVector pos;
  int rad;

  Hitbox(PVector p, int r) {
    pos = p;
    rad = r;
  }

  boolean overlapping(Hitbox other) {
    return (dist(pos.x, pos.y, other.pos.x, other.pos.y) < (rad + other.rad));
  }
}

boolean overlapping(Hitbox a, Hitbox b) {
  return a.overlapping(b);
}