import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '/01_squares/components/square.dart';

/// Square game
///
/// This game allow to create squares each time user press the screen.
///
/// Also is possible to reverse the direction of the square is moving and
/// stop all the square components on the screen
class SquareGame extends FlameGame with DoubleTapDetector, TapDetector {
  /// Handle engine running or not
  bool running = true;

  /// Debug mode show information of each component on user screen
  @override
  bool get debugMode => false;

  /// Text rendering default style
  final textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 14,
      fontFamily: 'Awesome Font',
    ),
  );

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);

    // Points touched by user
    final touchPoint = info.eventPosition.game;
    // Validate if some component on the screen is handle or not
    final handle = children.any((component) {
      if (component is Square && component.containsPoint(touchPoint)) {
        // Move velocity vector into opposite direction
        component.velocity?.negate();
        return true;
      }
      return false;
    });

    // If there is not a square in the screen points user tap
    if (!handle) {
      _addNewSquare();
    }
  }

  @override
  void onDoubleTap() {
    // Pause or resume game
    running ? pauseEngine() : resumeEngine();
    running = !running;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Show text at the top left of the screen the number of components active
    textPaint.render(
      canvas,
      'Objects active: ${children.length}',
      Vector2(20, 50),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Validate which components are out of the screen boundaries to delete it
    for (var component in children) {
      if (component is Square) {
        if (_componentIsOutOfScreen(component)) {
          // Remove component from Memory when his position is out of the screen
          remove(component);
        }
      }
    }
  }

  // Add new square into screen
  _addNewSquare() {
    final squareColor = BasicPalette.white.paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    // Square to add
    final newSquare = Square(
      squareSize: 45.0,
      color: squareColor,
      velocity: _getRandomVelocity(),
    )..position = _getRandomPosition();
    // Add the new component into the game screen
    add(newSquare);
  }

  // Random position vector
  Vector2 _getRandomPosition() => Vector2(
      _getRandomNumber(size.x.round()), _getRandomNumber(size.y.round()));

  // Random velocity vector
  Vector2 _getRandomVelocity() =>
      Vector2.random().normalized() * _getRandomNumber(100);

  // Get a random number
  double _getRandomNumber(int max) => Random().nextInt(max).toDouble();

  // Validate if a position of component is out of boundaries
  bool _componentIsOutOfScreen(PositionComponent component) {
    if (component.position.x > (size.x + (component.size.x / 2)) ||
        component.position.x < (0 - (component.size.x / 2)) ||
        component.position.y > (size.y + (component.size.y / 2)) ||
        component.position.y < (0 - (component.size.y / 2))) {
      return true;
    }
    return false;
  }
}
