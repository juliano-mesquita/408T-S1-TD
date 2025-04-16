
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/models/map/tile.dart';
import 'dart:math' as math;

import 'package:flutter_towerdefense_game/models/map/tile_type.dart';


class BackgroundComponent extends PositionComponent
{
  // Objeto contendo informações do mapa(largura em tiles, altura em tiles, etc.)
  final MapObject mapObject;
  
  late final double _refSize;
  late final double _tileSize;

  late final List<SpriteComponent> _tiles = [];

  late final Map<TileType, Sprite> _tilesToSprite;

  /// Construtor com parâmetros nomeado
  BackgroundComponent(
    {
      required this.mapObject
    }
  );

  @override
  Future<void> onLoad() async
  {
    final tileGrassImage = await Flame.images.load('floor/tile.png');
    final tileRoadImage = await Flame.images.load('floor/tile_road.png');
    final tileRoadJunctionImage = await Flame.images.load('floor/tile_road_junction.png');
    final tileRoadTurnImage = await Flame.images.load('floor/tile_road_turn.png');

    _tilesToSprite =
    {
      TileType.grass: Sprite(tileGrassImage),
      TileType.road: Sprite(tileRoadImage),
      TileType.roadJunction: Sprite(tileRoadJunctionImage),
      TileType.roadTurn: Sprite(tileRoadTurnImage)
    };

    _refSize = math.min(size.x, size.y).floorToDouble();
    // Calculo para tamanho da tile em pixels
    _tileSize = (_refSize/mapObject.width).floorToDouble();

    // Renderiza o chessboard
    for(int tileIndexX = 0; tileIndexX < mapObject.width; tileIndexX++)
    {
      for(int tileIndexY = 0; tileIndexY < mapObject.height; tileIndexY++)
      {
        var tileInfo = _getTileInfo(tileIndexX, tileIndexY);

        final left = (tileIndexX*_tileSize);
        final top = (tileIndexY*_tileSize);

        final rotationAngle = tileInfo.rotationAngle*(math.pi/180);

        final tile = SpriteComponent(
          anchor: Anchor.topLeft,
          size: Vector2(_tileSize, _tileSize),
          position: Vector2(left, top),
        );
        print('left: $left top: $top width: $_tileSize height: $_tileSize');
        print(tile.center);
        print(tile.position);
        // tile.position.rotate(angle)
        tile.position.rotate(rotationAngle, center: Vector2(_tileSize/2.0, _tileSize/2.0));
        // tile.transform.angleDegrees = tileInfo.rotationAngle;
        tile.sprite = tileInfo.sprite;
        
        _tiles.add(tile);
        add(tile);
      }
    }
    super.onLoad();
  }

  Tile _getTileInfo(int x, int y)
  {
    double angle = 0;

    final previousX = (x - 1);
    final nextX = (x + 1);
    final previousY = (y - 1);
    final nextY = (y + 1);

    final int index = (y * mapObject.height) + x;
    final int indexLeft = (y * mapObject.height) + previousX;
    final int indexRight = (y * mapObject.height) + nextX;
    final int indexTop = (previousY * mapObject.height) + x;
    final int indexBottom = (nextY * mapObject.height) + x;

    final hasTileInLeft = previousX >= 0 && previousX < mapObject.width;
    final hasTileInRight = nextX >= 0 && nextX < mapObject.width;
    final hasTileInTop = previousY >= 0 && previousY < mapObject.height;
    final hasTileInBottom = nextY >= 0 && nextY < mapObject.height;

    final mapTileType = mapObject.points[index];
    final mapTileLeftType = hasTileInLeft ? mapObject.points[indexLeft] : null;
    final mapTileRightType = hasTileInRight ? mapObject.points[indexRight] : null;
    final mapTileTopType = hasTileInTop ? mapObject.points[indexTop] : null;
    final mapTileBottomType = hasTileInBottom ? mapObject.points[indexBottom] : null;

    final isCurrentTileRoad = mapTileType == TileType.road;
    final isLeftTileRoad = mapTileLeftType == TileType.road;
    final isRightTileRoad = mapTileRightType == TileType.road;
    final isTopTileRoad = mapTileTopType == TileType.road;
    final isBottomTileRoad = mapTileBottomType == TileType.road;

    Sprite sprite = _tilesToSprite[mapTileType]!;

    print('isLeftTileRoad: $isLeftTileRoad');
    print('isRightTileRoad: $isRightTileRoad');
    print('isTopTileRoad: $isTopTileRoad');
    print('isBottomTileRoad: $isBottomTileRoad');
    print('x: $x y: $y');

    if(isCurrentTileRoad)
    {
      if(isLeftTileRoad && isRightTileRoad && isTopTileRoad && isBottomTileRoad)
      {
        sprite = _tilesToSprite[TileType.roadJunction]!;
      }
      else if(isLeftTileRoad && isTopTileRoad)
      {
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 180;
      }
      else if(isLeftTileRoad && isBottomTileRoad)
      {
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 90;
      }
      else if(isRightTileRoad && isTopTileRoad)
      {
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 270;
      }
      else if(isRightTileRoad && isBottomTileRoad)
      {
        sprite = _tilesToSprite[TileType.roadTurn]!;
        angle = 0;
      }
      else if(isRightTileRoad)
      {
        angle = 90;
      }
    }

    return Tile(
      sprite: sprite,
      rotationAngle: angle
    );
  }
}