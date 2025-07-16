import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/controller/game_controller.dart';
import 'package:flutter_towerdefense_game/controller/level_controller.dart';
import 'package:flutter_towerdefense_game/controller/market_inventory_controller.dart';
import 'package:flutter_towerdefense_game/game/market/market_service.dart';
import 'package:flutter_towerdefense_game/game/market_component.dart';
import 'package:flutter_towerdefense_game/game/market/market_inventory.dart';
import 'package:flutter_towerdefense_game/controller/player_controller.dart';
import 'package:flutter_towerdefense_game/game/tower_defense_game.dart';
import 'package:flutter_towerdefense_game/provider/player_provider.dart';
import 'package:flutter_towerdefense_game/repository/market_repository.dart';
import 'package:flutter_towerdefense_game/repository/player_repository.dart';
import 'package:flutter_towerdefense_game/widgets/end_screen/game_over_screen_widget.dart';
import 'package:flutter_towerdefense_game/widgets/end_screen/victory_screen_widget.dart';
import 'package:flutter_towerdefense_game/widgets/main_menu_widget.dart';
import 'package:flutter_towerdefense_game/widgets/pause_menu_widget.dart';
import 'package:flutter_towerdefense_game/widgets/player_hud_widget.dart';
import 'package:get_it/get_it.dart';

void main() async
{
  await _setupServices();

  final market = MarketInventory.loadStatic();
  debugPrint('--- Mercado Indígena ---');
  market.printItems();
  final game = TowerDefenseGame(
    gameController: GetIt.I<GameController>(),
    levelController: GetIt.I<LevelController>(),
    market: GetIt.I<MarketService>()
  );
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(
          game: game,
          initialActiveOverlays: const ['main_menu'],
          overlayBuilderMap:
          {
            'main_menu': (context, game) => MainMenuWidget(gameController: GetIt.I<GameController>()),
            'pause_menu': (context, game) => PauseMenuWidget(gameController: GetIt.I<GameController>()),
            'Market': (context, towerdefensegame) => MarketComponent(
              marketInventoryController: GetIt.I<MarketInventoryController>(),
              playerController: GetIt.I<PlayerController>(),
              market: GetIt.I<MarketService>(),
            ),
            'player': (context, _)
            {
              return const PlayerHudWidget();
            },
            'victory': (context, _)
            {
              return VictoryScreenWidget(onMenuButtonClicked: (){});
            },
            'gameover': (context, _)
            {
              return GameOverScreenWidget(onMenuButtonClicked: (){});
            }
          },
         )
       )
     )
   );
}


Future<void> _setupServices() async
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

  final gameController = GetIt.I.registerSingleton(GameController());
  GetIt.I.registerSingletonWithDependencies(
    () => LevelController(
      gameController: gameController,
      playerController: GetIt.I<PlayerController>()
    ),
    dependsOn: [PlayerController]
  );

  GetIt.I.registerSingletonWithDependencies(
    () => MarketService(
      marketInventoryController: GetIt.I<MarketInventoryController>(),
      playerController: GetIt.I<PlayerController>(),
    ),
    dependsOn: [MarketInventoryController, PlayerController]
  );
  await GetIt.I.allReady();
}