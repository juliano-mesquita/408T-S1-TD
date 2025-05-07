class PlayerWallet {
  int balance;

  PlayerWallet({required this.balance});

  bool EnoughCoins(int price) => balance >= price;
  void spendCoins(int price) {
    if (EnoughCoins(price)) {
      balance -= price;
    }
  }
}

class Invetory {
  List<String> towers = [];
  void addTower(String tower) {
    towers.add(tower);
  }
}

void buyTower(PlayerWallet wallet, Invetory invetory, String tower, int price) {
  if (wallet.EnoughCoins(price)) {
    wallet.spendCoins(price);
    invetory.addTower(tower);
  } else {}
}
