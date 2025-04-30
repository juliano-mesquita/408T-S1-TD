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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(PlayerWallet.toString()),
    );
  }
}