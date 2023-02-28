import 'dart:math';

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
  // Default rotation speed of the square angle
  late double _defaultRotationSpeed;
  // Default life bar of the Square
  late List<RectangleComponent> _defaultLifeBar;

  /// Constructor
  Square({
    this.velocity,
    this.squareSize,
    this.color,
    this.rotationSpeed,
    this.lifeBar,
  });

  /// Square velocity
  final Vector2? velocity;

  /// Square size
  final double? squareSize;

  /// Square color
  final Paint? color;

  /// Square speed of rotation
  final double? rotationSpeed;

  /// Square life bar
  final List<RectangleComponent>? lifeBar;

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    // Set default values
    _defaultVelocity = velocity ?? Vector2(0, 0).normalized() * 25;
    _defaultSquareSize = squareSize ?? 128.0;
    _defaultColor = color ?? BasicPalette.white.paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    _defaultRotationSpeed = rotationSpeed ?? 0.3;
    // Initialize some components to avoid exceptions at the beginning
    _defaultLifeBar = lifeBar ??
        List<RectangleComponent>.filled(
          3,
          growable: false,
          RectangleComponent(size: Vector2(1, 1)),
        );

    // Size of the square
    size.setValues(_defaultSquareSize, _defaultSquareSize);
    // Logical center of square
    anchor = Anchor.center;
    // Add the life bar to the square
    _createLifeBar();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Position of the square each frame
    position += _defaultVelocity * dt;
    // Angel of the Square
    var angleDelta = dt * _defaultRotationSpeed;
    angle = (angle + angleDelta) % (2 * pi);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw rectangle each frame with his current size and color
    canvas.drawRect(size.toRect(), _defaultColor);
  }

  // Creates a life bar for the square and add it into the component
  void _createLifeBar() {
    var lifeBarSize = Vector2(40, 10);
    var lifeBarPosition = Vector2(size.x - lifeBarSize.x, -lifeBarSize.y - 2);
    var backgroundFillColor = Paint()
      ..color = Colors.grey.withOpacity(0.35)
      ..style = PaintingStyle.fill;
    var outlineColor = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;
    var lifeDangerColor = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Create the life bar using pilled rectangle blocks
    _defaultLifeBar = [
      // Outline box color
      RectangleComponent(
        position: lifeBarPosition,
        size: lifeBarSize,
        angle: 0,
        paint: outlineColor,
      ),
      // Filled background color
      RectangleComponent(
        position: lifeBarPosition,
        size: lifeBarSize,
        angle: 0,
        paint: backgroundFillColor,
      ),
      // Life color (with a minimum size)
      RectangleComponent(
        position: lifeBarPosition,
        size: Vector2(10, 10),
        angle: 0,
        paint: lifeDangerColor,
      ),
    ];

    // Add boxes
    addAll(_defaultLifeBar);
  }
}
