import 'package:flutter_towerdefense_game/game/player/inventory/player_inventory.dart';
import 'package:flutter_towerdefense_game/game/player/player_wallet.dart';

class Player
{
  /// The player wallet object holding balance info
  final PlayerWallet wallet;
  /// The player username
  String name;
  int playerLevelHealth;
  final PlayerInventory inventory;

  Player
  (
    {
      required this.name,
      required this.wallet,
      required this.inventory,
      this.playerLevelHealth = 100,
    }
  );

}