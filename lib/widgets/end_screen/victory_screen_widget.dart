import 'package:flutter/material.dart';

class VictoryScreenWidget extends StatelessWidget {
  final VoidCallback onMenuButtonClicked;

  const VictoryScreenWidget({super.key, required this.onMenuButtonClicked });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
    body: SizedBox.expand(
  child: Stack(
    children: [
      Center(child: Image.asset('assets/images/victory1.png')),
      Center(
        child: ElevatedButton(
          onPressed: onMenuButtonClicked,
          child: const Text('Menu Principal'),
        ),
      ),
    ],
  ),
),
    );
  }
}