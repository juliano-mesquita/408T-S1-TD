import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';

class ProjectileComponent extends SpriteComponent with CollisionCallbacks, HasGameRef {
  final Vector2 velocity;
  final double damage;

  ProjectileComponent({
    required this.velocity,
    required this.damage,
    required Vector2 position,
    required Vector2 size,
    Sprite? sprite,
  }) : super(position: position, size: size, sprite: sprite);

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    // Remove se sair da tela
    if (!gameRef.size.toRect().contains(position.toOffset())) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is EnemyComponent) {
      other.receiveDamage(damage);
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}