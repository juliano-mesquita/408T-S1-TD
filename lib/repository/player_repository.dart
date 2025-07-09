
import 'package:flutter_towerdefense_game/game/player/player_wallet.dart';

/// The repository layer is responsible for persisting data.
/// 
/// Data can be saved in local databases(SQLite, JSON Files, etc)
/// or remote ones using HTTP calls(or any other remote call pattern)
class PlayerRepository
{
  /// Hardcoded object for example purposes
  PlayerWallet _playerWallet = PlayerWallet(balance: 11111);
  /// Hardcoded object for example purposes
  String _name = 'Default';

  Future<void> setPlayerName(String name)
  {
    //TODO: implement persistence
    _name = name;
    return Future.value();
  }

  Future<String> getPlayerName()
  {
    //TODO: implement persistence
    return Future.value(_name);
  }

  Future<void> saveWallet(PlayerWallet playerWallet)
  {
    // UPDATE wallet SET balance = 123;
    //TODO: implement persistence
    _playerWallet = playerWallet;
    return Future.value();
  }

  Future<PlayerWallet> getWallet()
  {
    // SELECT balance from wallet where;
    //TODO: implement persistence
    return Future.value(_playerWallet);
  }
}