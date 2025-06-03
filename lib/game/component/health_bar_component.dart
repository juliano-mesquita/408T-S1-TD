import 'dart:ui';

import 'package:flame/components.dart';

class HealthBarComponent extends PositionComponent {
  double maxHealth;
  double currentHealth;

  HealthBarComponent({
    required this.maxHealth,
    required this.currentHealth,
  }) : super(size: Vector2(18, 4)); // healthbar size

  @override
  void render(Canvas canvas) {
    // healthbar background color
    final bgPaint = Paint()..color = const Color(0xFFFF0000);
    canvas.drawRect(size.toRect(), bgPaint);

    // healthbar foreground color, proportional to current HP
    final fgPaint = Paint()..color = const Color(0xFF00FF00);
    final width = (currentHealth / maxHealth) * size.x;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, size.y), fgPaint);
  }

  void updateHealth(double newHealth) {
    currentHealth = newHealth;
  }
}