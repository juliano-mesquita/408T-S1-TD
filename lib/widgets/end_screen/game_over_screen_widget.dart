import 'package:flutter/material.dart';

class GameOverScreenWidget extends StatelessWidget {
    final VoidCallback onMenuButtonClicked;

  const GameOverScreenWidget({super.key, required this.onMenuButtonClicked});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
    body: SizedBox.expand(
  child: Stack(
    children: [
      Center(child: Image.asset('assets/images/gameover1.png')),
      Center(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height*0.2),
            child: ElevatedButton(
            onPressed: onMenuButtonClicked,
            child: const Text('Menu Principal'),
          ),
        )
      ),
    ],
  ),
),
    );
  }
}