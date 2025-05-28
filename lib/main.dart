import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/controller/player_controller.dart';
import 'package:flutter_towerdefense_game/game/market_inventory.dart';
import 'package:flutter_towerdefense_game/game/player/player.dart';
import 'package:flutter_towerdefense_game/game/tower_defense_game.dart';
import 'package:flutter_towerdefense_game/provider/player_provider.dart';
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
    GameWidget(
      game: game,
      initialActiveOverlays: const ['player'],
      overlayBuilderMap:
      {
        'player': (context, _)
        {
          return const PlayerHudWidget();
        }
      },
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
}