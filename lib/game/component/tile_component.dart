import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter_towerdefense_game/models/map/tile_type.dart';

class TileComponent extends SpriteComponent with TapCallbacks
{
  final int xMap;
  final int yMap;
  final void Function(int x, int y) onTapDownCallback;
  final TileType tileType;

  TileComponent(
    {
      required this.xMap,
      required this.yMap,
      required this.onTapDownCallback,
      required this.tileType
    }
  );

  @override
  void onTapDown(TapDownEvent event)
  {
    onTapDownCallback(xMap, yMap);
  }
}