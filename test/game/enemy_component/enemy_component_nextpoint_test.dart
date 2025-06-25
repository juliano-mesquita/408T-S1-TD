import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';

// Helper para criar tiles fictícios
List<List<SpriteComponent>> makeDummyTiles(int w, int h) {
  return List.generate(
    h,
    (_) => List.generate(
      w,
      (_) => SpriteComponent()..center = Vector2(0, 0),
    ),
  );
}

void main() {
  group('EnemyComponent.nextPoint', () {
    test('retorna o próximo ponto válido para a direita', () {
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

    test('retorna o próximo ponto válido para baixo quando não há direita', () {
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
    });

    test('retorna null quando não há próximo ponto válido', () {
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
}