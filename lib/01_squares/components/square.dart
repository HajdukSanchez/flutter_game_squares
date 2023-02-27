import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

/// Square component represent the square render on the screen with
/// velocity, size and color
class Square extends PositionComponent {
  // Default velocity of the component
  late Vector2 _defaultVelocity;
  // Default size of the component
  late double _defaultSquareSize;
  // Default painting color of the component
  late Paint _defaultColor;

  /// Constructor
  Square({
    this.velocity,
    this.squareSize,
    this.color,
  });

  /// Square velocity
  final Vector2? velocity;

  /// Square size
  final double? squareSize;

  /// Square color
  final Paint? color;

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    // Set default values
    _defaultVelocity = velocity ?? Vector2(0, 0).normalized() * 25;
    _defaultSquareSize = squareSize ?? 128.0;
    _defaultColor = color ?? BasicPalette.white.paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Size of the square
    size.setValues(_defaultSquareSize, _defaultSquareSize);
    // Logical center of square
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Position of the square each frame
    position += _defaultVelocity * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw rectangle each frame with his current size and color
    canvas.drawRect(size.toRect(), _defaultColor);
  }
}