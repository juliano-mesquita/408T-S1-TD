
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_towerdefense_game/game/component/map_component.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

class TowerDefenseGame extends FlameGame
{
  // Instanciando o mapa
  static final _map = MapObject(
    // largura
    width: 11,
    // altura
    height: 7,
    // O mapa em sí. Os pontos contendo o caminho são representados por 1
    points: [
      [TileType.grass, TileType.grass, TileType.road, TileType.road, TileType.road, TileType.road, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass],
      [TileType.grass, TileType.grass, TileType.road,  TileType.grass,  TileType.grass, TileType.road, TileType.grass, TileType.road, TileType.road, TileType.road, TileType.grass],
      [TileType.road,  TileType.road,  TileType.road,  TileType.grass, TileType.grass, TileType.road, TileType.grass, TileType.road, TileType.grass, TileType.road, TileType.grass],
      [TileType.grass, TileType.grass, TileType.grass, TileType.road, TileType.road, TileType.road, TileType.road, TileType.road, TileType.grass, TileType.road, TileType.road],
      [TileType.grass, TileType.grass, TileType.grass, TileType.road, TileType.grass, TileType.road, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass],
      [TileType.grass, TileType.grass, TileType.grass, TileType.road, TileType.road, TileType.road, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass],
      [TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass],
    ]
  );

  @override
  Future<void> onLoad() async
  {
    await super.onLoad();

    add(
      MapComponent(
        mapObject: _map
      )
        // Where to render the map
        ..position = Vector2(0, 0)
        // The width of the map
        ..width = size.x
        // The height of the map
        ..height = size.y
        // The anchor point of the map
        ..anchor = Anchor.topLeft,
    );
  }
}