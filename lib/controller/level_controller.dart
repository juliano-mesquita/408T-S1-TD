import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_towerdefense_game/controller/game_controller.dart';
import 'package:flutter_towerdefense_game/controller/player_controller.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/models/enemy.dart';
import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

typedef OnEnemySpawn = void Function(Enemy enemy);

class CurrentLevel {
  final int level;
  final MapObject map;
  final List<EnemyType> enemisToSpawn;
  final List<Enemy> enemies;
  final int enemySpawnRate;
  int playerHealth;

  final List<List<int>> _enemyPath = [];
  List<List<int>> get enemyPath =>
      List.unmodifiable(
        _enemyPath.map((e) => List.unmodifiable(e).cast<int>()),
      ).cast();

  int get maxEnemies => enemisToSpawn.length;

  CurrentLevel(
    {
      required this.level,
      required this.map,
      required this.enemisToSpawn,
      required this.enemySpawnRate,
      this.playerHealth = 100
    }
  )
    :
      enemies = []
  {
    _setupEnemyPath();
  }

  CurrentLevel copy()
  {
    return CurrentLevel(
      enemySpawnRate: enemySpawnRate,
      level: level,
      map: map,
      enemisToSpawn: List.from(enemisToSpawn),
      playerHealth: playerHealth
    );
  }

  void _setupEnemyPath()
  {
    // Generates the enemy path
    for (int y = 0; y < map.height; y++) {
      final List<int> column = [];
      for (int x = 0; x < map.width; x++) {
        final tileInfo = map.getTileInfo(x, y);
        switch (tileInfo.type) {
          case TileType.grass:
            column.add(-1);
            break;
          case TileType.road:
            column.add(1);
            break;
          case TileType.roadTurn:
            column.add(2);
            break;
          case TileType.roadJunction:
            column.add(3);
            break;
        }
      }
      _enemyPath.add(column);
    }
  }
}

class LevelController extends ValueNotifier<CurrentLevel?> {
  final GameController gameController;
  final PlayerController playerController;
  Timer? _enemySpawnTimer;

  CurrentLevel? get currentLevel => value;

  late final Map<int, CurrentLevel> _levels;

  late final Map<TileType, Sprite> _tilesToSprite;

  Map<TileType, Sprite> get tilesToSprite => Map.unmodifiable(_tilesToSprite);

  final List<OnEnemySpawn> _onEnemySpawnListeners = [];
  final List<VoidCallback> _onGameOverListeners = [];
  final List<VoidCallback> _onVictoryListeners = [];

  LevelController({
    required this.gameController,
    required this.playerController,
  }) : super(null);

  Future<void> init() async {
    /// Intialize sprite images and variables
    await _initializeSprites();

    _levels = {
      1: CurrentLevel(
        level: 1,
        enemisToSpawn: List.generate(5, (_) => EnemyType.garimpeiro1),
        enemySpawnRate: 1,
        map: MapObject(
          // largura
          width: 11,
          // altura
          height: 7,
          tilesToSprite: tilesToSprite,
          // O mapa em sí. Os pontos contendo o caminho são representados por 1
          points: [
            [TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass],
            [TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.road,  TileType.road,  TileType.road,  TileType.grass],
            [TileType.road,  TileType.road,  TileType.road,  TileType.road,  TileType.road,  TileType.road,  TileType.grass, TileType.road,  TileType.grass, TileType.road,  TileType.grass],
            [TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.road,  TileType.road,  TileType.road,  TileType.grass, TileType.road,  TileType.road],
            [TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass],
            [TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass],
            [TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass],
          ]
        )
      ),
      2: CurrentLevel(
        level: 2,
        enemisToSpawn: [
          EnemyType.garimpeira,
          EnemyType.garimpeira,
          EnemyType.garimpeira,
          EnemyType.garimpeiro1,
          EnemyType.garimpeira,
          EnemyType.garimpeira,
          EnemyType.garimpeira,
          EnemyType.garimpeiro1
        ],
        enemySpawnRate: 2,
        map: MapObject(
          // largura
          width: 11,
          // altura
          height: 7,
          tilesToSprite: tilesToSprite,
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
        )
      )
    };

    gameController.addOnStartListener(_onStart);
    gameController.addOnPauseListener(_onPause);
    gameController.addOnResumeListener(_onResume);
  }

  @override
  void dispose() {
    super.dispose();
    gameController.removeOnStartListener(_onStart);
    gameController.removeOnPauseListener(_onPause);
    gameController.removeOnResumeListener(_onResume);
  }

  Future<void> _initializeSprites() async {
    // Initialize images
    final tileGrassImage = await Flame.images.load('floor/tile.png');
    final tileRoadImage = await Flame.images.load('floor/tile_road.png');
    final tileRoadJunctionImage = await Flame.images.load(
      'floor/tile_road_junction.png',
    );
    final tileRoadTurnImage = await Flame.images.load(
      'floor/tile_road_turn.png',
    );

    // Generate sprites from the images
    _tilesToSprite = {
      TileType.grass: Sprite(tileGrassImage),
      TileType.road: Sprite(tileRoadImage),
      TileType.roadJunction: Sprite(tileRoadJunctionImage),
      TileType.roadTurn: Sprite(tileRoadTurnImage),
    };
  }

  void setCurrentLevel(int level)
  {
    value = _levels[level]?.copy();
  }

