import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/game/market/market_item.dart';

class MarketItemWidget extends StatelessWidget {
  final MarketItem item;
  final bool canAfford;
  final VoidCallback onBuy;

  const MarketItemWidget({
    super.key,
    required this.item,
    required this.canAfford,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: canAfford ? Colors.green.shade100 : Colors.red.shade100,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(item.icon, width: 40, height: 40),
            const SizedBox(height: 4),
            Text(
              item.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                item.description,
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
            Text('Preço: ${item.price}'),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      canAfford
                          ? 'Item comprado com sucesso!'
                          : 'Você não tem ouro suficiente!',
                    ),
                    backgroundColor: canAfford ? Colors.green : Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: canAfford ? Colors.green : Colors.grey,
              ),
              child: const Text('Comprar'),
            ),
          ],
        ),
      ),
    );
  }
}
