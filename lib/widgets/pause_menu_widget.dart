
import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/controller/game_controller.dart';

class PauseMenuWidget extends StatelessWidget
{
  final GameController gameController;

  const PauseMenuWidget({super.key, required this.gameController});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      backgroundColor: Colors.black.withAlpha(128),
      body: SizedBox.expand
      (
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            ElevatedButton(
              onPressed: gameController.resume,
              child: const Text('Voltar ao Jogo'),
            )
          ],
        ),
      )
    );
  }

}