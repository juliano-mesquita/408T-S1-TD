
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
      body: SizedBox.expand
      (
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            ElevatedButton(
              onPressed: gameController.start,
              child: const Text('Iniciar Jogo'),
            )
          ],
        ),
      )
    );
  }

}