import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_towerdefense_game/game/component/map_component.dart';
import 'package:flutter_towerdefense_game/game/component/tile_component.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/game/tower_defense_game.dart';
import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

import '../../__fixtures__/fixture.dart';
final testGame = FlameTester(TowerDefenseGame.new);

void main()
{
  group(
    'MapComponent',
    ()
    {
      final mapObject = MapObject(
        width: 11,
        height: 7,
        points: [
          [TileType.grass, TileType.grass, TileType.road, TileType.road, TileType.road, TileType.road, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass],
          [TileType.grass, TileType.grass, TileType.road,  TileType.grass,  TileType.grass, TileType.road, TileType.grass, TileType.road, TileType.road, TileType.road, TileType.grass],
          [TileType.road,  TileType.road,  TileType.road,  TileType.grass, TileType.grass, TileType.road, TileType.grass, TileType.road, TileType.grass, TileType.road, TileType.grass],
          [TileType.grass, TileType.grass, TileType.grass, TileType.road, TileType.road, TileType.road, TileType.road, TileType.road, TileType.grass, TileType.road, TileType.road],
          [TileType.grass, TileType.grass, TileType.grass, TileType.road, TileType.grass, TileType.road, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass],
          [TileType.grass, TileType.grass, TileType.grass, TileType.road, TileType.road, TileType.road, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass],
          [TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass, TileType.grass],
        ]
      );
      late List<List<Map<String, dynamic>>> results;

      setUp(
        () async
        {
          TestWidgetsFlutterBinding.ensureInitialized();
          final nonCastList = await Fixture.read<List>('map_component_1_result.json');
          results = nonCastList.cast<List>().map((el) => el.cast<Map<String, dynamic>>()).toList();
        }
      );
      
      testWithFlameGame(
        'generates map correctly',
        (game) async
        {
          final mapComponent = MapComponent(mapObject: mapObject);
          game.add(mapComponent);
          await game.ready();
          final tiles = mapComponent.children;
          expect(tiles, hasLength(mapObject.height*mapObject.width));
          
          for(int i = 0; i < tiles.length; i++)
          {
            final component = tiles.elementAt(i) as TileComponent;
            final result = results[component.yMap][component.xMap];
            expect(component.tileType.name, result['type']);
            expect(component.angle, closeTo(result["angle"], 0.01));
          }
        }
      );

      testGame.testGameWidget(
        'render map component correctly',
        setUp: (game, _) async
        {
          await game.ready();
        },
        verify:  (game, tester) async {
          await expectLater(
            find.byGame<TowerDefenseGame>(),
            matchesGoldenFile('_goldens/rendered_map.png'),
          );
        },
      );

    }
  );
}