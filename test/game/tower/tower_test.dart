import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import 'package:flutter_towerdefense_game/game/tower/tower_component.dart';
import 'package:flutter_towerdefense_game/game/enemy_component/enemy_component.dart';
import 'package:flutter_towerdefense_game/game/tower/tower_attributes.dart';

// Subclasse para facilitar teste
class TestTower extends TowerComponent {
  bool didShoot = false;

  TestTower({
    required super.towerType,
    required super.tier,
    required super.range,
    required super.damage,
    required super.mapPos,
    required super.attributes,
    required super.fireRate,
  });

  @override
  void shoot() {
    final foundTarget = findTargetInRange();
  if (foundTarget == null || !foundTarget.isMounted) return;

  target = foundTarget;
  didShoot = true;

  print('Atirando no inimigo!');
  fireTimer.start();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWithFlameGame('Torre dispara se inimigo estiver no alcance', (game) async {
    // Adiciona torre
    final tower = TestTower(
      towerType: 'basic',
      tier: 1,
      range: 80,
      damage: 10,
      fireRate: 0.1,
      mapPos: Vector2(100, 100),
      attributes: TowerAttributes(reachModifier: 1.0, damageModifier: 1.0),
    )
     ..sprite = Sprite(
                await Flame.images.load('indios_garimpeiros/garimpeira.png'),
              );

    await game.ensureAdd(tower);

    // Cria tiles fake
    final tiles = List.generate(5, (_) =>
      List.generate(5, (_) => SpriteComponent(size: Vector2.all(32))));

    // Adiciona inimigo no alcance
    final enemy = EnemyComponent.build(
      type: EnemyType.type1,
      path: [
        [0, 0, 0, 0, 0],
        [0, 1, 1, 1, 0],
        [0, 0, 0, 0, 0],
      ],
      startPos: Vector2(2, 1),
      tiles: tiles,
    )
     ..sprite = Sprite(
                await Flame.images.load('indios_garimpeiros/garimpeira.png'),
              )
      ..position = Vector2(110, 100); // Perto da torre

    await game.ensureAdd(enemy);

    // Avança o tempo até ultrapassar o fireRate
     game.update(0.05); // inicia o timer
     game.update(0.1); // completa o tempo

    expect(tower.didShoot, isTrue);
  });

  testWithFlameGame('Torre não dispara sem inimigo no alcance', (game) async {
    final tower = TestTower(
      towerType: 'basic',
      tier: 1,
      range: 50,
      damage: 10,
      fireRate: 0.1,
      mapPos: Vector2(100, 100),
      attributes: TowerAttributes(reachModifier:1.0, damageModifier: 1.0),
    )
     ..sprite = Sprite(
                await Flame.images.load('indios_garimpeiros/garimpeira.png'),
              );

    await game.ensureAdd(tower);

    // Adiciona inimigo fora do alcance
    final enemy = EnemyComponent.build(
      type: EnemyType.type1,
      path: [
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0],
      ],
      startPos: Vector2(1, 1),
      tiles: [
        [SpriteComponent(size: Vector2.all(32))],
        [SpriteComponent(size: Vector2.all(32))],
        [SpriteComponent(size: Vector2.all(32))],
      ],
    )
     ..sprite = Sprite(
                await Flame.images.load('indios_garimpeiros/garimpeira.png'),
              )
      ..position = Vector2(300, 300); // Longe da torre

    await game.ensureAdd(enemy);
    await game.ready();
     game.update(0.1);

    expect(tower.didShoot, isFalse);
  });
}