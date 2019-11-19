final int bulletSize = 15;


class Bullet {

  PVector pos;
  PVector vel;
  int damage;
  int id;

  Hitbox hitbox;

  Bullet(PVector p, PVector v, int d, int i) {
    pos = p.copy();
    vel = v.copy();
    damage = d;
    id = i;
    
    hitbox = new Hitbox(pos, bulletSize);
  }

  void move() {
    pos.add(vel);
  }
}