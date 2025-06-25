import 'package:flutter/material.dart';

class VictoryScreen extends StatelessWidget {
  const VictoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/victory1.png'),
            const SizedBox(height: 20),
            const Text(
              'Você venceu!',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Exemplo: retornar ao menu principal
                Navigator.pushReplacementNamed(context, '/menu');
              },
              child: const Text('Menu Principal'),
            ),
          ],
        ),
      ),
    );
  }
}