import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/game/market/market_inventory.dart';
import 'package:flutter_towerdefense_game/game/tower_defense_game.dart';

void main() {
  final market = MarketInventory.loadStatic();
  debugPrint('--- Mercado Indígena ---');
  market.printItems();
  final game = TowerDefenseGame();
  runApp(GameWidget(game: game));
}
