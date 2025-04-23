import 'package:flame/game.dart';
import 'package:flutter/material.dart';


void main()
{
  final game = TowerDefenseGame();
  runApp(GameWidget(game: game));
}