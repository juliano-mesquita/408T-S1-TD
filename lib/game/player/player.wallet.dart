import 'package:flutter/widgets.dart';

class PlayerWallet{

int balance;


PlayerWallet({
  required this.balance

});

void addcoin(int amount){

}

void removecoin (int amount){

}
}
class MyWidget extends StatelessWidget {
  final PlayerWallet wallet;

  MyWidget ({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(wallet.balance.toString()),
    );
  }
}