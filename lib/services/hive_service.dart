import 'package:hive_flutter/hive_flutter.dart';
import '../models/match_result.dart';
import '../helpers/utils.dart';

class HiveService {
  static Future<void> initialize() async {
    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(MatchResultAdapter());
    await Hive.openBox<MatchResult>(kMatchHistoryBox);
  }

  static Future<void> saveMatchResult(MatchResult matchResult) async {
    await Hive.box<MatchResult>(kMatchHistoryBox).add(matchResult);
  }

  static Box<MatchResult> getMatchHistoryBox() {
    return Hive.box<MatchResult>(kMatchHistoryBox);
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
