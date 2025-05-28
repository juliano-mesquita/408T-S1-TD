
import 'package:flutter_towerdefense_game/game/market/market_inventory.dart';
import 'package:flutter_towerdefense_game/game/market/market_item.dart';
import 'package:flutter_towerdefense_game/game/player/inventory/player_inventory.dart';
import 'package:flutter_towerdefense_game/game/player/inventory/player_inventory_item.dart';
import 'package:flutter_towerdefense_game/game/player/player_wallet.dart';

class Market
{
  final MarketInventory marketInventory;
  final PlayerWallet playerWallet;
  final PlayerInventory playerInvetory;

  Market(
    {
      required this.marketInventory,
      required this.playerWallet,
      required this.playerInvetory
    }
  );

  void buyItem(MarketItem marketItem)
  {
    if(!playerWallet.enoughCoins(marketItem.price))
    {
      return;
    }
    playerWallet.balance -= marketItem.price;
    switch(marketItem.type)
    {
      case MarketItemType.tower:
        _buyTowerCustom();
        break;
      case MarketItemType.upgrade:
        // TODO: Apply upgrade
      case MarketItemType.resource:
        playerInvetory.addItem(
          PlayerInventoryItem(
            id: marketItem.id,
            name: marketItem.name,
            description: marketItem.description,
            icon: marketItem.icon
          )
        );
      break;
      case MarketItemType.item:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void _buyTowerCustom()
  {
    // TODO: Add tower to the map
  }
}