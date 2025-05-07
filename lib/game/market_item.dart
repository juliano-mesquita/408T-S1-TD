enum MarketItemType { tower, upgrade, resource }

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
