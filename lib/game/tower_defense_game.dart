
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter_towerdefense_game/controller/game_controller.dart';
import 'package:flutter_towerdefense_game/controller/level_controller.dart';
import 'package:flutter_towerdefense_game/game/component/map_component.dart';
import 'package:flutter_towerdefense_game/game/market/market_service.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';
import 'package:flutter_towerdefense_game/models/enemy.dart';

class TowerDefenseGame extends FlameGame
{
  final MarketService market;
  final GameController _gameController;
  final LevelController _levelController;
  // Instanciando o mapa
  late MapComponent mapComponent;
  final Map<EnemyType, Sprite> _enemiesSprite = {};

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

    await _setupAssets();

    await _levelController.init();
    _gameController.addOnStartListener(_onGameStart);
    _gameController.addOnPauseListener(_onPause);
    _gameController.addOnResumeListener(_onResume);
    _gameController.addOnMainMenuListener(_onMainMenu);
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
    _gameController.removeOnMainMenuListener(_onMainMenu);
    _levelController.removeOnEnemySpawnListener(_onEnemySpawn);
    _levelController.removeOnVictoryListener(_onVictory);
    _levelController.removeOnGameOverListener(_onGameOver);
    super.onDispose();
  }

  Future<void> _setupAssets() async
  {
    _enemiesSprite[EnemyType.garimpeira] = Sprite(
      await Flame.images.load('indios_garimpeiros/garimpeira.png'),
    );
    _enemiesSprite[EnemyType.garimpeiro1] = Sprite(
      await Flame.images.load('indios_garimpeiros/garimpeiro_um_vum.png'),
    );
    _enemiesSprite[EnemyType.garimpeiro2] = Sprite(
      await Flame.images.load('indios_garimpeiros/garimpeiro_dois_vum.png'),
    );

    await Flame.images.load('indios_garimpeiros/india_um.png');
    await Flame.images.load('indios_garimpeiros/indio_dois.png');
    await Flame.images.load('indios_garimpeiros/india_dois.png');
    await Flame.images.load('indios_garimpeiros/indio_tres.png');
    await Flame.images.load('indios_garimpeiros/mini_indio.png');
    await Flame.images.load('indios_garimpeiros/india_dois.png');
    await Flame.images.load('pedra_dois.png');
  }
 
  Future<void> _onGameStart() async
  {
    paused = false;
    final maps = List<MapComponent>.unmodifiable(children.whereType<MapComponent>());
    final enemies = List<EnemyComponent>.unmodifiable(children.whereType<EnemyComponent>());
    removeAll(maps);
    removeAll(enemies);

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

  void _onMainMenu()
  {
    overlays.remove('victory');
    overlays.remove('gameover');
    overlays.remove('Market');
    overlays.remove('player');
    overlays.add('main_menu');
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
        },
        onDeath: ()
        {
          _levelController.enemyDeath(enemy);
        },
      )
      ..sprite = _enemiesSprite[enemy.type]
      ..size = enemySize
      ..anchor = Anchor.center
      ..position = Vector2(
        firstRoadTile.absoluteCenter.x - (enemySize.x/2),
        firstRoadTile.absoluteCenter.y
      );
    add(component);
  }
}