  void _onStart()
  {
    playerController.health = 100;
    setCurrentLevel((currentLevel?.level ?? 0) + 1);
    _setupEnemySpawn();
  }

  void _onPause() {
    if (_enemySpawnTimer?.isActive == true) {
      _enemySpawnTimer?.cancel();
    }
  }

  void _onResume() {
    _setupEnemySpawn();
  }

  void _setupEnemySpawn() {
    final level = currentLevel;
    if (level == null) {
      return;
    }
    _enemySpawnTimer = Timer.periodic(Duration(seconds: level.enemySpawnRate), (
      _,
    ) {
      if (level.enemies.length < level.maxEnemies) {
        _addEnemy(level);
      } else {
        _enemySpawnTimer?.cancel();
      }
    });
  }

  void _addEnemy(CurrentLevel level) {
    if (level.enemies.length >= level.maxEnemies) {
      return;
    }    
    final enemyToSpawnIndex = level.enemies.length;
    final enemyToSpawn = level.enemisToSpawn[enemyToSpawnIndex];
    final enemy = Enemy.build(
      type: enemyToSpawn,
      path: List.from(level.enemyPath.map((e) => List.from(e).cast<int>())).cast()
    );
    level.enemies.add(enemy);
    _notifyOnEnemySpawnListeners(enemy);
  }

  void enemyReachedEnd(Enemy enemy) {
    if (currentLevel == null) {
      return;
    }
    if (!currentLevel!.enemies.contains(enemy)) {
      return;
    }
    enemy.deactivated = true;
    playerController.health -= enemy.damage;

    final deactivatedEnemyCount = currentLevel!.enemies.where(
      (enemy) => enemy.deactivated,
    );

    if (deactivatedEnemyCount.length == currentLevel!.maxEnemies) {
      _onVictoryCondition();
      return;
    }
    if (playerController.player.playerLevelHealth <= 0) {
      _onVictoryCondition();
    }
  }

  void enemyDeath(Enemy enemy) {
    if (currentLevel == null) {
      return;
    }
    if (!currentLevel!.enemies.contains(enemy)) {
      return;
    }
    enemy.deactivated = true;

    final deactivatedEnemyCount = currentLevel!.enemies.where(
      (enemy) => enemy.deactivated,
    );

    if (deactivatedEnemyCount.length != currentLevel!.maxEnemies) {
      return;
    }
    _onVictoryCondition();
  }

  void _onVictoryCondition() {
    if (_enemySpawnTimer?.isActive == true) {
      _enemySpawnTimer?.cancel();
    }
    final player = playerController.player;
    if (player.playerLevelHealth > 0) {
      _notifyOnVictoryListeners();
      return;
    }
    _notifyOnGameOverListeners();
  }

  //#region Start Listeners

  void addOnEnemySpawnListener(OnEnemySpawn listener) {
    _onEnemySpawnListeners.add(listener);
  }

  void removeOnEnemySpawnListener(OnEnemySpawn listener) {
    _onEnemySpawnListeners.remove(listener);
  }

  void _notifyOnEnemySpawnListeners(Enemy enemy) {
    try {
      for (final listener in List.unmodifiable(_onEnemySpawnListeners)) {
        listener.call(enemy);
      }
    } catch (exception, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'foundation library',
          context: ErrorDescription(
            'while dispatching notifications for $runtimeType',
          ),
          informationCollector:
              () => <DiagnosticsNode>[
                DiagnosticsProperty<LevelController>(
                  'The $runtimeType sending notification was',
                  this,
                  style: DiagnosticsTreeStyle.errorProperty,
                ),
              ],
        ),
      );
    }
  }

  //#endregion

  //#region Pause Listeners

  void addOnGameOverListener(VoidCallback listener) {
    _onGameOverListeners.add(listener);
  }

  void removeOnGameOverListener(VoidCallback listener) {
    _onGameOverListeners.remove(listener);
  }

  void _notifyOnGameOverListeners() {
    try {
      for (final listener in List.unmodifiable(_onGameOverListeners)) {
        listener.call();
      }
    } catch (exception, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'foundation library',
          context: ErrorDescription(
            'while dispatching notifications for $runtimeType',
          ),
          informationCollector:
              () => <DiagnosticsNode>[
                DiagnosticsProperty<LevelController>(
                  'The $runtimeType sending notification was',
                  this,
                  style: DiagnosticsTreeStyle.errorProperty,
                ),
              ],
        ),
      );
    }
  }

  //#endregion
  //#region Pause Listeners

  void addOnVictoryListener(VoidCallback listener) {
    _onVictoryListeners.add(listener);
  }

  void removeOnVictoryListener(VoidCallback listener) {
    _onVictoryListeners.remove(listener);
  }

  void _notifyOnVictoryListeners() {
    try {
      for (final listener in List.unmodifiable(_onVictoryListeners)) {
        listener.call();
      }
    } catch (exception, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'foundation library',
          context: ErrorDescription(
            'while dispatching notifications for $runtimeType',
          ),
          informationCollector:
              () => <DiagnosticsNode>[
                DiagnosticsProperty<LevelController>(
                  'The $runtimeType sending notification was',
                  this,
                  style: DiagnosticsTreeStyle.errorProperty,
                ),
              ],
        ),
      );
    }
  }

  //#endregion
}
