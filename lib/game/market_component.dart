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
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: item.length,
          itemBuilder: (context, index) {
            return MarketItemWidget(item: item[index]);
          },
        ),
      ),
    );
  }
}
