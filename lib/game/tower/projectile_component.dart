import 'package:flame/components.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';

class ProjectileComponent extends SpriteComponent with HasGameRef {
  final Vector2 velocity;
  final double speed;
  final double damage;
  EnemyComponent target;

  ProjectileComponent({
    required this.target,
    required Vector2 startPosition,
    required this.speed,
    required this.damage,
    required Sprite sprite,
  }) : velocity = (target.position - startPosition).normalized(),
       super(
         position: startPosition.clone(),
         size: Vector2.all(16),
         anchor: Anchor.center,
         sprite: sprite,
       );

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * speed * dt;

    // Verifica colisão simples com o alvo
    if (target.isMounted && position.distanceTo(target.position) < 8) {
      target.receiveDamage(damage);
      removeFromParent();
    }

    // Remove se sair da tela ou alvo removido
    if (!target.isMounted ||
        !gameRef.size.toRect().contains(position.toOffset())) {
      removeFromParent();
    }
  }
}
