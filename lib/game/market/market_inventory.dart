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
      items: [],
    );
  }

  void printItems() {
    for (var item in items) {
      debugPrint('${item.name} - ${item.price} ouro');
    }
  }
}
