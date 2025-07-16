import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';
import 'package:flutter_towerdefense_game/game/tower/projectile_component.dart';
import 'package:flutter_towerdefense_game/game/tower/tower_attributes.dart';

class TowerComponent extends SpriteComponent with HasGameRef {
  final String towerType;
  final int tier;
  final double range;
  final double damage;
  final Vector2 mapPos;
  final TowerAttributes attributes;
  late final Timer fireTimer;
  final double fireRate;
  EnemyComponent? target;

  final double realTowerRadius;

  TowerComponent({
    required this.towerType,
    required this.tier,
    required this.range,
    required this.damage,
    required this.mapPos,
    required this.attributes,
    required this.fireRate,
  })
    : realTowerRadius = range * tier
  {
    position = mapPos;
    anchor = Anchor.center;
    size = Vector2.all(32);
    priority = 1;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // debugMode = true;

    fireTimer = Timer(fireRate, onTick: shoot, repeat: false);


    add(
      CircleHitbox(radius: realTowerRadius, anchor: Anchor.center, position: size / 2)
        ..collisionType = CollisionType.passive,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Verifies if theres a valid target
    target = findTargetInRange();

    if (fireTimer.finished && target != null) {
      shoot();
    }

    fireTimer.update(dt);
  }

  void shoot() {
    if (target == null || !target!.isMounted) return;

    // Tower projectile
    print('target: $target, fireTimer.finished: ${fireTimer.finished}');
    final projectile = ProjectileComponent(
      target: target!,
      startPosition: position.clone(),
      speed: 550, // pixels/segundo
      damage: damage,
      sprite: Sprite(gameRef.images.fromCache('pedra_dois.png')),
    );

    gameRef.add(projectile);
    fireTimer.start();

    // resets only if theres a target
    if (findTargetInRange() != null) {
      fireTimer.start();
    }
  }

  EnemyComponent? findTargetInRange() {
    // Logic to find a target in range

    final enemies = gameRef.children.whereType<EnemyComponent>();
    for (final enemy in enemies) {
      if (enemy.position.distanceTo(position) <= range * tier) {
        return enemy;
      }
    }
    return null;
  }
}
