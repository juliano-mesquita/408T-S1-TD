
import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/models/map/tile.dart';
import 'dart:math' as math;

import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

class EnemyComponent extends PositionComponent
{
  final List<List<int>> path;
  final Vector2 startPos;
  final List<List<SpriteComponent>> tiles;
  Vector2 _pos;

  Vector2 _nextPoint(Vector2 pos)
  {
    final mapWidth = path[0].length;
    final mapHeight = path.length;
    final posX = pos.x.toInt();
    final posY = pos.y.toInt();
    
    // Calculate neighbour tiles according to this reference:
    //     0       previousY     0
    // previousX       x       nextX
    //     0         nextY       0
    final previousX = (posX - 1);
    final nextX = (posX + 1);
    final previousY = (posY - 1);
    final nextY = (posY + 1);

    // Check whether calculated tiles are inside the map or not 
    final hasTileInLeft = previousX >= 0 && previousX < mapWidth;
    final hasTileInRight = nextX >= 0 && nextX < mapWidth;
    final hasTileInTop = previousY >= 0 && previousY < mapHeight;
    final hasTileInBottom = nextY >= 0 && nextY < mapHeight;

    // Get each tile
    // If left tile does exist, then get it.
    final mapTileLeftType = hasTileInLeft ? path[posY][previousX] : null;
    // If right tile does exist, then get it.
    final mapTileRightType = hasTileInRight ? path[posY][nextX] : null;
    // If top tile does exist, then get it.
    final mapTileTopType = hasTileInTop ? path[previousY][posX] : null;
    // If bottom tile does exist, then get it.
    final mapTileBottomType = hasTileInBottom ? path[nextY][posX] : null;
    // Greater than 0 means a road type
    if((mapTileBottomType ?? 0) > 0)
    {
      return Vector2(posX.toDouble(), nextY.toDouble());
    }
    if((mapTileRightType ?? 0) > 0)
    {
      return Vector2(nextX.toDouble(), posY.toDouble());
    }
    if((mapTileTopType ?? 0) > 0)
    {
      return Vector2(posX.toDouble(), previousY.toDouble());
    }
    
    if((mapTileLeftType ?? 0) > 0)
    {
      return Vector2(previousX.toDouble(), posY.toDouble());
    }
    throw Exception('Invalid position');
  }
  

  EnemyComponent(
    {
      required this.path,
      required this.startPos,
      required this.tiles
    }
  )
  :
    _pos = startPos
  {
    print(path.map((path) => path.join('\t')).join('\n'));
  }

  @override
  void render(Canvas canvas)
  {
    canvas.drawRect(size.toRect(), Paint()..color=Colors.red..style=PaintingStyle.fill);
    super.render(canvas);
  }

  @override
  void update(double dt)
  {
    var nextPos = _nextPoint(_pos);

    final currentTile = tiles[_pos.y.toInt()][_pos.x.toInt()];
    final nextTile = tiles[nextPos.y.toInt()][nextPos.x.toInt()];

    var currentTileXDiff = nextTile.center.x - center.x;
    var currentTileYDiff = nextTile.center.y - center.y;
    
    if(currentTileXDiff.abs() < 1 && currentTileYDiff.abs() < 1)
    {
      // 0 means we've gonne through it
      path[_pos.y.toInt()][_pos.x.toInt()] = (path[_pos.y.toInt()][_pos.x.toInt()]/3).floor();
      _pos = nextPos;
      nextPos = _nextPoint(_pos);

      print(_pos);
      print(nextPos);
      print(path.map((path) => path.join('\t')).join('\n'));
      print(center);
      print(tiles[nextPos.y.toInt()][nextPos.x.toInt()].center);
    }
    
    const stepX = 50;
    const stepY = 50;
    var xDiff = nextTile.center.x - center.x;
    var yDiff = nextTile.center.y - center.y;

    position.x += dt*stepX*xDiff.sign;
    position.y += dt*stepY*yDiff.sign;
    super.update(dt);
  }
}

/// A component that generates a map based on provided tiles
/// 
/// The road tiles will be rotated to create a concise path
class MapComponent extends PositionComponent
{
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

  MapComponent(
    {
      required this.mapObject
    }
  );

  Vector2 findLeftTopMostRoadTile()
  {
    final tiles = mapObject.points.map((row) => row.indexWhere((tile) => tile == TileType.road));
    int minY = tiles.length;
    int minX = tiles.first;
    for(int y = 0; y < mapObject.height; y++)
    {
      for(int x = 0; x < mapObject.width; x++)
      {
        if(mapObject.points[y][x] == TileType.road && x <= minX)
        {
          minX = x;
        }
      }
    }

    for(int y = 0; y < mapObject.height; y++)
    {
      if(mapObject.points[y][minX] == TileType.road && y <= minY)
      {
        minY = y;
      }
    }

    return Vector2(minX.toDouble(), minY.toDouble());
  }

  @override
  Future<void> onLoad() async
  {
    /// Intiliaze sprite images and variables
    await _initializeSprites();
    /// Set map scaled size
    _setMapScaledSize();
    /// Generate map
    await _generateMap();
    
    Timer.periodic(const Duration(seconds: 2), (_) => _addEnemy());
    
    await super.onLoad();
  }

