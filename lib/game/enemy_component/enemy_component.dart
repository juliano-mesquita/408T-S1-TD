import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class EnemyComponent extends SpriteComponent with HasGameRef, CollisionCallbacks {
  int health;
  final double speed;
  final List<Vector2> path;
  int _currentWaypointIndex = 0;

  EnemyComponent({
    required this.health,
    required this.speed,
    required this.path,
  }) {
    position = path.isNotEmpty ? path[0] : Vector2.zero();
    anchor = Anchor.center;
    size = Vector2.all(24);
  }

  bool get isDead => health <= 0;

  void receiveDamage(double damage) {
    health -= damage.toInt();
    if (isDead) {
      removeFromParent();
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(radius: size.x / 2));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isDead || path.isEmpty) return;

    final target = path[_currentWaypointIndex];
    final delta = target - position;

    if (delta.length < speed * dt) {
      position = target;
      _currentWaypointIndex++;
      if (_currentWaypointIndex >= path.length) {
        removeFromParent();
      }
    } else {
      position += delta.normalized() * speed * dt;
    }
  }
}
