import 'package:flutter_towerdefense_game/game/market_inventory.dart';

void main() async {
  final market = MarketInventory.loadStatic();
  print('--- Mercado Indígena ---');
  market.printItems();
}
