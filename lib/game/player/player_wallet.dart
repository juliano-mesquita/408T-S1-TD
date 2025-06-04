/// A class that holds information about the player coins
class PlayerWallet {
  int _balance;

  /// Gets the current balance for the player
  int get balance => _balance;

  /// Sets [value] to player balance
  set balance(int value)
  {
    if(value < 0)
    {
      throw ArgumentError.value(value, "the value must not be negative");
    }
    _balance = value;
  }

  /// Creates a [PlayerWallet] object with [balance] in the wallet 
  PlayerWallet({required int balance})
  :
    assert(balance >= 0, 'Initial Balance Must Not Be Negative'),
    _balance = balance;

  /// Checks [balance] has more coins than [price]
  bool enoughCoins(int price) => balance >= price;
}
