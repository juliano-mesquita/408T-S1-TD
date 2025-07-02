
import 'dart:ui';

import 'package:flutter_towerdefense_game/controller/player_controller.dart';
import 'package:flutter_towerdefense_game/game/player/player.dart';
import 'package:flutter_towerdefense_game/game/player/player_wallet.dart';
import 'package:mockito/mockito.dart';

class MockPlayerController extends Mock implements PlayerController
{
  @override
  Player get player => super.noSuchMethod(Invocation.getter(#player), returnValue: Player(name: '', wallet: PlayerWallet(balance: 0)));

  @override
  void addListener(VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(
      #addListener,
      [listener]
    )
  );

  @override
  void removeListener(VoidCallback? listener) => super.noSuchMethod(
    Invocation.method(
      #removeListener,
      [listener]
    )
  );
}