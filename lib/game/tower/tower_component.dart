import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';
import 'package:flutter_towerdefense_game/game/projectile_component.dart';
import 'tower_attributes.dart';

class TowerComponent extends SpriteComponent
    with HasGameRef, CollisionCallbacks {
  final String towerType;
  final int tier;
  final double range;
  final double damage;
  final Vector2 mapPos;
  final TowerAttributes attributes;

  EnemyComponent? currentTarget;
  late Timer _timer;
  bool isSelected = false;

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

  double get effectiveRange => range * attributes.reachModifier * tier;
  double get effectiveDamage => damage * attributes.damageModifier * tier;
  double get shotsPerSecond => 1.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(radius: effectiveRange));
    _timer = Timer(
      1 / shotsPerSecond,
      repeat: true,
      onTick: _fireProjectile,
    );
    _timer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);

    if (currentTarget == null || currentTarget!.isDead || _isOutOfRange(currentTarget!)) {
      _findNewTarget();
    }
  }

  bool _isOutOfRange(EnemyComponent enemy) {
    return (enemy.position - position).length > effectiveRange;
  }

  void _findNewTarget() {
    final enemies = gameRef.children.whereType<EnemyComponent>();
    final validEnemies = enemies.where(
      (e) => !_isOutOfRange(e) && !e.isDead,
    );
    currentTarget = validEnemies.isNotEmpty ? validEnemies.first : null;
  }

  void _fireProjectile() {
    if (currentTarget == null) return;

    final direction = (currentTarget!.position - position).normalized();
    final projectile = ProjectileComponent(
      startPosition: position.clone(),
      direction: direction,
      speed: 200,
      damage: effectiveDamage,
      target: currentTarget,
    );
    gameRef.add(projectile);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isSelected) {
      final paint = Paint()..color = const Color.fromARGB(84, 5, 150, 223);
      canvas.drawCircle(Offset.zero, effectiveRange, paint);
    }
  }
}
