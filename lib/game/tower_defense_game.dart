
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_towerdefense_game/controller/game_controller.dart';
import 'package:flutter_towerdefense_game/controller/level_controller.dart';
import 'package:flutter_towerdefense_game/game/component/map_component.dart';

class TowerDefenseGame extends FlameGame
{
  final GameController _gameController;
  final LevelController _levelController;
  // Instanciando o mapa
  late final MapComponent mapComponent;

  TowerDefenseGame(
    {
      required GameController gameController,
      required LevelController levelController
    }
  )
  :
    _gameController = gameController,
    _levelController = levelController;

  @override
  Future<void> onLoad() async
  {
    await super.onLoad();
    await _levelController.init();
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
        mapObject: _levelController.currentLevel!.map
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