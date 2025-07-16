import 'package:flame/extensions.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/models/map/tile_type.dart';
import 'package:test/test.dart';

void main()
{
  test(
    'should initialize properties correctly',
    ()
    {
      const width = 2;
      const height = 2;
      final List<List<TileType>> points =
      [
        [ TileType.grass, TileType.grass ],
        [TileType.road, TileType.road]
      ];
      final mapObject = MapObject(
        width: width,
        height: height,
        points: points,
        tilesToSprite: {}
      );
      expect(mapObject.height, equals(height));
      expect(mapObject.width, equals(width));
      expect(mapObject.points, equals(points));
      expect(mapObject.leftTopMostRoadTile, equals(Vector2(0, 1)));
    }
  );
}