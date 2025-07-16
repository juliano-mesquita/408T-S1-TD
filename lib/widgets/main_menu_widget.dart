
import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/controller/game_controller.dart';

class MainMenuWidget extends StatelessWidget
{
  final GameController gameController;

  const MainMenuWidget({super.key, required this.gameController});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Container(
              color: const Color(0xFF22B14C),
              child: Center(
                child: Image.asset(
                  'assets/images/startscreen.png',
                  fit: BoxFit.contain,
                ),
              )
            ),
            Center(
                child: ElevatedButton(
              onPressed: gameController.start,
              child: const Text('Iniciar Jogo'),
            )
            )
          ],
        ),
      )
    );
  }

}