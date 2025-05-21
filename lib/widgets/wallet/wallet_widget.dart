import 'package:flutter/widgets.dart';
import 'package:flutter_towerdefense_game/game/player/player_wallet.dart';

class PlayerWalletWidget extends StatelessWidget {
  final PlayerWallet wallet;

  const PlayerWalletWidget({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: Text(wallet.balance.toString()));
  }
}
