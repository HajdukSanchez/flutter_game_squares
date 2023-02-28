import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '/01_squares/game/square_game.dart';

/// Life bar with health of danger, to add in multiple components of the game
class LifeBar extends PositionComponent with HasGameRef<SquareGame> {
  // Life of the Life Bar
  late double _defaultCurrentLife;
  // Height of the life bar
  double lifeBarHeight = 10;

  /// Constructor
  LifeBar({
    required this.parentSize,
    this.currentLife,
    this.redZoneLife = 25,
    this.dangerColor = Colors.red,
    this.healthyColor = Colors.green,
  });

  /// Size of the parent to handle vector position
  final Vector2 parentSize;

  /// Life when Box turns to red
  final double? currentLife;

  /// Minimum life when box turns Danger from health
  final double redZoneLife;

  /// Color when life bar is in danger
  final Color dangerColor;

  /// Color when life bar is healthy
  final Color healthyColor;

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    // Set current life by default or a random value from 0 - 100
    _defaultCurrentLife =
        currentLife ?? Random().nextInt(parentSize.x.round()).toDouble() + 1;
    _createLifeBar();
  }

  // Creates a life bar for the square and add it into the component
  void _createLifeBar() {
    var lifeBarSize = Vector2(parentSize.x, lifeBarHeight);
    var lifeBarPosition =
        Vector2(parentSize.x - lifeBarSize.x, -lifeBarSize.y - 2);
    var backgroundFillColor = Paint()
      ..color = Colors.grey.withOpacity(0.35)
      ..style = PaintingStyle.fill;
    var outlineColor = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    // Create the life bar using pilled rectangle blocks
    List<RectangleComponent> lifeBar = [
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
        size: Vector2(_defaultCurrentLife, lifeBarHeight),
        angle: 0,
        paint: _setLifeBarColor(),
      ),
    ];

    // Add boxes
    addAll(lifeBar);
  }

  // Get painting color for life bar based on red zone life
  Paint _setLifeBarColor() {
    return Paint()
      // Set the red zone based on a percentage and the parent size
      // If [redZoneLife] = 25 and [parentSize.x] = 80
      // Danger zone will be the 25% of 80, in this case when
      // [_defaultCurrentLife] is less or equal to 20
      ..color = _defaultCurrentLife <= (parentSize.x * (redZoneLife / 100))
          ? dangerColor
          : healthyColor
      ..style = PaintingStyle.fill;
  }
}
