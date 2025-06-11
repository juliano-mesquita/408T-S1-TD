import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/game/market/market_inventory.dart';
import 'package:flutter_towerdefense_game/repository/market_repository.dart';

class MarketInventoryController extends ValueNotifier<MarketInventory?>
{
  final MarketRepository _marketRepository;

  MarketInventoryController(
    {
      required MarketRepository marketRepository
    }
  )
    :
      _marketRepository = marketRepository,
      super(null);

  Future<void> init() async
  {
    final items = await _marketRepository.getItems();
    value = MarketInventory(items: items);
  }

}