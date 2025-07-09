
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';

class Enemy
{
  late int health;
  late int speed;
  final EnemyType type;
  final List<List<int>> path;
  bool deactivated = false;

  Enemy.build(
    {
      required this.type,
      required this.path
    }
  ) {
    switch (type) {
      case EnemyType.type1:
        health = 100;
        // enemy movement may break if speed is set too high (it broke with 100 speed)
        speed = 50;
        break;
      case EnemyType.type2:
        health = 200;
        speed = 30;
        break;
      case EnemyType.type3:
        health = 75;
        speed = 80;
        break;
    }
  }
}