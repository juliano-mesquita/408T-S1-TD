import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';
import 'package:flutter_towerdefense_game/game/tower/projectile_component.dart';
import 'package:flutter_towerdefense_game/game/tower/tower_attributes.dart';
import 'package:flame/collisions.dart';

class TowerComponent extends SpriteComponent with CollisionCallbacks{
  final String towerType;
  final int tier;
  final double range;
  final double damage;
  final Vector2 mapPos;
  final TowerAttributes attributes;

  late Timer _shootTimer;
  EnemyComponent? target;

  TowerComponent({
    required this.towerType,
    required this.tier,
    required this.range,
    required this.damage,
    required this.mapPos,
    required this.attributes,
  }) {
    position = mapPos;
    anchor = Anchor.center;
    size = Vector2.all(32);
    priority = 1;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    debugMode = true;

    final double raio = range * tier;

    sprite ??= (await Flame.images.load('indios_garimpeiros/cacique.png')) as Sprite?;

    add(
      CircleHitbox(
        radius: raio,
        anchor: Anchor.center,
        position: size / 2,
      )..collisionType = CollisionType.passive,
    );

    _shootTimer = Timer(
      1 / attributes.fireRate,
      repeat: true,
      onTick: () {
        if (target != null && !target!.isRemoved) {
          shoot();
        }
      },
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _shootTimer.update(dt);

    if (target?.isRemoved ?? true) {
      target = null;
    }
  }

  void shoot() {
    if (target == null) return;

    final direction = (target!.position - position).normalized();
    const speed = 100.0;

    final projectile = ProjectileComponent(
      velocity: direction * speed,
      damage: damage * tier,
      position: position.clone(),
      size: Vector2.all(8),
    );

    parent?.add(projectile);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is EnemyComponent && target == null) {
      target = other;
    }
  }

}