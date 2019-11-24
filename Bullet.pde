final int bulletSize = 5;


class Bullet {

  PVector pos;
  PVector vel;
  int damage;
  int id;

  boolean dead = false;

  Hitbox hitbox;

  Bullet(PVector p, PVector v, int d, int i) {
    pos = p.copy();
    vel = v.copy();
    damage = d;
    id = i;

    hitbox = new Hitbox(pos, bulletSize);
  }

  void updateBullet() {
    move();
  }

  void move() {
    pos.add(vel);
  }

  void drawBullet() {
    fill(100);
    ellipse(pos.x, pos.y, bulletSize*2, bulletSize*2);
  }
}