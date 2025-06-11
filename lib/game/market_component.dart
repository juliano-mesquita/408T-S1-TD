import 'package:flutter_towerdefense_game/game/market/market_item.dart';

import 'market_item_widget.dart';
import 'package:flutter/material.dart';

class MarketComponent extends StatelessWidget {
  final List<MarketItem> item;

  const MarketComponent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 225,
        padding: const EdgeInsets.all(8),
        color: Colors.black.withValues(),
        child: Row(
          children: [
            Flexible(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: item.length,
                itemBuilder: (context, index) {
                  return MarketItemWidget(item: item[index]);
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/espelho_dindin.png',
                  width: 60.0,
                  height: 60.0,
                ),
                const SizedBox(width: 3.0),
                Text('${0}', style: const TextStyle(color: Colors.green, fontSize: 35)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
