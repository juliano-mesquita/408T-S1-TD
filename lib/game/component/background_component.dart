
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_towerdefense_game/game/schema/map_object.dart';

class BackgroundComponent extends PositionComponent
{
  // Tinta pra renderizar o rect 1
  static final _paint = Paint()..color = Colors.white;
  // Tinta pra renderizar o rect 2
  static final _paint2 = Paint()..color = Colors.red;

  // Objeto contendo informações do mapa(largura em tiles, altura em tiles, etc.)
  final MapObject mapObject;
  final Image backgroundImage;

  /// Construtor com parâmetros nomeado
  BackgroundComponent(
    {
      required this.mapObject,
      required this.backgroundImage
    }
  );

  @override
  void render(Canvas canvas)
  {
    // Calculo para tamanho da tile em pixels
    final tileX = size.x/mapObject.width;
    // Renderiza o chessboard
    for(int tileIndexX = 0; tileIndexX < mapObject.width; tileIndexX++)
    {
      for(int tileIndexY = 0; tileIndexY < mapObject.height; tileIndexY++)
      {
        // canvas.drawImage(backgroundImage, Offset.zero, Paint());
        // x, x + tileX
        canvas.drawRect(
          Rect.fromLTWH(
              // Calcula a posição x
              (tileIndexX*tileX),
              // calcula a posição y
              (tileIndexY*tileX),
              tileX, tileX
            ),
            // Definir a cor
            (tileIndexX + tileIndexY) % 2 == 0 ? _paint : _paint2
        );
      }
    }
    
  }
}