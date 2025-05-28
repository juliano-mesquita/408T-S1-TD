import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_towerdefense_game/game/player/inventory/player_inventory.dart';
import 'package:flutter_towerdefense_game/game/player/inventory/player_inventory_item.dart';

void main() {
  group('PlayerInventory', () {
    late PlayerInventory inventory;
    late PlayerInventoryItem item1;
    late PlayerInventoryItem item2;

    setUp(() {
      inventory = PlayerInventory(inventorySize: 2);
      item1 = PlayerInventoryItem(
        id: '1',
        name: 'Item',
        description: 'Item name',
        icon: 'item.png',
      );
      item2 = PlayerInventoryItem(
        id: '2',
        name: 'item2',
        description: 'item2 name',
        icon: 'item2.png',
      );
    });

    test('should add item successfully', () {
      final result = inventory.addItem(item1);
      expect(result, isTrue);
    });

    test('should not add item if inventory is full', () {
      inventory.addItem(item1);
      inventory.addItem(item2);
      final newItem = PlayerInventoryItem(
        id: '3',
        name: 'item3',
        description: 'item3 name',
        icon: 'item3.png',
      );
      final result = inventory.addItem(newItem);
      expect(result, isFalse);
    });

    test('should remove existing item successfully', () {
      inventory.addItem(item1);
      final removed = inventory.removeItem(item1);
      expect(removed, isTrue);
    });

    test('should not remove item that is not in inventory', () {
      final removed = inventory.removeItem(item1);
      expect(removed, isFalse);
    });
  });
}