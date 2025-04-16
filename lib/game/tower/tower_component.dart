import 'package:flame/components.dart';
import 'package:flutter_towerdefense_game/game/tower/tower_attributes.dart';



class TowerComponent extends SpriteComponent {
  final String towertype;
  final int tier;
  final double range;
  final double damage;
  final Vector2 mappos;
  final TowerAttributes attributes;

  TowerComponent({
    required this.towertype,
    required this.tier,
    required this.range,
    required this.damage,
    required this.mappos,
    required this.attributes,
  });

  @override
  String toString()
  {
    return 'TowerComponent($towertype, $tier, $range, $damage, $mappos, $attributes)';
  }
}
