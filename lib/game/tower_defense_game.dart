
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter_towerdefense_game/controller/game_controller.dart';
import 'package:flutter_towerdefense_game/controller/level_controller.dart';
import 'package:flutter_towerdefense_game/game/component/map_component.dart';
import 'package:flutter_towerdefense_game/game/market/market.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';
import 'package:flutter_towerdefense_game/models/enemy.dart';

class TowerDefenseGame extends FlameGame
{
  final Market market;
  final GameController _gameController;
  final LevelController _levelController;
  // Instanciando o mapa
  late final MapComponent mapComponent;
  late final Sprite _enemySprite;

  TowerDefenseGame(
    {
      required GameController gameController,
      required LevelController levelController,
      required this.market
    }
  )
  :
    _gameController = gameController,
    _levelController = levelController;

  @override
  Future<void> onLoad() async
  {
    await super.onLoad();
    _enemySprite = Sprite(
      await Flame.images.load('indios_garimpeiros/garimpeira.png'),
    );
    await _levelController.init();
    _gameController.addOnStartListener(_onGameStart);
    _gameController.addOnPauseListener(_onPause);
    _gameController.addOnResumeListener(_onResume);
    _levelController.addOnEnemySpawnListener(_onEnemySpawn);
    _levelController.addOnVictoryListener(_onVictory);
    _levelController.addOnGameOverListener(_onGameOver);
  }

  @override
  void onDispose()
  {
    _gameController.removeOnStartListener(_onGameStart);
    _gameController.removeOnPauseListener(_onPause);
    _gameController.removeOnResumeListener(_onResume);
    _levelController.removeOnEnemySpawnListener(_onEnemySpawn);
    _levelController.removeOnVictoryListener(_onVictory);
    _levelController.removeOnGameOverListener(_onGameOver);
    super.onDispose();
  }
 
  Future<void> _onGameStart() async
  {
    overlays.add('Market');
    overlays.add('player');
    overlays.remove('main_menu');
    mapComponent = MapComponent(
        mapObject: _levelController.currentLevel!.map,
        market: market
      )
        // Where to render the map
        ..position = Vector2(0, 0)
        // The width of the map
        ..width = size.x
        // The height of the map
        ..height = size.y
        // The anchor point of the map
        ..anchor = Anchor.topLeft;
    await add(mapComponent);
  }

  void _onPause()
  {
    overlays.remove('Market');
    overlays.remove('player');
    overlays.add('pause_menu');
    paused = true;
  }

  void _onResume()
  {
    overlays.add('Market');
    overlays.add('player');
    overlays.remove('pause_menu');
    paused = false;
  }

  void _onVictory()
  {
    overlays.remove('Market');
    overlays.remove('player');
    overlays.add('victory');
    paused = true;
  }

  void _onGameOver()
  {
    overlays.remove('Market');
    overlays.remove('player');
    overlays.add('gameover');
    paused = true;
  }

  void _onEnemySpawn(Enemy enemy)
  {
    final enemySize = Vector2(35, 35);
    final firstRoadTilePos = _levelController.currentLevel!.map.leftTopMostRoadTile;
    final firstRoadTile = mapComponent.tiles[firstRoadTilePos.y.toInt()][firstRoadTilePos.x.toInt()];
    final component = EnemyComponent(
        enemyData: enemy,
        startPos: firstRoadTilePos,
        tiles: mapComponent.tiles,
        onReachedEnd: ()
        {
          _levelController.enemyReachedEnd(enemy);
        }
      )
      ..sprite = _enemySprite
      ..size = enemySize
      ..anchor = Anchor.center
      ..position = Vector2(
        firstRoadTile.absoluteCenter.x - (enemySize.x/2),
        firstRoadTile.absoluteCenter.y
      );
    add(component);
  }
}