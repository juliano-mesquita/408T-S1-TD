import 'package:flutter_towerdefense_game/controller/market_inventory_controller.dart';
import 'package:flutter_towerdefense_game/game/market/market_item.dart';

import 'market_item_widget.dart';
import 'package:flutter/material.dart';

class MarketComponent extends StatelessWidget
{
  final MarketInventoryController marketInventoryController;
  const MarketComponent({super.key, required this.marketInventoryController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: marketInventoryController,
      builder: (context, value, child)
      {
        final items = value?.items ?? [];
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 225,
            padding: const EdgeInsets.all(8),
            color: Colors.black.withValues(),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return MarketItemWidget(item: items[index]);
              },
            ),
          ),
        );
      }
    );
  }
}
