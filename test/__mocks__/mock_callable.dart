
import 'package:mockito/mockito.dart';

class MockCallable extends Mock
{
  dynamic callMethod() => super.noSuchMethod(
    Invocation.method(#call, []),
    returnValue: null,
    returnValueForMissingStub: null
  );
}