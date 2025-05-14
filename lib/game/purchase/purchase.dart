class PlayerWallet {
  int balance;

  PlayerWallet({required this.balance});

  bool enoughCoins(int price) => balance >= price;
  
  void spendCoins(int price) {
    if (enoughCoins(price)) {
      balance -= price;
    }
  }
}

class Invetory {
  List<String> items = [];
  void addItems(String item) {
    items.add(item);
  }
}

void buyTower(PlayerWallet wallet, Invetory invetory, String item, int price) {
  if (wallet.enoughCoins(price)) {
    wallet.spendCoins(price);
    invetory.addItems(item);
  } else {}
}
