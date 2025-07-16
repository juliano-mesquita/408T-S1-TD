import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_towerdefense_game/game/market/market_item.dart';

class MarketInventory {
  final List<MarketItem> items;
  MarketInventory({required this.items});

  factory MarketInventory.fromJsonList(List<dynamic> jsonList) {
    return MarketInventory(
      items: jsonList.map((item) => MarketItem.fromJson(item)).toList(),
    );
  }

  static Future<MarketInventory> loadFromJsonFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw Exception('Arquivo não encontrado: $path');
    }
    final contents = await file.readAsString();
    final jsonData = jsonDecode(contents);
    return MarketInventory.fromJsonList(jsonData);
  }

  static MarketInventory loadStatic() {
    return MarketInventory(
      items: [
        MarketItem(
          id: 'femea1',
          name: 'Indígena Fêmea com Tocha',
          description: 'Queima os inimigos com o elemento do fogo.',
          price: 50,
          type: MarketItemType.tower,
          icon: 'assets/images/indios_garimpeiros/india_um.png',
        ),
        MarketItem(
          id: 'macho2',
          name: 'Indígena Macho com Lança',
          description: 'Poderosa lança confeccionada em pedra maciça.',
          price: 75,
          type: MarketItemType.upgrade,
          icon: 'assets/images/indios_garimpeiros/indio_dois.png',
        ),
        MarketItem(
          id: 'femea2',
          name: 'Indígena Fêmea com Lança',
          description: 'Poderosa lança confeccionada em pedra maciça.',
          price: 100,
          type: MarketItemType.resource,
          icon: 'assets/images/indios_garimpeiros/india_dois.png',
        ),
          MarketItem(
          id: 'macho3',
          name: 'Indígena Macho com  Arco e Flecha',
          description: 'Atira flechas com precisão e a natural habilidade de caçador.',
          price: 150,
          type: MarketItemType.resource,
          icon: 'assets/images/indios_garimpeiros/indio_tres.png',
        ),
  MarketItem(
          id: 'miniindio',
          name: 'Mini Indígena com Cenoura Gigante',
          description: 'Super força com a cenoura gigante como arma.',
          price: 175,
          type: MarketItemType.resource,
          icon: 'assets/images/indios_garimpeiros/mini_indio.png',
        ),
        MarketItem(
          id: 'cacique',
          name: 'Cacique',
          description: 'Dono da Aldeia.',
          price: 300,
          type: MarketItemType.resource,
          icon: 'assets/images/indios_garimpeiros/cacique.png',
        ),
      ],
    );
  }

  void printItems() {
    for (var item in items) {
      debugPrint('${item.name} - ${item.price} ouro');
    }
  }
}
