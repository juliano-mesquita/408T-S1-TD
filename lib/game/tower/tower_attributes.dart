class TowerAttributes {
  final double damageModifier;
  final double reachModifier;
  final double fireRate;

  TowerAttributes({required this.damageModifier, required this.reachModifier, required this.fireRate,});
}

enum TowerType
{
  nakedBear,
  indianSpearMale,
  indianTorchFemale,
  indianOca
}