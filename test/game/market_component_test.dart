import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_towerdefense_game/game/market/market_service.dart';
import 'package:flutter_towerdefense_game/game/market_component.dart';
import 'package:flutter_towerdefense_game/game/player/inventory/player_inventory.dart';
import 'package:flutter_towerdefense_game/game/player/player.dart';
import 'package:flutter_towerdefense_game/game/player/player_wallet.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import '../__mocks__/mock_market_inventory_controller.dart';
import '../__mocks__/mock_player_controller.dart';

void main() {
  group('Market Balance Display', () {
    const playerBalance = 100;

    late MockMarketInventoryController marketInventoryController;
    late MockPlayerController playerController;
    late MarketService marketService;

    setUp(() {
      marketInventoryController = MockMarketInventoryController();
      playerController = MockPlayerController();

      marketService = MarketService(
        marketInventoryController: marketInventoryController,
        playerController: playerController,
      );

      when(playerController.player).thenReturn(
        Player(
          name: 'example',
          wallet: PlayerWallet(balance: playerBalance),
          inventory: PlayerInventory(inventorySize: 2),
        ),
      );
    });

    testWidgets('should display the correct balance in the Text widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            width: 1920,
            height: 1080,
            child: MarketComponent(
              marketInventoryController: marketInventoryController,
              playerController: playerController,
              market: marketService,
            ),
          ),
        ),
      );

      // Find the Text widget by its key
      final balanceTextFinder = find.byKey(const Key('info.user.balance'));

      // Check that the Text widget is found
      expect(balanceTextFinder, findsOneWidget);

      // Get the Text widget and check the displayed value
      final Text textWidget = tester.widget(balanceTextFinder);
      expect(textWidget.data, '$playerBalance');
    });
  });
}
