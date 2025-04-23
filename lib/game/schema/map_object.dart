/// Modelos pro mapa
class MapObject
{
  /// largura em tiles
  final int width;
  /// Altura em tiles
  final int height;
  /// Pontos/caminho
  final List<int> points;

  /// Construtor do objeto
  MapObject(
    {
      required this.width,
      required this.height,
      required this.points
    }
  );
}