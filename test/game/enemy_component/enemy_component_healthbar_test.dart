import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:flutter_towerdefense_game/game/component/health_bar_component.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';

void main() {
  group('EnemyComponent HealthBar', () {
    test('deve conter um HealthBarComponent como filho', () async {
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
      );

      // Como o add(healthBar) é chamado no build(), ele precisa ser montado
      // no game tree para que o Flame chame o onLoad e o add funcione.
      // Para isso, criamos um componente pai fictício e o adicionamos:
      final parent = Component()..add(enemy);

      // Avançamos o game uma vez para que o ciclo de onLoad/onMount ocorra
      await parent.onLoad();

      // Procura o HealthBarComponent entre os filhos do enemy
      final healthBar = enemy.children.whereType<HealthBarComponent>().toList();

      expect(healthBar.length, 1); // Existe exatamente um HealthBarComponent
    });
  });
}