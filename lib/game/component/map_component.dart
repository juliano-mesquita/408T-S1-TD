import 'dart:async';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/game/component/tile_component.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/game/tower/tower_attributes.dart';
import 'package:flutter_towerdefense_game/game/tower/tower_component.dart';
import 'package:flutter_towerdefense_game/models/map/tile.dart';
import 'dart:math' as math;

import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

/// A component that generates a map based on provided tiles
///
/// The road tiles will be rotated to create a concise path
class MapComponent extends PositionComponent {
  // Object containing map information
  final MapObject mapObject;

  /// Viewport reference size
  late final double _viewPortRefSize;

  /// The tile size after scaling to viewport
  late final double _tileSize;

  /// A list of tiles generated for the map
  late final List<List<SpriteComponent>> _tiles = [];

  /// A map that matches tile types to their sprites/images
  late final Map<TileType, Sprite> _tilesToSprite;

  late final List<PositionComponent> _enemies = [];
  final List<Vector2> _validTowerPositions = [];

  final Set<Vector2> _occupiedTowerPositions = {};

  late final Sprite towerSprite;
  late final Sprite enemySprite;
  int playerHealth = 5;

  int _enemyCount = 0;
  final int _maxEnemies = 10;
  Timer? _enemySpawnTimer;

  MapComponent({required this.mapObject});

  /// Finds the first top left road in them map
  Vector2 findLeftTopMostRoadTile() {
    //TODO: Optimize to break after finding the first point when looking from top/left to bottom/right
    final tiles = mapObject.points.map(
      (row) => row.indexWhere((tile) => tile == TileType.road),
    );
    int minY = tiles.length;
    int minX = tiles.first;
    for (int y = 0; y < mapObject.height; y++) {
      for (int x = 0; x < mapObject.width; x++) {
        if (mapObject.points[y][x] == TileType.road && x <= minX) {
          minX = x;
        }
      }
    }

    for (int y = 0; y < mapObject.height; y++) {
      if (mapObject.points[y][minX] == TileType.road && y <= minY) {
        minY = y;
      }
    }

    return Vector2(minX.toDouble(), minY.toDouble());
  }

