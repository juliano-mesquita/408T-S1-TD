import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

/// Modelos pro mapa
class MapObject
{
  /// Tile map width
  final int width;
  /// Tile map height
  final int height;
  /// The tiles type
  final List<List<TileType>> points;

  /// Construtor do objeto
  MapObject(
    {
      required this.width,
      required this.height,
      required this.points
    }
  );
}