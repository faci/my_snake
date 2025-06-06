import 'package:shared_preferences/shared_preferences.dart';

// Manager to store in the shared_preferences storage
// the best score.
// The objectif here is to keep the best score even when the user close the app.
class BestScoreManager {
  static const _scoreKey = 'snakeHighScore';

  // Save the score in the storage
  static Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_scoreKey, score);
  }

  // Get the score from the storage (return 0 if nothing found)
  static Future<int> getScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_scoreKey) ?? 0;
  }

  // Remove the scrore from the storage
  static Future<void> resetScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scoreKey);
  }
}
