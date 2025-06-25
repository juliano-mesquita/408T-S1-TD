import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/controller/market_inventory_controller.dart';
import 'package:flutter_towerdefense_game/game/market_component.dart';
import 'package:flutter_towerdefense_game/game/market/market_inventory.dart';
import 'package:flutter_towerdefense_game/controller/player_controller.dart';
import 'package:flutter_towerdefense_game/game/tower_defense_game.dart';
import 'package:flutter_towerdefense_game/provider/player_provider.dart';
import 'package:flutter_towerdefense_game/repository/market_repository.dart';
import 'package:flutter_towerdefense_game/repository/player_repository.dart';
import 'package:flutter_towerdefense_game/widgets/player_hud_widget.dart';
import 'package:get_it/get_it.dart';

void main() async
{
  _setupServices();

  final market = MarketInventory.loadStatic();
  debugPrint('--- Mercado Indígena ---');
  market.printItems();
  final game = TowerDefenseGame();
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(
          game: game,
          initialActiveOverlays: const ['player', 'Market'],
          overlayBuilderMap:
          {
            'Market': (context, towerdefensegame) => MarketComponent(
              marketInventoryController: GetIt.I<MarketInventoryController>(),
              playerController: GetIt.I<PlayerController>()
            ),
            'player': (context, _)
            {
              return const PlayerHudWidget();
            }
          },
        )
      )
    )
  );
}


void _setupServices()
{
  GetIt.I.registerSingleton(PlayerRepository());
  GetIt.I.registerSingleton(PlayerProvider());
  GetIt.I.registerSingletonAsync(
    () async
    {
      final controller = PlayerController();
      await controller.init();
      return controller;
    }
  );

  final marketRepository = GetIt.I.registerSingleton(MarketRepository());
  GetIt.I.registerSingletonAsync(
    () async
    {
      final controller = MarketInventoryController(marketRepository: marketRepository);
      await controller.init();
      return controller;
    }
  );
}