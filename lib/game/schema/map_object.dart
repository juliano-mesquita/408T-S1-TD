import 'package:flutter_towerdefense_game/game/tower/tower_component.dart';
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

  // Regra para estar disponivel:
  // - Não haver road/rua na tile
  // - Não haver outra torre na tile
  final Map<TowerComponent, List<List<TileType>>> layers = {};

  /// Construtor do objeto
  MapObject(
    {
      required this.width,
      required this.height,
      required this.points
    }
  );
}