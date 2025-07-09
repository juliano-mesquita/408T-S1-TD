import 'package:flutter_towerdefense_game/game/market/market_inventory.dart';
import 'package:flutter_towerdefense_game/game/market/market_item.dart';
import 'package:flutter_towerdefense_game/game/player/inventory/player_inventory.dart';
import 'package:flutter_towerdefense_game/game/player/inventory/player_inventory_item.dart';
import 'package:flutter_towerdefense_game/game/player/player_wallet.dart';

class Market {
  final MarketInventory marketInventory;
  final PlayerWallet playerWallet;
  final PlayerInventory playerInvetory;

  MarketItem? _pendingTowerItem;
  MarketItem? get pendingTowerItem => _pendingTowerItem;

  Market({
    required this.marketInventory,
    required this.playerWallet,
    required this.playerInvetory,
  });

  bool buyItem(MarketItem marketItem) {
    if (!playerWallet.enoughCoins(marketItem.price)) {
      return false;
    }
    playerWallet.balance -= marketItem.price;
    switch (marketItem.type) {
      case MarketItemType.tower:
        _buyTowerCustom(marketItem);
        return true;
      case MarketItemType.upgrade:
        // TODO: Apply upgrade
        return true;
      case MarketItemType.resource:
        playerInvetory.addItem(
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
    if(_pendingTowerItem != null)
    {
      return;
    }
    playerWallet.balance += _pendingTowerItem!.price;
    _pendingTowerItem = null;
  }

  void onItemPlaced()
  {
    _pendingTowerItem = null;
  }
}
