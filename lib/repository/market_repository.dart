import 'package:flutter_towerdefense_game/game/market/market_item.dart';

class MarketRepository
{
  Future<List<MarketItem>> getItems()
  {
    return Future.value(
      [
        MarketItem(
          id: 'femea1',
          name: 'Fêmea com Tocha',
          description: 'Queima os inimigos com o elemento do fogo.',
          price: 50,
          type: MarketItemType.tower,
          icon: 'assets/images/indios_garimpeiros/india_um.png',
        ),
        MarketItem(
          id: 'macho2',
          name: 'Macho com Lança',
          description: 'Poderosa lança confeccionada em pedra maciça.',
          price: 75,
          type: MarketItemType.tower,
          icon: 'assets/images/indios_garimpeiros/indio_dois.png',
        ),
        MarketItem(
          id: 'femea2',
          name: 'Fêmea com Lança',
          description: 'Poderosa lança confeccionada em pedra maciça.',
          price: 100,
          type: MarketItemType.tower,
          icon: 'assets/images/indios_garimpeiros/india_dois.png',
        ),
          MarketItem(
          id: 'macho3',
          name: 'Arco e Flecha',
          description: 'Atira flechas com precisão e a natural habilidade de caçador.',
          price: 150,
          type: MarketItemType.tower,
          icon: 'assets/images/indios_garimpeiros/indio_tres.png',
        ),
          MarketItem(
          id: 'miniindio',
          name: 'Mini Indígena',
          description: 'Super força com a cenoura gigante como arma.',
          price: 175,
          type: MarketItemType.tower,
          icon: 'assets/images/indios_garimpeiros/mini_indio.png',
        ),
        MarketItem(
          id: 'cacique',
          name: 'Cacique',
          description: 'Dono da Aldeia.',
          price: 300,
          type: MarketItemType.tower,
          icon: 'assets/images/indios_garimpeiros/cacique.png',
        ),
      ],
    );
  }
}