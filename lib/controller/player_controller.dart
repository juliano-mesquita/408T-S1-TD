
import 'dart:async';
import 'dart:math';

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

  // Only for example purposes
  final Random _random = Random();
  final int _randomMax = 122;
  final int _randomMin = 65;

  Future<void> init() async
  {
    _player = await _playerProvider.getPlayer();
    // Generate a random name every 5 seconds.
    // This is only for example purposes. Will change in the future.
    Timer.periodic(
      const Duration(seconds: 5),
      (timer)
      {
        _player.name = List.generate(10, (_) => String.fromCharCode(_random.nextInt(_randomMax - _randomMin) + _randomMin)).join('');
        notifyListeners();
      }
    );
  }
}