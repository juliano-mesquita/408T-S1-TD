import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_towerdefense_game/game/component/health_bar_component.dart';
import 'package:flutter_towerdefense_game/models/enemy.dart';

enum EnemyType { type1, type2, type3 }

class EnemyComponent extends SpriteComponent {
  final Enemy enemyData;
  late final Vector2 startPos;
  late final List<List<SpriteComponent>> tiles;
  final void Function()? onReachedEnd;
  Vector2 _pos;
  late HealthBarComponent healthBar;

  EnemyComponent({
    required this.enemyData,
    required this.startPos,
    required this.tiles,
    this.onReachedEnd,
  })
  :
    _pos = startPos.clone();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final healthBarSize = Vector2(20, 4);
    healthBar =
        HealthBarComponent(
            maxHealth: enemyData.health.toDouble(),
            currentHealth: enemyData.health.toDouble(),
          )
          ..size = healthBarSize
          ..position = Vector2(
            (width / 2) - (healthBarSize.x / 2),
            -10,
          ); // position above sprite

    add(healthBar); // add as children
  }

  @visibleForTesting
  Vector2? nextPoint(Vector2 pos) {
    final mapWidth = enemyData.path[0].length;
    final mapHeight = enemyData.path.length;
    final posX = pos.x.toInt();
    final posY = pos.y.toInt();

    // Calculate neighbour tiles according to this reference:
    //     0       previousY     0
    // previousX       x       nextX
    //     0         nextY       0
    final previousX = (posX - 1);
    final nextX = (posX + 1);
    final previousY = (posY - 1);
    final nextY = (posY + 1);

    // Check whether calculated tiles are inside the map or not
    final hasTileInLeft = previousX >= 0 && previousX < mapWidth;
    final hasTileInRight = nextX >= 0 && nextX < mapWidth;
    final hasTileInTop = previousY >= 0 && previousY < mapHeight;
    final hasTileInBottom = nextY >= 0 && nextY < mapHeight;

    // Get each tile
    // If left tile does exist, then get it.
    final mapTileLeftType = hasTileInLeft ? enemyData.path[posY][previousX] : null;
    // If right tile does exist, then get it.
    final mapTileRightType = hasTileInRight ? enemyData.path[posY][nextX] : null;
    // If top tile does exist, then get it.
    final mapTileTopType = hasTileInTop ? enemyData.path[previousY][posX] : null;
    // If bottom tile does exist, then get it.
    final mapTileBottomType = hasTileInBottom ? enemyData.path[nextY][posX] : null;
    // Greater than 0 means a road type
    if ((mapTileBottomType ?? 0) > 0) {
      return Vector2(posX.toDouble(), nextY.toDouble());
    }
    if ((mapTileRightType ?? 0) > 0) {
      return Vector2(nextX.toDouble(), posY.toDouble());
    }
    if ((mapTileTopType ?? 0) > 0) {
      return Vector2(posX.toDouble(), previousY.toDouble());
    }

    if ((mapTileLeftType ?? 0) > 0) {
      return Vector2(previousX.toDouble(), posY.toDouble());
    }
    return null;
  }

  @override
  void update(double dt) {
    // TODO: move enemy outside playable map and remove it from component tree
    var nextPos = nextPoint(_pos);

    if (nextPos == null) {
      // O inimigo chegou ao final
      onReachedEnd?.call(); // Função que você vai criar para aplicar o dano
      removeFromParent(); // Remove o inimigo da cena
      return;
    }

    final nextTile = tiles[nextPos.y.toInt()][nextPos.x.toInt()];

    var currentTileXDiff = nextTile.center.x - center.x;
    var currentTileYDiff = nextTile.center.y - center.y;

    // If we've reached the tile center we must find the next tile and move
    // the enemy towards the next tile center
    if (currentTileXDiff.abs() < 1 && currentTileYDiff.abs() < 1) {
      // 0 means we've gone through it
      // Any number above it will be treated as "not interacted"
      //
      // Junctions have a number of 3. In other words, they must be "walked on" twice
      // in order to be counted as fully interacted with/finished
      enemyData.path[_pos.y.toInt()][_pos.x.toInt()] =
          (enemyData.path[_pos.y.toInt()][_pos.x.toInt()] / 3).floor();
      _pos = nextPos;
      // Fetch next point
      nextPos = nextPoint(_pos);
    }
    final stepX = enemyData.speed.toDouble();
    final stepY = enemyData.speed.toDouble();
    var xDiff = nextTile.center.x - center.x;
    var yDiff = nextTile.center.y - center.y;

    position.x += dt * stepX * xDiff.sign;
    position.y += dt * stepY * yDiff.sign;
    super.update(dt);
  }
}
