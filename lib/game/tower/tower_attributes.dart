class TowerAttributes {
  final double damageModifier;
  final double reachModifier;

  TowerAttributes({required this.damageModifier, required this.reachModifier});
}

enum TowerType
{
  nakedBear,
  indianSpearMale,
  indianTorchFemale,
  indianOca
}