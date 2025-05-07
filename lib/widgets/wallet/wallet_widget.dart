import 'package:flutter/widgets.dart';
import 'package:flutter_towerdefense_game/game/player/player_wallet.dart';

class PlayerWalletWidget extends StatelessWidget {
  final PlayerWallet wallet;

  PlayerWalletWidget({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(wallet.balance.toString()));
  }
}
