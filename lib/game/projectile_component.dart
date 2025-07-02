import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';

class ProjectileComponent extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final Vector2 startPosition;
  final Vector2 direction;
  final double speed;
  final double damage;
  final EnemyComponent? target;

  ProjectileComponent({
    required this.startPosition,
    required this.direction,
    required this.speed,
    required this.damage,
    this.target,
  }) {
    position = startPosition;
    anchor = Anchor.center;
    size = Vector2.all(8);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(radius: size.x / 2));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction * speed * dt;

    if (target == null || target!.isDead) {
      removeFromParent();
      return;
    }

    // If the projectile is too far from the target, remove it (optional)
    if ((target!.position - position).length > 1000) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is EnemyComponent) {
      other.receiveDamage(damage);
      removeFromParent();
    }
  }
}
