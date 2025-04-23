import 'package:flame/components.dart';

enum EnemyType {
  type1, 
  type2,
  }
class EnemyComponent extends SpriteComponent {
  late final int health;
  late final int speed;
  late final List<Vector2> way;

  EnemyComponent({
    required this.health,
    required this.speed,
    required this.way,
  });

  EnemyComponent.build(EnemyType type, this.way) {
    switch (type) {
      case EnemyType.type1:
        health = 100;
        speed = 15;
        break;
      case EnemyType.type2:
        health = 200;
        speed = 5;
        break;
    }
  }
}