import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/models/map/tile_type.dart';
import 'package:test/test.dart';

void main()
{
  test(
    'should initialize properties correctly',
    ()
    {
      const width = 10;
      const height = 15;
      final List<List<TileType>> points =
      [
        [ TileType.grass ]
      ];
      final mapObject = MapObject(
        width: width,
        height: height,
        points: points
      );
      expect(mapObject.height, equals(height));
      expect(mapObject.width, equals(width));
      expect(mapObject.points, equals(points));
    }
  );
}