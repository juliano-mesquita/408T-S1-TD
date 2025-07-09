import 'package:flutter/material.dart';
import 'package:flutter_towerdefense_game/controller/game_controller.dart';
import 'package:flutter_towerdefense_game/controller/player_controller.dart';
import 'package:flutter_towerdefense_game/game/player/player.dart';
import 'package:get_it/get_it.dart';

/// Shows the player name
class PlayerHudWidget extends StatefulWidget {
  const PlayerHudWidget({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerHudWidgetState();
}

class _PlayerHudWidgetState extends State<PlayerHudWidget> {
  final _playerController = GetIt.I<PlayerController>();
  late Player _player = _playerController.player;
  final GameController _gameController = GetIt.I<GameController>();

  @override
  void initState() {
    _playerController.addListener(_onPlayerChange);
    super.initState();
  }

  @override
  void dispose() {
    _playerController.removeListener(_onPlayerChange);
    super.dispose();
  }

  void _onPlayerChange() {
    setState(() {
      _player = _playerController.player;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${_player.playerLevelHealth}%', style: const TextStyle(color: Colors.red)),
              IconButton(
                icon: const Icon(Icons.pause_rounded),
                onPressed: _gameController.pause,
              ),
            ],
          )
        ),
      ],
    );
  }
}
