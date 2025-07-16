import 'package:flutter/foundation.dart';

enum GameState
{
  mainMenu,
  paused,
  running,
  gameOver,
  victory
}

class GameData
{
  final GameState state;

  GameData(
    {
      required this.state
    }
  );
}

class GameController
{
  final List<VoidCallback> _onStartListeners = [];
  final List<VoidCallback> _onPauseListeners = [];
  final List<VoidCallback> _onResumeListeners = [];
  final List<VoidCallback> _onMainMenuListeners = []; 
  GameData _state;

  GameData get game => _state;
  
  GameController()
  :
    _state = GameData(
      state: GameState.mainMenu
    );

  void start()
  {
    assert(_state.state == GameState.mainMenu, 'Cannot start a game that has already started');
    _state = GameData(state: GameState.running);
    notifyOnStartListeners();
  }

  void pause()
  {
    assert(_state.state == GameState.running, 'Cannot pause a game that is not running');
    _state = GameData(state: GameState.paused);
    notifyOnPauseListeners();
  }

  void resume()
  {
    assert(_state.state == GameState.paused, 'Cannot resume a game that is not paused');
    _state = GameData(state: GameState.running);
    notifyOnResumeListeners();
  }

  void goToMainMenu()
  {
    assert(_state.state != GameState.mainMenu, 'Cannot go to main menu when game is already in main menu');
    _state = GameData(state: GameState.mainMenu);
    notifyOnMainMenuListeners();
  }

//#region Start Listeners

  void addOnStartListener(VoidCallback listener)
  {
    _onStartListeners.add(listener);
  }

  void removeOnStartListener(VoidCallback listener)
  {
    _onStartListeners.remove(listener);
  }

  void notifyOnStartListeners()
  {
    try
    {
      for(final listener in List.unmodifiable(_onStartListeners))
      {
        listener.call();
      }
    }
    catch (exception, stack)
    {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'foundation library',
          context: ErrorDescription('while dispatching notifications for $runtimeType'),
          informationCollector:
              () => <DiagnosticsNode>[
                DiagnosticsProperty<GameController>(
                  'The $runtimeType sending notification was',
                  this,
                  style: DiagnosticsTreeStyle.errorProperty,
                ),
              ],
        ),
      );
    }
  }

//#endregion

//#region Pause Listeners

  void addOnPauseListener(VoidCallback listener)
  {
    _onPauseListeners.add(listener);
  }

  void removeOnPauseListener(VoidCallback listener)
  {
    _onPauseListeners.remove(listener);
  }

  void notifyOnPauseListeners()
  {
    try
    {
      for(final listener in List.unmodifiable(_onPauseListeners))
      {
        listener.call();
      }
    }
    catch (exception, stack)
    {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'foundation library',
          context: ErrorDescription('while dispatching notifications for $runtimeType'),
          informationCollector:
              () => <DiagnosticsNode>[
                DiagnosticsProperty<GameController>(
                  'The $runtimeType sending notification was',
                  this,
                  style: DiagnosticsTreeStyle.errorProperty,
                ),
              ],
        ),
      );
    }
  }

//#endregion

//#region Resume Listeners

  void addOnResumeListener(VoidCallback listener)
  {
    _onResumeListeners.add(listener);
  }

  void removeOnResumeListener(VoidCallback listener)
  {
    _onResumeListeners.remove(listener);
  }

  void notifyOnResumeListeners()
  {
    try
    {
      for(final listener in List.unmodifiable(_onResumeListeners))
      {
        listener.call();
      }
    }
    catch (exception, stack)
    {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'foundation library',
          context: ErrorDescription('while dispatching notifications for $runtimeType'),
          informationCollector:
              () => <DiagnosticsNode>[
                DiagnosticsProperty<GameController>(
                  'The $runtimeType sending notification was',
                  this,
                  style: DiagnosticsTreeStyle.errorProperty,
                ),
              ],
        ),
      );
    }
  }
//#endregion

//#region Resume Listeners

  void addOnMainMenuListener(VoidCallback listener)
  {
    _onMainMenuListeners.add(listener);
  }

  void removeOnMainMenuListener(VoidCallback listener)
  {
    _onMainMenuListeners.remove(listener);
  }

  void notifyOnMainMenuListeners()
  {
    try
    {
      for(final listener in List.unmodifiable(_onMainMenuListeners))
      {
        listener.call();
      }
    }
    catch (exception, stack)
    {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'foundation library',
          context: ErrorDescription('while dispatching notifications for $runtimeType'),
          informationCollector:
              () => <DiagnosticsNode>[
                DiagnosticsProperty<GameController>(
                  'The $runtimeType sending notification was',
                  this,
                  style: DiagnosticsTreeStyle.errorProperty,
                ),
              ],
        ),
      );
    }
  }
//#endregion
}