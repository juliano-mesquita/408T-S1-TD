import 'package:flutter_towerdefense_game/controller/market_inventory_controller.dart';
import 'package:flutter_towerdefense_game/controller/player_controller.dart';
import 'package:flutter_towerdefense_game/game/market/market_service.dart';
import 'market_item_widget.dart';
import 'package:flutter/material.dart';

class MarketComponent extends StatefulWidget {
  final MarketInventoryController marketInventoryController;
  final PlayerController playerController;
  final MarketService market;

  const MarketComponent({
    super.key,
    required this.marketInventoryController,
    required this.playerController,
    required this.market
  });

  @override
  State<StatefulWidget> createState() => _MarketComponentState();
}

class _MarketComponentState extends State<MarketComponent> {
  late int _playerBalance = widget.playerController.player.wallet.balance;

  @override
  void initState() {
    super.initState();
    widget.playerController.addListener(_onPlayerUpdate);
  }

  @override
  void dispose() {
    widget.playerController.removeListener(_onPlayerUpdate);
    super.dispose();
  }

  void _onPlayerUpdate() {
    final player = widget.playerController.player;
    if (player.wallet.balance == _playerBalance) {
      return;
    }
    setState(() {
      _playerBalance = player.wallet.balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.marketInventoryController,
      builder: (context, value, child) {
        final items = value?.items ?? [];
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
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return MarketItemWidget(
                        item: items[index],
                        canAfford: _playerBalance >= items[index].price,
                        onBuy: () {
                          widget.market.buyItem(item);
                        },
                      );
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
                    Text(
                      '$_playerBalance',
                      key: const Key('info.user.balance'),
                      style: const TextStyle(color: Colors.green, fontSize: 35),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
