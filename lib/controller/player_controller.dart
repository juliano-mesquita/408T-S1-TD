import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/game/player/player.dart';
import 'package:flutter_towerdefense_game/provider/player_provider.dart';
import 'package:get_it/get_it.dart';

class PlayerController extends ChangeNotifier
{
  final PlayerProvider _playerProvider = GetIt.I<PlayerProvider>();

  late Player _player;

  /// Gets an object containing the player information
  Player get player => _player;

  int get health => _player.playerLevelHealth;

  set health(int value)
  {
    _player.playerLevelHealth = value;
    notifyListeners();
  } 

  Future<void> init() async
  {
    _player = await _playerProvider.getPlayer();
  }
}