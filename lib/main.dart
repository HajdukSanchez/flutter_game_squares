import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/01_squares/game/square_game.dart';

void main() {
  final game = SquareGame();

  runApp(GameWidget(game: game));
}