  void _addEnemy()
  {
    final firstRoadTilePos = findLeftTopMostRoadTile();
    var firstRoadTile = _tiles[firstRoadTilePos.y.toInt()][firstRoadTilePos.x.toInt()];
    final List<List<int>> enemyPath = [];
    for(int y = 0; y < _tiles.length; y++)
    {
      final List<int> column = [];
      for(int x = 0; x < _tiles[y].length; x++)
      {
        final tileInfo = _getTileInfo(x, y);
        switch(tileInfo.type)
        {
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
    final enemy = EnemyComponent(path: enemyPath, startPos: firstRoadTilePos, tiles: _tiles)
        ..size = Vector2(15, 15)
        ..anchor = Anchor.topLeft
        ..position = Vector2(firstRoadTile.topLeftPosition.x - firstRoadTile.width, firstRoadTile.topLeftPosition.y);
    add(enemy);
    _enemies.add(enemy);
  }

  /// Calculates and scale map tile sizes
  void _setMapScaledSize()
  {
    // Create a reference size based on the smallest viewport size
    _viewPortRefSize = math.min(size.x, size.y).floorToDouble();
    // Creates the tile size given the ref size and viewport size
    _tileSize = (_viewPortRefSize/math.max(mapObject.width, mapObject.height)).floorToDouble();
  }

  Future<void> _initializeSprites() async
  {
    // Initialize images
    final tileGrassImage = await Flame.images.load('floor/tile.png');
    final tileRoadImage = await Flame.images.load('floor/tile_road.png');
    final tileRoadJunctionImage = await Flame.images.load('floor/tile_road_junction.png');
    final tileRoadTurnImage = await Flame.images.load('floor/tile_road_turn.png');

    // Generate sprites from the images
    _tilesToSprite =
    {
      TileType.grass: Sprite(tileGrassImage),
      TileType.road: Sprite(tileRoadImage),
      TileType.roadJunction: Sprite(tileRoadJunctionImage),
      TileType.roadTurn: Sprite(tileRoadTurnImage)
    };
  }

  /// Generates the map based on provided [mapObject] and
  /// scaled viewport sizes
  Future<void> _generateMap() async
  {
    for(int tileIndexY = 0; tileIndexY < mapObject.height; tileIndexY++)
    {
      final List<SpriteComponent> tileRow = [];
      for(int tileIndexX = 0; tileIndexX < mapObject.width; tileIndexX++)
      {
        var tileInfo = _getTileInfo(tileIndexX, tileIndexY);

        final left = (tileIndexX*_tileSize)+(_tileSize/2);
        final top = (tileIndexY*_tileSize)+(_tileSize/2);

        final rotationAngle = tileInfo.rotationAngle*(math.pi/180);

        final tile = SpriteComponent(
          anchor: Anchor.center,
          size: Vector2(_tileSize, _tileSize),
          position: Vector2(left, top),
          angle: rotationAngle
        );
        tile.sprite = tileInfo.sprite;
        
        tileRow.add(tile);
        add(tile);
      }
      _tiles.add(tileRow);
    }
  }

  /// Gets tile info at (x,y). The returned object will contain information
  /// of tile sprite and rotation
  Tile _getTileInfo(int x, int y)
  {
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
    final mapTileLeftType = hasTileInLeft ? mapObject.points[y][previousX] : null;
    // If right tile does exist, then get it.
    final mapTileRightType = hasTileInRight ? mapObject.points[y][nextX] : null;
    // If top tile does exist, then get it.
    final mapTileTopType = hasTileInTop ? mapObject.points[previousY][x] : null;
    // If bottom tile does exist, then get it.
    final mapTileBottomType = hasTileInBottom ? mapObject.points[nextY][x] : null;

    // Make tile type checkings
    final isCurrentTileRoad = mapTileType == TileType.road;
    final isLeftTileRoad = mapTileLeftType == TileType.road;
    final isRightTileRoad = mapTileRightType == TileType.road;
    final isTopTileRoad = mapTileTopType == TileType.road;
    final isBottomTileRoad = mapTileBottomType == TileType.road;

    // Load the sprite for the current tile
    Sprite sprite = _tilesToSprite[mapTileType]!;
    TileType tileType = mapTileType;

    if(isCurrentTileRoad)
    {
      // If current is road, then check if we need to change the sprite or just rotate it.
      if(isLeftTileRoad && isRightTileRoad && isTopTileRoad && isBottomTileRoad)
      {
        // When we are surrounded by roads it means we are on a junction
        sprite = _tilesToSprite[TileType.roadJunction]!;
        tileType = TileType.roadJunction;
      }
      else if(isLeftTileRoad && isTopTileRoad)
      {
        // If left tile is road, and top also is, then we are in a turn
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 180;
        tileType = TileType.roadTurn;
      }
      else if(isLeftTileRoad && isBottomTileRoad)
      {
        // If left tile is road, and bottom also is, then we are in a turn
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 90;
        tileType = TileType.roadTurn;
      }
      else if(isRightTileRoad && isTopTileRoad)
      {
        // If right tile is road, and top also is, then we are in a turn
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 270;
        tileType = TileType.roadTurn;
      }
      else if(isRightTileRoad && isBottomTileRoad)
      {
        // If right tile is road, and bottom also is, then we are in a turn
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 0;
        tileType = TileType.roadTurn;
      }
      else if(isRightTileRoad || isLeftTileRoad)
      {
        // If left or right tile are roads, then we rotate the image 90 degrees
        angle = 90;
      }
    }

    return Tile(
      sprite: sprite,
      rotationAngle: angle,
      type: tileType
    );
  }
}