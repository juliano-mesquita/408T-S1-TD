
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter_towerdefense_game/game/component/background_component.dart';
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';

class TowerDefenseGame extends FlameGame
{
  // Instanciando o mapa
  static final _map = MapObject(
    // largura
    width: 6,
    // altura
    height: 3,
    // O mapa em sí. Os pontos contendo o caminho são representados por 1
    points: [
      0, 0, 0, 0, 3, 1,
      0, 3, 1, 1, 2, 0,
      1, 2, 0, 0, 0, 0,
    ]
  );

  @override
  Future<void> onLoad() async
  {
    final backgroundImage = await Flame.images.load('floor/base_grass.png');
    final backgroundSprite = Sprite(backgroundImage);
    await super.onLoad();

    add(
      BackgroundComponent(
        mapObject: _map,
        backgroundImage: backgroundImage
      )
        // ..sprite = backgroundSprite
        // Aonde renderizar relativo a tela(e ao anchor)
        ..position = Vector2(0, 0)
        // Largura do componente de mapa
        ..width = size.x
        // Altura do componente de mapa
        ..height = size.y
        // Anchor/Ancora 
        ..anchor = Anchor.topLeft,
    );
  }
}