import 'team.dart';

// A class to hold the state for the undo feature
class ScoreState {
  final int teamAGames;
  final int teamBGames;
  final String teamAPoints;
  final String teamBPoints;
  final Team servingTeam;
  final int secondsElapsed;
  final int faultCount; // Added fault count to history

  ScoreState({
    required this.teamAGames,
    required this.teamBGames,
    required this.teamAPoints,
    required this.teamBPoints,
    required this.servingTeam,
    required this.secondsElapsed,
    required this.faultCount,
  });
}
