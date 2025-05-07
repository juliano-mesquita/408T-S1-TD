import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/game/tower_defense_game.dart';

void main()
{
  final game = TowerDefenseGame();
  runApp(GameWidget(game: game));
}
