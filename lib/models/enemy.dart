
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';

class Enemy
{
  late int health;
  late int speed;
  late final int damage;
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
      case EnemyType.garimpeira:
        health = 100;
        damage = 5;
        // enemy movement may break if speed is set too high (it broke with 100 speed)
        speed = 50;
        break;
      case EnemyType.garimpeiro1:
        health = 200;
        damage = 10;
        speed = 30;
        break;
      case EnemyType.garimpeiro2:
        health = 75;
        damage = 15;
        speed = 80;
        break;
    }
  }
}