  @override
  Future<void> onLoad() async {
    /// Intiliaze sprite images and variables
    await _initializeSprites();

    towerSprite = Sprite(
      await Flame.images.load('indios_garimpeiros/indio_um.png'),
    );
    enemySprite = Sprite(
      await Flame.images.load('indios_garimpeiros/garimpeira.png'),
    );

    /// Set map scaled size
    _setMapScaledSize();

    /// Generate map
    await _generateMap();

    /// Adds an enemy every two seconds
    //TODO: Use correctly rules to add an enemy
    _enemySpawnTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_enemyCount < _maxEnemies) {
        _addEnemy();
      } else {
        _enemySpawnTimer?.cancel();
      }
    });

    await super.onLoad();
  }

  /// Adds an enemy to the map
  void _addEnemy() {
    if (_enemyCount >= _maxEnemies) return;
    final firstRoadTilePos = findLeftTopMostRoadTile();
    var firstRoadTile =
        _tiles[firstRoadTilePos.y.toInt()][firstRoadTilePos.x.toInt()];
    final List<List<int>> enemyPath = [];
    // Generates the enemy path
    for (int y = 0; y < _tiles.length; y++) {
      final List<int> column = [];
      for (int x = 0; x < _tiles[y].length; x++) {
        final tileInfo = _getTileInfo(x, y);
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
    final enemySize = Vector2(35, 35);
    final enemy =
        EnemyComponent.build(
            type: EnemyType.type1,
            path: enemyPath,
            startPos: firstRoadTilePos,
            tiles: _tiles,
            onReachedEnd: () {
              playerHealth -= 1;
            },
          )
          ..sprite = enemySprite
          ..size = enemySize
          ..anchor = Anchor.center
          ..position = Vector2(
            firstRoadTile.absoluteCenter.x - (enemySize.x/2),
            firstRoadTile.absoluteCenter.y
          );
    add(enemy);
    _enemies.add(enemy);
    _enemyCount++;
  }

  /// Calculates and scale map tile sizes
  void _setMapScaledSize() {
    // Create a reference size based on the smallest viewport size
    _viewPortRefSize = math.min(size.x, size.y).floorToDouble();
    // Creates the tile size given the ref size and viewport size
    _tileSize =
        (_viewPortRefSize / math.max(mapObject.width, mapObject.height))
            .floorToDouble();
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

  /// Generates the map based on provided [mapObject] and
  /// scaled viewport sizes
  Future<void> _generateMap() async {
    for (int tileIndexY = 0; tileIndexY < mapObject.height; tileIndexY++) {
      final List<SpriteComponent> tileRow = [];
      for (int tileIndexX = 0; tileIndexX < mapObject.width; tileIndexX++) {
        var tileInfo = _getTileInfo(tileIndexX, tileIndexY);

        final left = (tileIndexX * _tileSize) + (_tileSize / 2);
        final top = (tileIndexY * _tileSize) + (_tileSize / 2);

        final rotationAngle = tileInfo.rotationAngle * (math.pi / 180);

        final tile =
            TileComponent(
                xMap: tileIndexX,
                yMap: tileIndexY,
                onTapDownCallback: handleTap,
              )
              ..anchor = Anchor.center
              ..size = Vector2(_tileSize, _tileSize)
              ..position = Vector2(left, top)
              ..angle = rotationAngle;
        tile.sprite = tileInfo.sprite;

        tileRow.add(tile);
        add(tile);
        if (tileInfo.type == TileType.grass) {
          _validTowerPositions.add(
            Vector2(tileIndexX.toDouble(), tileIndexY.toDouble()),
          );
        }
      }
      _tiles.add(tileRow);
    }
  }

  /// Gets tile info at (x,y). The returned object will contain information
  /// of tile sprite and rotation
  Tile _getTileInfo(int x, int y) {
    double angle = 0;
    // Calculate neighbour tiles according to this reference:
    //     0       previousY     0
    // previousX       x       nextX
    //     0         nextY       0
    final previousX = (x - 1);
    final nextX = (x + 1);
    final previousY = (y - 1);
    final nextY = (y + 1);

    // Check whether calculated tiles are inside the map or not
    final hasTileInLeft = previousX >= 0 && previousX < mapObject.width;
    final hasTileInRight = nextX >= 0 && nextX < mapObject.width;
    final hasTileInTop = previousY >= 0 && previousY < mapObject.height;
    final hasTileInBottom = nextY >= 0 && nextY < mapObject.height;

    // Get each tile
    final mapTileType = mapObject.points[y][x];
    // If left tile does exist, then get it.
    final mapTileLeftType =
        hasTileInLeft ? mapObject.points[y][previousX] : null;
    // If right tile does exist, then get it.
    final mapTileRightType = hasTileInRight ? mapObject.points[y][nextX] : null;
    // If top tile does exist, then get it.
    final mapTileTopType = hasTileInTop ? mapObject.points[previousY][x] : null;
    // If bottom tile does exist, then get it.
    final mapTileBottomType =
        hasTileInBottom ? mapObject.points[nextY][x] : null;

    // Make tile type checkings
    final isCurrentTileRoad = mapTileType == TileType.road;
    final isLeftTileRoad = mapTileLeftType == TileType.road;
    final isRightTileRoad = mapTileRightType == TileType.road;
    final isTopTileRoad = mapTileTopType == TileType.road;
    final isBottomTileRoad = mapTileBottomType == TileType.road;

    // Load the sprite for the current tile
    Sprite sprite = _tilesToSprite[mapTileType]!;
    TileType tileType = mapTileType;

    if (isCurrentTileRoad) {
      // If current is road, then check if we need to change the sprite or just rotate it.
      if (isLeftTileRoad &&
          isRightTileRoad &&
          isTopTileRoad &&
          isBottomTileRoad) {
        // When we are surrounded by roads it means we are on a junction
        sprite = _tilesToSprite[TileType.roadJunction]!;
        tileType = TileType.roadJunction;
      } else if (isLeftTileRoad && isTopTileRoad) {
        // If left tile is road, and top also is, then we are in a turn
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 180;
        tileType = TileType.roadTurn;
      } else if (isLeftTileRoad && isBottomTileRoad) {
        // If left tile is road, and bottom also is, then we are in a turn
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 90;
        tileType = TileType.roadTurn;
      } else if (isRightTileRoad && isTopTileRoad) {
        // If right tile is road, and top also is, then we are in a turn
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 270;
        tileType = TileType.roadTurn;
      } else if (isRightTileRoad && isBottomTileRoad) {
        // If right tile is road, and bottom also is, then we are in a turn
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 0;
        tileType = TileType.roadTurn;
      } else if (isRightTileRoad || isLeftTileRoad) {
        // If left or right tile are roads, then we rotate the image 90 degrees
        angle = 90;
      }
    }

    return Tile(sprite: sprite, rotationAngle: angle, type: tileType);
  }

  void handleTap(int x, int y) {
    final isValidPosition = _validTowerPositions.any(
      (pos) => pos.x == x && pos.y == y,
    );
    final towerPosition = Vector2(x.toDouble(), y.toDouble());
    final left = (x * _tileSize) + (_tileSize / 2);
    final top = (y * _tileSize) + (_tileSize / 2);

    final towerGlobalPosition = Vector2(left, top);

    if (!isValidPosition) {
      debugPrint('Invalid tower position');
      _showErrorEffect(towerGlobalPosition);
      return;
    }
    if (_occupiedTowerPositions.contains(towerPosition)) {
      debugPrint('Tower position already ocuppied');
      _showErrorEffect(towerGlobalPosition);
      return;
    }
    final attributes = TowerAttributes(damageModifier: 1.0, reachModifier: 1.0);

    final tower =
        TowerComponent(
            mapPos: towerPosition,
            towerType: '',
            tier: 1,
            range: 100,
            damage: 1,
            attributes: attributes,
          )
          ..anchor = Anchor.center
          ..position = towerGlobalPosition
          ..sprite = towerSprite
          ..size = Vector2.all(_tileSize);
    add(tower);
    _occupiedTowerPositions.add(towerPosition);
    _showSuccessEffect(towerGlobalPosition);
  }

  Future<void> _showSuccessEffect(Vector2 position) async {
    final effect = CircleComponent(
      radius: 20,
      position: position,
      paint: Paint()..color = const Color(0x7700FF00),
      anchor: Anchor.center,
      priority: 2,
    );

    add(effect);
    await effect.add(
      ScaleEffect.to(
        Vector2.all(1.5),
        EffectController(duration: 0.2, reverseDuration: 0.2, repeatCount: 1),
      ),
    );
    Future.delayed(
      const Duration(milliseconds: 500),
      () => effect.removeFromParent(),
    );
  }

  Future<void> _showErrorEffect(Vector2 position) async {
    final effect = CircleComponent(
      radius: 20,
      position: position,
      paint: Paint()..color = const Color(0x77FF0000),
      anchor: Anchor.center,
      priority: 2,
    );

    add(effect);
    await effect.add(OpacityEffect.to(0, EffectController(duration: 0.3)));
    Future.delayed(
      const Duration(milliseconds: 500),
      () => effect.removeFromParent(),
    );
  }
}
