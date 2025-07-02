import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/controller/game_controller.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

class CurrentLevel
{
  final int level;
  final MapObject map;
  final int maxEnemies;
  final List<EnemyComponent> enemies;
  final int enemySpawnRate;
  
  final List<List<int>> enemyPath = [];

  CurrentLevel(
    {
      required this.level,
      required this.map,
      required this.maxEnemies,
      required this.enemySpawnRate
    }
  )
    :
      enemies = []
  {
    _setupEnemyPath();
  }

  void _setupEnemyPath()
  {
    // Generates the enemy path
    for (int y = 0; y < map.height; y++)
    {
      final List<int> column = [];
      for (int x = 0; x < map.width; x++)
      {
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
      enemyPath.add(column);
    }
  }
}

class LevelController extends ValueNotifier<CurrentLevel?>
{
  final GameController gameController;
  Timer? _enemySpawnTimer;

  CurrentLevel? get currentLevel => value;

  late final Map<int, CurrentLevel> _levels;

  late final Map<TileType, Sprite> _tilesToSprite;

  Map<TileType, Sprite> get tilesToSprite => Map.unmodifiable(_tilesToSprite); 

  LevelController({required this.gameController})
  :
    super(null);
  
  Future<void> init() async
  {
    /// Intialize sprite images and variables
    await _initializeSprites();
    
    _levels =
    {
      1: CurrentLevel(
        level: 1,
        maxEnemies: 10,
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
      ),
      2: CurrentLevel(
        level: 2,
        maxEnemies: 15,
        enemySpawnRate: 2,
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
      )
    };

    setCurrentLevel(2);

    gameController.addOnStartListener(_onStart);
    gameController.addOnPauseListener(_onPause);
    gameController.addOnResumeListener(_onResume);
  }

  @override
  void dispose()
  {
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
    value = _levels[level];
  }

  void _onStart()
  {
    final level = currentLevel;
    if(level == null)
    {
      return;
    }
    _enemySpawnTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (level.enemies.length < level.maxEnemies) {
        _addEnemy(level);
      } else {
        _enemySpawnTimer?.cancel();
      }
    });
  }

  void _onPause()
  {

  }

  void _onResume()
  {

  }

  @visibleForTesting
  Vector2 findLeftTopMostRoadTile(MapObject map)
  {
    //TODO: Optimize to break after finding the first point when looking from top/left to bottom/right
    final tiles = map.points.map(
      (row) => row.indexWhere((tile) => tile == TileType.road),
    );
    int minY = tiles.length;
    int minX = tiles.first;
    for (int y = 0; y < map.height; y++) {
      for (int x = 0; x < map.width; x++) {
        if (map.points[y][x] == TileType.road && x <= minX) {
          minX = x;
        }
      }
    }

    for (int y = 0; y < map.height; y++) {
      if (map.points[y][minX] == TileType.road && y <= minY) {
        minY = y;
      }
    }

    return Vector2(minX.toDouble(), minY.toDouble());
  }

  void _addEnemy(CurrentLevel level)
  {
    if (level.enemies.length >= level.maxEnemies)
    {
      return;
    }
    final firstRoadTilePos = findLeftTopMostRoadTile(level.map);
    // var firstRoadTile = _tiles[firstRoadTilePos.y.toInt()][firstRoadTilePos.x.toInt()];
    
    final enemySize = Vector2(35, 35);
    // final enemy =
    //     EnemyComponent.build(
    //         type: EnemyType.type1,
    //         path: level.enemyPath,
    //         startPos: firstRoadTilePos,
    //         tiles: [],
    //         onReachedEnd: () {
    //           playerHealth -= 1;
    //         },
    //       )
    //       // ..sprite = enemySprite
    //       ..size = enemySize
    //       ..anchor = Anchor.center
    //       ..position = Vector2(
    //         firstRoadTile.absoluteCenter.x - (enemySize.x/2),
    //         firstRoadTile.absoluteCenter.y
    //       );
    // add(enemy);
    // level.enemies.add(enemy);
  }

}