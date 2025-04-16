
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter_towerdefense_game/game/component/background_component.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

class TowerDefenseGame extends FlameGame
{
  // Instanciando o mapa
  static final _map = MapObject(
    // largura
    width: 6,
    // altura
    height: 6,
    // O mapa em sí. Os pontos contendo o caminho são representados por 1
    points: [
      TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass,
      TileType.grass, TileType.road,  TileType.road,  TileType.road,  TileType.road,  TileType.road,
      TileType.road,  TileType.road,  TileType.grass, TileType.grass, TileType.grass, TileType.grass,
      TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass,
      TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass,
      TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass
    ]
  );

  @override
  Future<void> onLoad() async
  {
    await super.onLoad();

    add(
      BackgroundComponent(
        mapObject: _map
      )
        // ..sprite = backgroundSprite
        // Aonde renderizar relativo a tela(e ao anchor)
        ..position = Vector2(0, 0)
        // Largura do componente de mapa
        ..width = size.x
        // Altura do componente de mapa
        ..height = size.y
        // Anchor/Ancora 
        ..anchor = Anchor.topLeft,
    );
  }
}