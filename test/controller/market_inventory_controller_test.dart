import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_towerdefense_game/controller/market_inventory_controller.dart';
import 'package:flutter_towerdefense_game/game/market/market_item.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

// @GenerateNiceMocks([MockSpec<MarketRepository>()])
import '../__mocks__/mock_callable.dart';
import '__mocks__/mock_market_repository.dart';

void main()
{
  group(
    'MarketInventoryController',
    ()
    {
      final mockCallable = MockCallable();
      final mockMarketRepository = MockMarketRepository();
      late MarketInventoryController marketInventoryController;

      final itemList = [
        MarketItem(
          id: 'tower1',
          name: 'Torre Arqueira Indígena',
          description: 'Atira flechas nos inimigos com alta precisão.',
          price: 100,
          type: MarketItemType.tower,
          icon: 'assets/images/market/tower_arrow.png',
        )
      ];

      setUp(
        ()
        {
          reset(mockMarketRepository);
          reset(mockCallable);
          GetIt.I.registerSingleton(mockMarketRepository);

          when(mockMarketRepository.getItems()).thenAnswer(
            (_) => Future.value(itemList)
          );

          marketInventoryController = MarketInventoryController(marketRepository: mockMarketRepository);
        }
      );

      tearDown(
        ()
        {
          GetIt.I.releaseInstance(mockMarketRepository);
        }
      );

      test(
        'ON init SHOULD call repository.getItems',
        () async
        {
          verifyNever(mockMarketRepository.getItems());
          await marketInventoryController.init();
          verify(mockMarketRepository.getItems()).called(1);
        }
      );

      test(
        'ON init SHOULD update value with repository item list',
        () async
        {
          await marketInventoryController.init();
          expect(marketInventoryController.value?.items, containsAllInOrder(itemList));
        }
      );

      test(
        'ON init SHOULD call listeners',
        () async
        {
          marketInventoryController.addListener(mockCallable.callMethod);
          await marketInventoryController.init();
          await untilCalled(mockCallable.callMethod());
          verify(mockCallable.callMethod()).called(1);
        },
      );
    }
  );
}