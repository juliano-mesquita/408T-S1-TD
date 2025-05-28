import 'market_item_widget.dart';
import 'package:flutter/material.dart';

class MarketComponent extends StatelessWidget {
  final List<MarketItems> items;

  const MarketComponent({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(8),
        color: Colors.black.withOpacity(0.7),
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
}
