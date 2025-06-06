import 'package:flutter/material.dart';
import 'package:snake/managers/game_manager.dart';

// Manager to generate the elements to diplay the snake on the screen
// the head, body and food.
class DisplaySnakeManager {
  // Common container used by each cells
  static Widget _comonContainer({
    Color? color,
    List<BoxShadow>? shadows,
    Widget? child,
    CellType? cellType,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(cellType == CellType.head ? 6 : 2),
        boxShadow: shadows,
      ),
      child: child,
    );
  }

  // Returns the head of the snake
  static Widget getHead() {
    return _comonContainer(
      cellType: CellType.head,
      color: Colors.greenAccent[400]!,
      shadows: [
        BoxShadow(
          color: Colors.greenAccent.withOpacity(0.6),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
      child: const Center(child: Text("👀", style: TextStyle(fontSize: 12))),
    );
  }

  // Returns the body of the snake
  static Widget getBody() {
    return _comonContainer(
      cellType: CellType.body,
      color: Colors.green[800]!,
      shadows: [],
      child: const Center(),
    );
  }

  // Returns the food
  static Widget getFood() {
    return _comonContainer(
      cellType: CellType.food,
      color: Colors.redAccent,
      shadows: [
        BoxShadow(
          color: Colors.redAccent.withOpacity(0.6),
          blurRadius: 6,
          spreadRadius: 1,
        ),
      ],
      child: const Center(child: Text("🍒", style: TextStyle(fontSize: 12))),
    );
  }
}
