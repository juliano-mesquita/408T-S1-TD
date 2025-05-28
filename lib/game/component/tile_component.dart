import 'package:flame/components.dart';
import 'package:flame/events.dart';

class TileComponent extends SpriteComponent with TapCallbacks
{
  final int xMap;
  final int yMap;
  final void Function(int x, int y) onTapDownCallback;

  TileComponent(
    {
      required this.xMap,
      required this.yMap,
      required this.onTapDownCallback
    }
  );

  @override
  void onTapDown(TapDownEvent event)
  {
    onTapDownCallback(xMap, yMap);
  }
}