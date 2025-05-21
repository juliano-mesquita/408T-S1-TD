import 'package:flutter_towerdefense_game/game/player/inventory/player_inventory_item.dart';

class PlayerInventory
{
  final List<PlayerInventoryItem> _inventory = [];

  final int inventorySize;

  PlayerInventory(
    {
      required this.inventorySize
    }
  );

  bool addItem(PlayerInventoryItem item)
  {
    if(_inventory.length >= inventorySize)
    {
      return false;
    }
    _inventory.add(item);
    return true;
  }

  bool removeItem(PlayerInventoryItem item)
  {
    return _inventory.remove(item);
  }
}