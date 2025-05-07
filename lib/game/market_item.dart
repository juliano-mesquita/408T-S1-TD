import 'dart:convert';
import 'dart:io';

enum MarketItemType {
  tower,
  upgrade,
  resource,
}

class MarketItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final MarketItemType type;
  final String icon;

  MarketItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.icon,
  });

  factory MarketItem.fromJson(Map<String, dynamic> json) {
    return MarketItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      type: MarketItemType.values.firstWhere((e) => e.name == json['type']),
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'type': type.name,
      'icon': icon,
    };
  }

  @override
  String toString() {
    return '$name (${type.name}) - $price moedas';
  }
}

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
    return MarketInventory(items: [
      MarketItem(
          id: 'tower1',
          name: 'Torre Arqueira Indígena',
          description: 'Atira flechas nos inimigos com alta precisão.',
          price: 100,
          type: MarketItemType.tower,
          icon: 'assets/images/floor/tower_arrow.png'),
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
    ]);
  }

  void printItems() {
    for (var item in items) {
      print(item);
    }
  }
}
