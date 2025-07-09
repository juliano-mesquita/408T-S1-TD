import 'package:flutter_towerdefense_game/controller/market_inventory_controller.dart';
import 'package:flutter_towerdefense_game/controller/player_controller.dart';
import 'package:flutter_towerdefense_game/game/market/market_item.dart';
import 'package:flutter_towerdefense_game/game/player/inventory/player_inventory_item.dart';

class MarketService {
  final MarketInventoryController marketInventoryController;
  final PlayerController playerController;

  MarketItem? _pendingTowerItem;
  MarketItem? get pendingTowerItem => _pendingTowerItem;

  MarketService({
    required this.marketInventoryController,
    required this.playerController
  });

  bool buyItem(MarketItem marketItem) {
    final player = playerController.player;
    if (!player.wallet.enoughCoins(marketItem.price)) {
      return false;
    }
    playerController.balance -= marketItem.price;
    switch (marketItem.type) {
      case MarketItemType.tower:
        _buyTowerCustom(marketItem);
        return true;
      case MarketItemType.upgrade:
        // TODO: Apply upgrade
        return true;
      case MarketItemType.resource:
        player.inventory.addItem(
          PlayerInventoryItem(
            id: marketItem.id,
            name: marketItem.name,
            description: marketItem.description,
            icon: marketItem.icon,
          ),
        );
        return true;
      case MarketItemType.item:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void _buyTowerCustom(MarketItem item)
  {
    _pendingTowerItem = item;
  }

  void onPlaceCancelled()
  {
    if(_pendingTowerItem == null)
    {
      return;
    }
    playerController.balance += _pendingTowerItem!.price;
    _pendingTowerItem = null;
  }

  void onItemPlaced()
  {
    _pendingTowerItem = null;
  }
}
