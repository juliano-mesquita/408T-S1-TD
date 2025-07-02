import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_towerdefense_game/game/player/player_wallet.dart';

void main() {
  group('PlayerWallet', () {
    late PlayerWallet playerWallet;
    // Reset player wallet time every time
    setUp(() {
      playerWallet = PlayerWallet(balance: 0);
    });

    group('Constructor', () {
      test('instantiating object should set initial balance correctly', () {
        final wallet = PlayerWallet(balance: 10);
        expect(wallet.balance, equals(10));
      });

      test(
        'instantiating object should not allow for negative values in the balance',
        () {
          expect(() => PlayerWallet(balance: -10), throwsAssertionError);
        },
      );
    });

    group('Set values with =', () {
      test('should not accept negative values', () {
        expect(() => playerWallet.balance = -10, throwsArgumentError);
      });

      test('should accept positve values', () {
        playerWallet.balance = 10;
        expect(playerWallet.balance, equals(10));
      });
    });

    group('using = and operators (+=, -=, etc.)', () {
      test('should increase values when using +=', () {
        playerWallet.balance += 10;
        expect(playerWallet.balance, equals(10));
      });

      test('should decrease values when using -=', () {
        playerWallet.balance = 100;
        playerWallet.balance -= 10;
        expect(playerWallet.balance, equals(90));
      });

      test('should not accept negative values after applying -=', () {
        expect(() => playerWallet.balance -= 10, throwsArgumentError);
      });
    });
  });

  group('PlayerWallet - enoughCoins()', () {
    test(
      'should return true when balance is equal to or greater than price',
      () {
        final wallet = PlayerWallet(balance: 100);
        expect(wallet.enoughCoins(100), isTrue);
        expect(wallet.enoughCoins(50), isTrue);
      },
    );

    test('should return false when balance is less than price', () {
      final wallet = PlayerWallet(balance: 100);
      expect(wallet.enoughCoins(101), isFalse);
    });
  });
}
