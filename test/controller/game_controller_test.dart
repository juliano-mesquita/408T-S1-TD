
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_towerdefense_game/controller/game_controller.dart';
import 'package:mockito/mockito.dart';

import '../__mocks__/mock_callable.dart';

void main()
{
  group(
    'GameController',
    ()
    {
      late GameController gameController;

      setUp(
        ()
        {
          gameController = GameController();
        }
      );

      test(
        'when controller is created it should initalize with main menu state',
        ()
        {
          expect(gameController.game.state, equals(GameState.mainMenu));
        }
      );

      group(
        'when start',
        ()
        {
          test(
            'is called it should notify listeners',
            ()
            {
              final listenerMocked = MockCallable();
              gameController.addOnStartListener(listenerMocked.callMethod);
              verifyNever(listenerMocked.callMethod());
              gameController.start();
              verify(listenerMocked.callMethod()).called(1);
            }
          );

          test(
            'when start called and game has started it should throw assertation error',
            ()
            {
              gameController.start();
              expect(() => gameController.start(), throwsAssertionError);
            }
          );
        }
      );

      group(
        'when pause',
        ()
        {
          test(
            'when pause called it should notify listeners',
            ()
            {
              final listenerMocked = MockCallable();
              gameController.addOnPauseListener(listenerMocked.callMethod);
              gameController.start();
              verifyNever(listenerMocked.callMethod());
              gameController.pause();
              verify(listenerMocked.callMethod()).called(1);
            }
          );

          test(
            'is called and game is not running it should throw assertation error',
            ()
            {
              expect(() => gameController.pause(), throwsAssertionError);
            }
          );
        }
      );

      group(
        'when resume',
        ()
        {
          test(
            'when resume called it should notify listeners',
            ()
            {
              final listenerMocked = MockCallable();
              gameController.addOnResumeListener(listenerMocked.callMethod);
              gameController.start();
              verifyNever(listenerMocked.callMethod());
              gameController.pause();
              verifyNever(listenerMocked.callMethod());
              gameController.resume();
              verify(listenerMocked.callMethod()).called(1);
            }
          );

          test(
            'resume is called and game is not paused it should throw assertation error',
            ()
            {
              expect(() => gameController.resume(), throwsAssertionError);
            }
          );
        }
      );

      group(
        'when main menu',
        ()
        {
          test(
            'is called it should notify listeners',
            ()
            {
              final listenerMocked = MockCallable();
              gameController.addOnMainMenuListener(listenerMocked.callMethod);
              verifyNever(listenerMocked.callMethod());
              gameController.goToMainMenu();
              verify(listenerMocked.callMethod()).called(1);
            }
          );

          test(
            'is and game is on main menu it should throw assertation error',
            ()
            {
              expect(() => gameController.goToMainMenu(), throwsAssertionError);
            }
          );
        }
      );
    }
  );
}