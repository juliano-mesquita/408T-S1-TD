import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_towerdefense_game/models/map/tile.dart';
import 'package:flutter_towerdefense_game/models/map/tile_type.dart';
import 'dart:math' as math;

/// Modelos pro mapa
class MapObject
{
  /// Tile map width
  final int width;
  /// Tile map height
  final int height;
  /// The tiles type
  final List<List<TileType>> points;
  /// The tiles to sprite map relationship
  final Map<TileType, Sprite> tilesToSprite;
  /// The left top most road tile
  late final Vector2 leftTopMostRoadTile;

  /// Construtor do objeto
  MapObject(
    {
      required this.width,
      required this.height,
      required this.points,
      required this.tilesToSprite,
    }
  )
  {
    leftTopMostRoadTile = _findLeftTopMostRoadTile();
  }

  /// Gets tile info at (x,y). The returned object will contain information
  /// of tile sprite and rotation
  Tile getTileInfo(int x, int y)
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
    final hasTileInLeft = previousX >= 0 && previousX < width;
    final hasTileInRight = nextX >= 0 && nextX < width;
    final hasTileInTop = previousY >= 0 && previousY < height;
    final hasTileInBottom = nextY >= 0 && nextY < height;

    // Get each tile
    final mapTileType = points[y][x];
    // If left tile does exist, then get it.
    final mapTileLeftType =
        hasTileInLeft ? points[y][previousX] : null;
    // If right tile does exist, then get it.
    final mapTileRightType = hasTileInRight ? points[y][nextX] : null;
    // If top tile does exist, then get it.
    final mapTileTopType = hasTileInTop ? points[previousY][x] : null;
    // If bottom tile does exist, then get it.
    final mapTileBottomType =
        hasTileInBottom ? points[nextY][x] : null;

    // Make tile type checkings
    final isCurrentTileRoad = mapTileType == TileType.road;
    final isLeftTileRoad = mapTileLeftType == TileType.road;
    final isRightTileRoad = mapTileRightType == TileType.road;
    final isTopTileRoad = mapTileTopType == TileType.road;
    final isBottomTileRoad = mapTileBottomType == TileType.road;

    // Load the sprite for the current tile
    Sprite sprite = tilesToSprite[mapTileType]!;
    TileType tileType = mapTileType;

    if (isCurrentTileRoad) {
      // If current is road, then check if we need to change the sprite or just rotate it.
      if (isLeftTileRoad &&
          isRightTileRoad &&
          isTopTileRoad &&
          isBottomTileRoad) {
        // When we are surrounded by roads it means we are on a junction
        sprite = tilesToSprite[TileType.roadJunction]!;
        tileType = TileType.roadJunction;
      } else if (isLeftTileRoad && isTopTileRoad) {
        // If left tile is road, and top also is, then we are in a turn
        sprite = tilesToSprite[TileType.roadTurn]!;
        angle = 180;
        tileType = TileType.roadTurn;
      } else if (isLeftTileRoad && isBottomTileRoad) {
        // If left tile is road, and bottom also is, then we are in a turn
        sprite = tilesToSprite[TileType.roadTurn]!;
        angle = 90;
        tileType = TileType.roadTurn;
      } else if (isRightTileRoad && isTopTileRoad) {
        // If right tile is road, and top also is, then we are in a turn
        sprite = tilesToSprite[TileType.roadTurn]!;
        angle = 270;
        tileType = TileType.roadTurn;
      } else if (isRightTileRoad && isBottomTileRoad) {
        // If right tile is road, and bottom also is, then we are in a turn
        sprite = tilesToSprite[TileType.roadTurn]!;
        angle = 0;
        tileType = TileType.roadTurn;
      } else if (isRightTileRoad || isLeftTileRoad) {
        // If left or right tile are roads, then we rotate the image 90 degrees
        angle = 90;
      }
    }

    return Tile(sprite: sprite, rotationAngle: angle, type: tileType);
  }

  Vector2 _findLeftTopMostRoadTile()
  {
    //TODO: Optimize to break after finding the first point when looking from top/left to bottom/right
    final tiles = points.map(
      (row) => row.indexWhere((tile) => tile == TileType.road),
    );
    int minY = tiles.length;
    int minX = tiles.reduce(math.max);
    
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (points[y][x] == TileType.road && x <= minX) {
          minX = x;
        }
      }
    }

    for (int y = 0; y < height; y++) {
      if (points[y][minX] == TileType.road && y <= minY) {
        minY = y;
      }
    }

    return Vector2(minX.toDouble(), minY.toDouble());
  }
}