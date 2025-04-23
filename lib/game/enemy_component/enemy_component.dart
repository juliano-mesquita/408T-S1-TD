import 'package:flame/components.dart';

class EnemyComponent extends SpriteComponent {
  late final int health;
  late final int speed;
  late final List<Vector2> way;

  EnemyComponent({
    required this.health,
    required this.speed,
    required this.way,
  });

  EnemyComponent.build(int type, this.way)
  {
    if(type == 1)
    {
      this.health = 100;
      this.speed = 15;
    }
    if(type == 2)
    {
      this.health = 200;
      this.speed = 5;
    }

  }
}