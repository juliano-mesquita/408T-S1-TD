import 'package:flutter_towerdefense_game/game/market/market_item.dart';

class MarketRepository
{
  Future<List<MarketItem>> getItems()
  {
    return Future.value(
      [
        MarketItem(
          id: 'tower1',
          name: 'Torre Arqueira Indígena',
          description: 'Atira flechas nos inimigos com alta precisão.',
          price: 100,
          type: MarketItemType.tower,
          icon: 'assets/images/market/tower_arrow.png',
        ),
        MarketItem(
          id: 'upgrade1',
          name: 'Flechas de Pedra',
          description: 'Aumenta o dano das torres em 20%.',
          price: 75,
          type: MarketItemType.upgrade,
          icon: 'assets/images/market/upgrade_arrow.png',
        ),
        MarketItem(
          id: 'resource1',
          name: 'Bênção da Floresta',
          description: 'Recupera a vida das torres lentamente.',
          price: 50,
          type: MarketItemType.resource,
          icon: 'assets/images/market/forest_blessing.png',
        ),
      ],
    );
  }
}