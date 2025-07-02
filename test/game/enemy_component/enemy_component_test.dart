import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:flutter_towerdefense_game/game/component/health_bar_component.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';

List<List<SpriteComponent>> makeDummyTiles(int w, int h) {
  return List.generate(
    h,
    (_) => List.generate(w, (_) => SpriteComponent()..center = Vector2(0, 0)),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('EnemyComponent', () {
    group('WHEN reach end', () {
      testWithFlameGame('Enemy is removed', (
        game,
      ) async {
        // Setup: criar um caminho 2 tiles e marcar o fim como sem caminho
        final path = [
          [1], // Start (tile com caminho)
          [0], // Fim (sem caminho = fim da linha para o inimigo)
        ];

        final tileSize = Vector2(32, 32);

        // Cria os tiles do mapa (só precisam ter center definido)
        final tiles = List.generate(
          path.length,
          (y) => List.generate(path[0].length, (x) {
            final tile =
                SpriteComponent()
                  ..size = tileSize
                  ..position = Vector2(
                    x.toDouble() * tileSize.x,
                    y.toDouble() * tileSize.y,
                  );
            return tile;
          }),
        );

        final enemy =
            EnemyComponent.build(
                type: EnemyType.type1,
                path: path,
                startPos: Vector2(0, 0),
                tiles: tiles,
              )
              ..sprite = Sprite(
                await Flame.images.load('indios_garimpeiros/garimpeira.png'),
              )
              ..size = Vector2(35, 35)
              ..anchor = Anchor.center;

        await game.ensureAdd(enemy);

        // Posiciona o inimigo para já estar no centro do tile
        enemy.position = tiles[0][0].center.clone();

        // Avança o tempo em updates de 0.1 segundos
        for (var i = 0; i < 50; i++) {
          game.update(0.1);
        }

        // Verifica se o inimigo foi removido
        expect(enemy.isMounted, isFalse);
      });
    });

    group('verify next point', () {
      test('Returns next right valid point', () {
        final path = [
          [1, 1, 0],
          [0, 1, 0],
          [0, 1, 0],
        ];
        final enemy = EnemyComponent(
          health: 100,
          speed: 10,
          path: path,
          startPos: Vector2(0, 0),
          tiles: makeDummyTiles(3, 3),
        );

        final next = enemy.nextPoint(Vector2(0, 0));
        expect(next, equals(Vector2(1, 0))); // segue para direita
      });

      test('Returns next downwards valid point when theres no more right point',
        () {
          final path = [
            [1, 0, 0],
            [1, 1, 0],
            [0, 0, 0],
          ];
          final enemy = EnemyComponent(
            health: 100,
            speed: 10,
            path: path,
            startPos: Vector2(0, 0),
            tiles: makeDummyTiles(3, 3),
          );

          final next = enemy.nextPoint(Vector2(0, 0));
          expect(next, equals(Vector2(0, 1))); // segue para baixo
        },
      );

      test('Returns NULL when no more next valid point', () {
        final path = [
          [1, 0, 0],
          [0, 0, 0],
        ];
        final enemy = EnemyComponent(
          health: 100,
          speed: 10,
          path: path,
          startPos: Vector2(0, 0),
          tiles: makeDummyTiles(3, 2),
        );

        final next = enemy.nextPoint(Vector2(0, 0));
        expect(next, isNull); // fim da estrada
      });
    });

    group('WHEN init', () {
      testWithFlameGame('Should contain HealthBarComponent as children', (
        game,
      ) async {
        // Dados dummy para instanciar o inimigo
        final path = [
          [1, 1, 0],
          [0, 1, 0],
        ];
        final tiles = List.generate(
          2,
          (_) => List.generate(3, (_) => SpriteComponent()),
        );

        // Instancia o EnemyComponent usando o construtor build
        final enemy =
            EnemyComponent.build(
                type: EnemyType.type1,
                path: path,
                startPos: Vector2(0, 0),
                tiles: tiles,
              )
              ..sprite = Sprite(
                await Flame.images.load('indios_garimpeiros/garimpeira.png'),
              )
              ..size = Vector2(35, 35)
              ..anchor = Anchor.center;

        game.add(enemy);
        await game.ready();
        final healthBar =
            enemy.children.whereType<HealthBarComponent>().toList();

        expect(healthBar.length, 1); // Existe exatamente um HealthBarComponent
      });
    });
  });
}
