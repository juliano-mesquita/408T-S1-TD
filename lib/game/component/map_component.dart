import 'dart:async';
import 'package:flame/components.dart' hide Timer;
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/game/component/tile_component.dart';
import 'package:flutter_towerdefense_game/game/market/market_item.dart';
import 'package:flutter_towerdefense_game/game/market/market_service.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';
import 'package:flutter_towerdefense_game/game/tower/tower_attributes.dart';
import 'package:flutter_towerdefense_game/game/tower/tower_component.dart';
import 'dart:math' as math;

import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

class TowerData
{
  final int tier;
  final double range;
  final double damage;

  final TowerAttributes attributes;

  final String assetPath;
  final double fireRate;

  TowerData(
    {
      required this.tier,
      required this.range,
      required this.damage,
      required this.attributes,
      required this.assetPath,
      required this.fireRate
    }
  );
}

Map<String, TowerData> _towers =
{
  'femea1': TowerData(
    assetPath: 'indios_garimpeiros/india_um.png',
    attributes: TowerAttributes(damageModifier: 1, reachModifier: 1),
    damage: 5,
    fireRate: 1,
    range: 100,
    tier: 1
  ),
  'macho2': TowerData(
    assetPath: 'indios_garimpeiros/indio_dois.png',
    attributes: TowerAttributes(damageModifier: 1, reachModifier: 1),
    damage: 50,
    fireRate: 1,
    range: 100,
    tier: 1
  ),
  'femea2': TowerData(
    assetPath: 'indios_garimpeiros/india_dois.png',
    attributes: TowerAttributes(damageModifier: 1, reachModifier: 1),
    damage: 50,
    fireRate: 1,
    range: 100,
    tier: 1
  ),
  'macho3': TowerData(
    assetPath: 'indios_garimpeiros/indio_tres.png',
    attributes: TowerAttributes(damageModifier: 1, reachModifier: 1),
    damage: 50,
    fireRate: 1,
    range: 100,
    tier: 1
  ),
  'miniindio': TowerData(
    assetPath: 'indios_garimpeiros/mini_indio.png',
    attributes: TowerAttributes(damageModifier: 1, reachModifier: 1),
    damage: 50,
    fireRate: 1,
    range: 100,
    tier: 1
  ),
  'cacique': TowerData(
    assetPath: 'indios_garimpeiros/cacique.png',
    attributes: TowerAttributes(damageModifier: 100, reachModifier: 100),
    damage: 500,
    fireRate: 1,
    range: 1000,
    tier: 1
  ),
};

/// A component that generates a map based on provided tiles
///
/// The road tiles will be rotated to create a concise path
class MapComponent extends PositionComponent {
  // Object containing map information
  final MapObject mapObject;

  /// Viewport reference size
  late final double _viewPortRefSize;

  /// The tile size after scaling to viewport
  late final double _tileSize;

  /// A list of tiles generated for the map
  late final List<List<SpriteComponent>> _tiles = [];

  List<List<SpriteComponent>> get tiles => List.unmodifiable(_tiles);

  final List<Vector2> _validTowerPositions = [];

  final Set<Vector2> _occupiedTowerPositions = {};

  final MarketService market;

  MapComponent({required this.mapObject, required this.market});

  /// Finds the first top left road in them map
  @override
  Future<void> onLoad() async {

    /// Set map scaled size
    _setMapScaledSize();

    /// Generate map
    await _generateMap();

    await super.onLoad();
  }

  /// Calculates and scale map tile sizes
  void _setMapScaledSize() {
    // Create a reference size based on the smallest viewport size
    _viewPortRefSize = math.min(size.x, size.y).floorToDouble();
    // Creates the tile size given the ref size and viewport size
    _tileSize =
        (_viewPortRefSize / math.max(mapObject.width, mapObject.height))
            .floorToDouble();
  }

