
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_towerdefense_game/controller/game_controller.dart';
import 'package:flutter_towerdefense_game/game/component/map_component.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

class TowerDefenseGame extends FlameGame
{
  final GameController _gameController;
  // Instanciando o mapa
  late final MapComponent mapComponent;
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

  TowerDefenseGame({required GameController gameController})
  :
    _gameController = gameController;

  @override
  Future<void> onLoad() async
  {
    await super.onLoad();
    await images.load('indios_garimpeiros/cacique.png');
    _gameController.addOnStartListener(_onGameStart);
    _gameController.addOnPauseListener(_onPause);
    _gameController.addOnResumeListener(_onResume);
  }

  @override
  void onDispose()
  {
    _gameController.removeOnStartListener(_onGameStart);
    _gameController.removeOnPauseListener(_onPause);
    _gameController.removeOnResumeListener(_onResume);
    super.onDispose();
  }

  void _onGameStart()
  {
    overlays.add('Market');
    overlays.add('player');
    overlays.remove('main_menu');

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

  void _onPause()
  {
    overlays.remove('Market');
    overlays.remove('player');
    overlays.add('pause_menu');
  }

  void _onResume()
  {
    overlays.add('Market');
    overlays.add('player');
    overlays.remove('pause_menu');
  }
}