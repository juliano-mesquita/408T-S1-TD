import 'package:flutter_towerdefense_game/game/player/player_wallet.dart';

class Player
{
  /// The player wallet object holding balance info
  final PlayerWallet wallet;
  /// The player username
  String name;
  int playerLevelHealth;

  Player
  (
    {
      required this.name,
      required this.wallet,
      this.playerLevelHealth = 100
    }
  );

}