  /// Generates the map based on provided [mapObject] and
  /// scaled viewport sizes
  Future<void> _generateMap() async {
    for (int tileIndexY = 0; tileIndexY < mapObject.height; tileIndexY++) {
      final List<SpriteComponent> tileRow = [];
      for (int tileIndexX = 0; tileIndexX < mapObject.width; tileIndexX++) {
        var tileInfo = mapObject.getTileInfo(tileIndexX, tileIndexY);

        final left = (tileIndexX * _tileSize) + (_tileSize / 2);
        final top = (tileIndexY * _tileSize) + (_tileSize / 2);

        final rotationAngle = tileInfo.rotationAngle * (math.pi / 180);

        final tile =
            TileComponent(
                xMap: tileIndexX,
                yMap: tileIndexY,
                onTapDownCallback: handleTap,
              )
              ..anchor = Anchor.center
              ..size = Vector2(_tileSize, _tileSize)
              ..position = Vector2(left, top)
              ..angle = rotationAngle;
        tile.sprite = tileInfo.sprite;

        tileRow.add(tile);
        add(tile);
        if (tileInfo.type == TileType.grass) {
          _validTowerPositions.add(
            Vector2(tileIndexX.toDouble(), tileIndexY.toDouble()),
          );
        }
      }
      _tiles.add(tileRow);
    }
  }

  void handleTap(int x, int y) {
    final isValidPosition = _validTowerPositions.any(
      (pos) => pos.x == x && pos.y == y,
    );
    final towerPosition = Vector2(x.toDouble(), y.toDouble());
    final left = (x * _tileSize) + (_tileSize / 2);
    final top = (y * _tileSize) + (_tileSize / 2);

    final towerGlobalPosition = Vector2(left, top);

    if (market.pendingTowerItem == null) {
      return;
    }

    if (!isValidPosition) {
      debugPrint('Invalid tower position');
      _showErrorEffect(towerGlobalPosition);
      market.onPlaceCancelled();
      return;
    }
    if (_occupiedTowerPositions.contains(towerPosition)) {
      debugPrint('Tower position already ocuppied');
      _showErrorEffect(towerGlobalPosition);
      market.onPlaceCancelled();
      return;
    }
    // _pendingTowerItem
    final item = market.pendingTowerItem!;
    final towerData = _towers[item.id]!;

    final tower =
        TowerComponent(
            mapPos: towerPosition,
            towerType: item.type.name,
            tier: towerData.tier,
            range: towerData.range,
            damage: towerData.damage,
            attributes: towerData.attributes,
            fireRate: towerData.fireRate,
          )
          ..anchor = Anchor.center
          ..position = towerGlobalPosition
          ..sprite = Sprite(Flame.images.fromCache(towerData.assetPath))
          ..size = Vector2.all(_tileSize);
    add(tower);
    _occupiedTowerPositions.add(towerPosition);
    _showSuccessEffect(towerGlobalPosition);
    market.onItemPlaced();
  }

  Future<void> _showSuccessEffect(Vector2 position) async {
    final effect = CircleComponent(
      radius: 20,
      position: position,
      paint: Paint()..color = const Color(0x7700FF00),
      anchor: Anchor.center,
      priority: 2,
    );

    add(effect);
    await effect.add(
      ScaleEffect.to(
        Vector2.all(1.5),
        EffectController(duration: 0.2, reverseDuration: 0.2, repeatCount: 1),
      ),
    );
    Future.delayed(
      const Duration(milliseconds: 500),
      () => effect.removeFromParent(),
    );
  }

  Future<void> _showErrorEffect(Vector2 position) async {
    final effect = CircleComponent(
      radius: 20,
      position: position,
      paint: Paint()..color = const Color(0x77FF0000),
      anchor: Anchor.center,
      priority: 2,
    );

    add(effect);
    await effect.add(OpacityEffect.to(0, EffectController(duration: 0.3)));
    Future.delayed(
      const Duration(milliseconds: 500),
      () => effect.removeFromParent(),
    );
  }
}
