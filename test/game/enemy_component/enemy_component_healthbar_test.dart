import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:flutter_towerdefense_game/game/component/health_bar_component.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('EnemyComponent HealthBar', () {
    testWithFlameGame(
      'deve conter um HealthBarComponent como filho',
      (game) async {
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
      final enemy = EnemyComponent.build(
        type: EnemyType.type1,
        path: path,
        startPos: Vector2(0, 0),
        tiles: tiles,
      )
        ..sprite = Sprite(
          await Flame.images.load('indios_garimpeiros/garimpeira.png'),  
        )
        ..size = Vector2(35,35)
        ..anchor = Anchor.center;
    
      game.add(enemy);
      await game.ready();
      final healthBar = enemy.children.whereType<HealthBarComponent>().toList();

      expect(healthBar.length, 1); // Existe exatamente um HealthBarComponent
    });
  });
}