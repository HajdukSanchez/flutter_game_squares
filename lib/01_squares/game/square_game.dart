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

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);

    // Points touched by user
    final touchPoint = info.eventPosition.game;
    // Validate if some component on the scnree is handle or not
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
      _addNewSquare(touchPoint);
    }
  }

  @override
  void onDoubleTap() {
    // Pause or resume game
    running ? pauseEngine() : resumeEngine();
    running = !running;
  }

  // Add new square into screen
  _addNewSquare(Vector2 touchPoint) {
    final squareColor = BasicPalette.white.paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    // Square to add
    final newSquare = Square(
      squareSize: 45.0,
      velocity: Vector2(0, 1).normalized() * 25,
      color: squareColor,
    )..position = touchPoint;
    // Add the new component into the game screen
    add(newSquare);
  }
}
