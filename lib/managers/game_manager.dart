import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:snake/managers/best_score_manager.dart';

// Possible directions of the swipe [up, down, left, right]
enum Direction { up, down, left, right }

// Different cell types [empty, head, body, food]
enum CellType { empty, head, body, food }

// Manager to handle the game actions [init, play, pause, restart]
// And the different datas [snake, direction, food]
class GameManager extends GetxController {
  final int rows = 15;
  final int columns = 15;

  // Followed datas
  RxList<Point<int>> snake = <Point<int>>[].obs;
  Rx<Direction> direction = Direction.up.obs;
  Rx<Point<int>> food = Point(5, 5).obs;
  RxInt score = 0.obs;
  RxInt bestScore = 0.obs;
  RxBool isGameOver = false.obs;
  RxBool isPlaying = false.obs;

  Timer? timer;

  // Returns the actual cell type
  CellType getCellType(Point<int> point) {
    if (snake.isEmpty) return CellType.empty;
    if (snake.first == point) return CellType.head;
    if (snake.contains(point)) return CellType.body;
    if (food.value == point) return CellType.food;
    return CellType.empty;
  }

  // Charge the initial best score
  Future<void> loadBestScore() async {
    bestScore.value = await BestScoreManager.getScore();
  }

  // Initialize the game
  void initializeGame() {
    final random = Random();

    int headX = random.nextInt(columns);
    int headY = random.nextInt(rows);
    Point<int> head = Point(headX, headY);
    Point<int> tail = Point(headX, headY + 1 < rows ? headY + 1 : headY - 1);

    snake.value = [head, tail];
    direction.value = Direction.values[random.nextInt(Direction.values.length)];

    generateFood();
    score.value = 0;
    isGameOver.value = false;
  }

  // Generate a position for the food
  void generateFood() {
    final random = Random();
    Point<int> newFood;

    do {
      newFood = Point(random.nextInt(columns), random.nextInt(rows));
    } while (snake.contains(newFood));

    food.value = newFood;
  }

  // Start the game
  void startGame() {
    if (isGameOver.value) {
      isGameOver.value = false;
      restartGame();
    }

    isGameOver.value = false;
    timer?.cancel();
    isPlaying.value = true;
    timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      updateSnake();
    });
  }

  // Pause the game
  void pauseGame() {
    timer?.cancel();
    isPlaying.value = false;
  }

  // Update the snake position depending on the direction
  void updateSnake() {
    if (isGameOver.value) return;

    Point<int> newHead;
    final head = snake.first;

    // Calculate the newHead
    switch (direction.value) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    // Check for colisions with border of itself
    if (newHead.x < 0 ||
        newHead.x >= columns ||
        newHead.y < 0 ||
        newHead.y >= rows ||
        snake.contains(newHead)) {
      isPlaying.value = false;
      isGameOver.value = true;
      bestScore.value =
          score.value > bestScore.value ? score.value : bestScore.value;
      BestScoreManager.saveScore(bestScore.value);
      timer?.cancel();
      return;
    }

    // Insert the new head
    snake.insert(0, newHead);

    // If it was food, add a point and generate a new food
    if (newHead == food.value) {
      score++;
      generateFood();
    } else {
      snake.removeLast();
    }
  }

  // Update the direction
  void changeDirection(Direction newDirection) {
    if ((direction.value == Direction.up && newDirection == Direction.down) ||
        (direction.value == Direction.down && newDirection == Direction.up) ||
        (direction.value == Direction.left &&
            newDirection == Direction.right) ||
        (direction.value == Direction.right &&
            newDirection == Direction.left)) {
      return;
    }

    direction.value = newDirection;
  }

  // Re start the game
  void restartGame() {
    initializeGame();
    startGame();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
