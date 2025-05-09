
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/models/map/tile.dart';
import 'dart:math' as math;

import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

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
  late final List<SpriteComponent> _tiles = [];

  /// A map that matches tile types to their sprites/images
  late final Map<TileType, Sprite> _tilesToSprite;

  MapComponent(
    {
      required this.mapObject
    }
  );

  @override
  Future<void> onLoad() async
  {
    /// Intiliaze sprite images and variables
    await _initializeSprites();
    /// Set map scaled size
    _setMapScaledSize();
    /// Generate map
    await _generateMap();
    
    await super.onLoad();
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
    for(int tileIndexX = 0; tileIndexX < mapObject.width; tileIndexX++)
    {
      for(int tileIndexY = 0; tileIndexY < mapObject.height; tileIndexY++)
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
        
        _tiles.add(tile);
        add(tile);
      }
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

    if(isCurrentTileRoad)
    {
      // If current is road, then check if we need to change the sprite or just rotate it.
      if(isLeftTileRoad && isRightTileRoad && isTopTileRoad && isBottomTileRoad)
      {
        // When we are surrounded by roads it means we are on a junction
        sprite = _tilesToSprite[TileType.roadJunction]!;
      }
      else if(isLeftTileRoad && isTopTileRoad)
      {
        // If left tile is road, and top also is, then we are in a turn
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 180;
      }
      else if(isLeftTileRoad && isBottomTileRoad)
      {
        // If left tile is road, and bottom also is, then we are in a turn
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 90;
      }
      else if(isRightTileRoad && isTopTileRoad)
      {
        // If right tile is road, and top also is, then we are in a turn
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 270;
      }
      else if(isRightTileRoad && isBottomTileRoad)
      {
        // If right tile is road, and bottom also is, then we are in a turn
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 0;
      }
      else if(isRightTileRoad || isLeftTileRoad)
      {
        // If left or right tile are roads, then we rotate the image 90 degrees
        angle = 90;
      }
    }

    return Tile(
      sprite: sprite,
      rotationAngle: angle
    );
  }
}