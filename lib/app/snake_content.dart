import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snake/components/restart_popup.dart';
import 'package:snake/components/start_popup.dart';
import 'package:snake/managers/display_snake_manager.dart';
import 'package:snake/managers/game_manager.dart';

class SnakeContent extends StatefulWidget {
  const SnakeContent({super.key});

  @override
  State<SnakeContent> createState() => _SnakeContentState();
}

class _SnakeContentState extends State<SnakeContent> {
  final GameManager gameManager = Get.put(GameManager());

  @override
  void initState() {
    super.initState();
    gameManager.loadBestScore();
    gameManager.initializeGame();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      startPopUp(context: context, startGame: gameManager.startGame);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final dx = details.delta.dx;
        final dy = details.delta.dy;

        if (dx.abs() > dy.abs()) {
          gameManager.changeDirection(
            dx > 0 ? Direction.right : Direction.left,
          );
        } else {
          gameManager.changeDirection(dy > 0 ? Direction.down : Direction.up);
        }
      },
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getScore(),
            const SizedBox(height: 20),
            Obx(() => _buildGrid()),
            Text(
              'Swipe to move the snake. The objective is to eat the cherry.',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 15),
            Obx(() => _buildActions(context)),
            const SizedBox(height: 20),
            Obx(() {
              if (!gameManager.isGameOver.value) return const SizedBox.shrink();
              return Center(
                child: Column(
                  children: [
                    const Text(
                      '💀 GAME OVER 💀',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.cyan,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: gameManager.restartGame,
                      child: const Text(
                        'Restart',
                        style: TextStyle(color: Colors.green, fontSize: 24),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final isPlaying = gameManager.isPlaying.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                side: const BorderSide(color: Colors.cyanAccent),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                foregroundColor: Colors.cyanAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // If the Game is actually over no need to throw the dialog
                if (gameManager.isGameOver.value) {
                  gameManager.restartGame();
                  return;
                }

                gameManager.pauseGame();
                restartPopUp(
                  context: context,
                  restart: gameManager.restartGame,
                  cancel: gameManager.startGame,
                );
              },
              child: const Text(
                '⟳ RESTART',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: TextButton.icon(
              onPressed:
                  isPlaying ? gameManager.pauseGame : gameManager.startGame,
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Color(0xFF8A2BE2), // Violet
                size: 28,
              ),
              label: Text(
                isPlaying ? 'PAUSE' : 'PLAY',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              style: TextButton.styleFrom(
                side: const BorderSide(color: Colors.cyanAccent, width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.cyanAccent,
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getScore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Text(
            'Score: ${gameManager.score}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        Obx(
          () => Text(
            'Best score: ${gameManager.bestScore}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    List<Widget> squares = [];

    for (int y = 0; y < gameManager.rows; y++) {
      for (int x = 0; x < gameManager.columns; x++) {
        final point = Point(x, y);
        Widget element;

        if (gameManager.snake.isNotEmpty && gameManager.snake.first == point) {
          element = DisplaySnakeManager.getHead();
        } else if (gameManager.snake.contains(point)) {
          element = DisplaySnakeManager.getBody();
        } else if (gameManager.food.value == point) {
          element = DisplaySnakeManager.getFood();
        } else {
          element = Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[900]!,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }

        squares.add(element);
      }
    }

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: gameManager.columns,
      physics: const NeverScrollableScrollPhysics(),
      children: squares,
    );
  }
}
