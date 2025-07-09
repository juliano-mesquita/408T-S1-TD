
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_towerdefense_game/widgets/end_screen/victory_screen_widget.dart';
import 'package:mockito/mockito.dart';

import '../../__mocks__/mock_callable.dart';

void main()
{
  group(
    'VictoryScreenWidget',
    ()
    {
       
      final mockCallable = MockCallable();

      testWidgets(
        'Teste que verifica se o menu foi chamado',
        (tester) async
        {
          await tester.pumpWidget(MaterialApp(home: VictoryScreenWidget(onMenuButtonClicked: mockCallable.callMethod)));
          await tester.tap(find.byKey(const Key('btn.main_menu')));
          verify(mockCallable.callMethod()).called(1);
        }
      );

    }
  );
}