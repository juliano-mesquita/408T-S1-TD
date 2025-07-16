import 'dart:ui';

import 'package:flutter_towerdefense_game/controller/player_controller.dart';
import 'package:flutter_towerdefense_game/game/player/inventory/player_inventory.dart';
import 'package:flutter_towerdefense_game/game/player/player.dart';
import 'package:flutter_towerdefense_game/game/player/player_wallet.dart';
import 'package:mockito/mockito.dart';

class MockPlayerController extends Mock implements PlayerController {
  @override
  Player get player => super.noSuchMethod(
    Invocation.getter(#player),
    returnValue: Player(
      name: '',
      wallet: PlayerWallet(balance: 0),
      inventory: PlayerInventory(inventorySize: 0),
    ),
  );

  @override
  void addListener(VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]));

  @override
  void removeListener(VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]));

  @override
  int get balance => super.noSuchMethod(
    Invocation.getter(#balance),
    returnValue: 0,
    returnValueForMissingStub: 0,
  );

  @override
  set balance(int value) =>
      super.noSuchMethod(Invocation.setter(#balance, [value]));
}
