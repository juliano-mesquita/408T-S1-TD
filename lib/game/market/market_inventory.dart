import 'dart:convert';
import 'dart:io';
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
          id: 'tower1',
          name: 'Torre Arqueira Indígena',
          description: 'Atira flechas nos inimigos com alta precisão.',
          price: 100,
          type: MarketItemType.tower,
          icon: 'assets/images/floor/tower_arrow.png',
        ),
        MarketItem(
          id: 'upgrade1',
          name: 'Flechas de Pedra',
          description: 'Aumenta o dano das torres em 20%.',
          price: 75,
          type: MarketItemType.upgrade,
          icon: 'assets/images/floor/upgrade_arrow.png',
        ),
        MarketItem(
          id: 'resource1',
          name: 'Bênção da Floresta',
          description: 'Recupera a vida das torres lentamente.',
          price: 50,
          type: MarketItemType.resource,
          icon: 'assets/images/floor/forest_blessing.png',
        ),
      ],
    );
  }

  void printItems() {
    for (var item in items) {
      print(item);
    }
  }
}
