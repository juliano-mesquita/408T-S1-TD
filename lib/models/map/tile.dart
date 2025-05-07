
import 'package:flame/components.dart';
import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

class Tile
{
  final Sprite sprite;
  final double rotationAngle;
  final TileType type;

  const Tile(
    {
      required this.sprite,
      required this.rotationAngle,
      required this.type
    }
  );
}