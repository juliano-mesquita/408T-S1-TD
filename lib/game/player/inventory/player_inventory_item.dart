class PlayerInventoryItem
{
  final String id;
  final String name;
  final String description;
  // final MarketItemType type;
  final String icon;

  PlayerInventoryItem(
    {
      required this.id,
      required this.name,
      required this.description,
      required this.icon
    }
  );
}