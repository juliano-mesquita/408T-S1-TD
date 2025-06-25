import 'package:flutter/material.dart';

class DefeatScreen extends StatelessWidget {
  const DefeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/gameover1.png'),
            const SizedBox(height: 20),
            const Text(
              'Você foi derrotado!',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Exemplo: reiniciar o jogo ou voltar ao menu
                Navigator.pushReplacementNamed(context, '/menu');
              },
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }
}