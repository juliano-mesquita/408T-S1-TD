
import 'package:flutter_towerdefense_game/game/player/player.dart';
import 'package:flutter_towerdefense_game/repository/player_repository.dart';
import 'package:get_it/get_it.dart';

/// The player provider is responsible for unifying
/// DAOs/Entities into usable data for our views
/// 
/// Different tables will be mapped into one or more objects
class PlayerProvider
{
  final _playerRepository = GetIt.I<PlayerRepository>();
  
  /// Gets a player object with data from the repository
  Future<Player> getPlayer() async
  {
    final wallet = await _playerRepository.getWallet();
    final name = await _playerRepository.getPlayerName();
    return Player(name: name, wallet: wallet);
  }

  /// Sets the player [name]
  Future<void> setPlayerName(String name) async
  {
    _playerRepository.setPlayerName(name);
  }
}