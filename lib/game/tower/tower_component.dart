import 'package:flame/components.dart';
import 'package:flutter_towerdefense_game/game/tower/tower_attributes.dart';



class TowerComponent extends SpriteComponent {
  final String towerType;
  final int tier;
  final double range;
  final double damage;
  final Vector2 mapPos;
  final TowerAttributes attributes;

  TowerComponent({
    required this.towerType,
    required this.tier,
    required this.range,
    required this.damage,
    required this.mapPos,
    required this.attributes,
  });

  @override
  String toString()
  {
    return 'TowerComponent($towerType, $tier, $range, $damage, $mapPos, $attributes)';
  }
}
