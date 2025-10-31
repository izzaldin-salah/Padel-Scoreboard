import '../models/team.dart';
import '../models/score_state.dart';

class ScoreManager {
  int teamAGames;
  int teamBGames;
  String teamAPoints;
  String teamBPoints;
  Team servingTeam;
  int faultCount;
  int secondsElapsed;
  final List<ScoreState> history = [];
  final int gamesToWin;

  ScoreManager({
    required this.gamesToWin,
    this.teamAGames = 0,
    this.teamBGames = 0,
    this.teamAPoints = '0',
    this.teamBPoints = '0',
    required this.servingTeam,
    this.faultCount = 0,
    this.secondsElapsed = 0,
  });

  void saveState() {
    history.add(ScoreState(
      teamAGames: teamAGames,
      teamBGames: teamBGames,
      teamAPoints: teamAPoints,
      teamBPoints: teamBPoints,
      servingTeam: servingTeam,
      secondsElapsed: secondsElapsed,
      faultCount: faultCount,
    ));
  }

  bool undoLastPoint() {
    if (history.length > 1) {
      history.removeLast(); // Remove current state
      final lastState = history.last; // Get previous state
      teamAGames = lastState.teamAGames;
      teamBGames = lastState.teamBGames;
      teamAPoints = lastState.teamAPoints;
      teamBPoints = lastState.teamBPoints;
      servingTeam = lastState.servingTeam;
      secondsElapsed = lastState.secondsElapsed;
      faultCount = lastState.faultCount;
      return true;
    }
    return false;
  }

  // Returns true if fault resulted in a point being awarded (double fault)
  bool recordFault() {
    if (faultCount == 0) {
      // This is the first fault
      faultCount = 1;
      saveState();
      return false;
    } else {
      // This is the second fault (double fault)
      // Award the point to the receiving team
      final receivingTeam = (servingTeam == Team.teamA) ? Team.teamB : Team.teamA;
      addPoint(receivingTeam);
      return true;
    }
  }

  // Returns null if game continues, or the winning team name if match ended
  String? addPoint(Team team) {
    String currentPointsWinner = (team == Team.teamA) ? teamAPoints : teamBPoints;
    String currentPointsLoser = (team == Team.teamA) ? teamBPoints : teamAPoints;

    String newPointsWinner = '0';

    if (currentPointsWinner == '0') {
      newPointsWinner = '15';
    } else if (currentPointsWinner == '15') {
      newPointsWinner = '30';
    } else if (currentPointsWinner == '30') {
      newPointsWinner = '40';
    } else if (currentPointsWinner == '40') {
      if (currentPointsLoser == '40') {
        newPointsWinner = 'AD'; // Advantage
      } else if (currentPointsLoser == 'AD') {
        // This case handles when the player with AD loses the point. Score goes back to Deuce.
        updatePoints('40', '40');
        return null;
      } else {
        // Game win
        return addGame(team);
      }
    } else if (currentPointsWinner == 'AD') {
      // Game win from Advantage
      return addGame(team);
    }

    if (team == Team.teamA) {
      updatePoints(newPointsWinner, teamBPoints);
    } else {
      // Team B scored
      updatePoints(teamAPoints, newPointsWinner);
    }
    return null;
  }

  void updatePoints(String pointsA, String pointsB) {
    teamAPoints = pointsA;
    teamBPoints = pointsB;
    saveState();
  }

  // Returns null if match continues, or the winning team name if match ended
  String? addGame(Team team) {
    if (team == Team.teamA) {
      teamAGames++;
    } else {
      teamBGames++;
    }

    // Check for a match win
    if (teamAGames == gamesToWin) {
      return 'teamA'; // Match is over
    } else if (teamBGames == gamesToWin) {
      return 'teamB'; // Match is over
    }

    // If no match win, reset points and switch server
    teamAPoints = '0';
    teamBPoints = '0';
    servingTeam = (servingTeam == Team.teamA) ? Team.teamB : Team.teamA;
    faultCount = 0; // Game over, so fault is reset.
    saveState();
    return null;
  }

  void reset(Team initialServingTeam) {
    teamAGames = 0;
    teamBGames = 0;
    teamAPoints = '0';
    teamBPoints = '0';
    servingTeam = initialServingTeam;
    faultCount = 0;
    history.clear();
    secondsElapsed = 0;
    saveState(); // Save initial state
  }
}
