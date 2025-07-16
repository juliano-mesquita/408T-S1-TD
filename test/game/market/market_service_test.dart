import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_towerdefense_game/controller/player_controller.dart';
import 'package:flutter_towerdefense_game/game/market/market_service.dart';
import 'package:flutter_towerdefense_game/game/market/market_item.dart';
import 'package:flutter_towerdefense_game/game/player/player.dart';
import 'package:flutter_towerdefense_game/game/player/player_wallet.dart';
import 'package:flutter_towerdefense_game/game/player/inventory/player_inventory.dart';
import 'package:mockito/mockito.dart';

import '../../__mocks__/mock_market_inventory_controller.dart';
import '../../__mocks__/mock_player_controller.dart';

void main() {
  group('MarketService.buyItem()', () {
    late MarketService market;
    late PlayerWallet wallet;
    late PlayerInventory inventory;

    late MockMarketInventoryController marketInventoryController;
    late PlayerController playerController;

    setUp(() {
      marketInventoryController = MockMarketInventoryController();
      playerController = MockPlayerController();

      wallet = PlayerWallet(balance: 100);
      inventory = PlayerInventory(inventorySize: 5);
      market = MarketService(
        playerController: playerController,
        marketInventoryController: marketInventoryController,
      );

      when(playerController.player).thenReturn(
        Player(name: 'example', wallet: wallet, inventory: inventory),
      );
    });

    test('should not buy item if balance is insufficient', () {
      final item = MarketItem(
        id: '1',
        name: 'item',
        description: 'item',
        price: 200,
        type: MarketItemType.resource,
        icon: 'item.png',
      );

      market.buyItem(item);
      expect(wallet.balance, equals(100));
    });

    test('should buy resource item and deduct coins', () {
      final item = MarketItem(
        id: '2',
        name: 'item',
        description: 'item description',
        price: 40,
        type: MarketItemType.resource,
        icon: 'item.png',
      );

      market.buyItem(item);
      expect(wallet.balance, equals(60));
    });

    test('should treat upgrade item as resource for now', () {
      final item = MarketItem(
        id: '1',
        name: 'item',
        description: 'item description',
        price: 20,
        type: MarketItemType.upgrade,
        icon: 'item.png',
      );

      market.buyItem(item);
      expect(wallet.balance, equals(80));
    });
  });
}
