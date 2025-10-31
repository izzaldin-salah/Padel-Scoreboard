import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/team.dart';
import '../models/match_result.dart';
import '../helpers/score_manager.dart';
import '../helpers/utils.dart';
import '../services/hive_service.dart';

class ScoreboardScreen extends StatefulWidget {
  final String teamAName;
  final String teamBName;
  final int gamesToWin;
  final int bestOf;

  const ScoreboardScreen({
    super.key,
    required this.teamAName,
    required this.teamBName,
    required this.gamesToWin,
    required this.bestOf,
  });

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  late ScoreManager _scoreManager;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetMatchState();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _scoreManager.secondsElapsed++;
        });
      }
    });
  }

  void _resetMatchState() {
    setState(() {
      _scoreManager = ScoreManager(
        gamesToWin: widget.gamesToWin,
        servingTeam: Random().nextBool() ? Team.teamA : Team.teamB,
      );
      _scoreManager.saveState(); // Save initial state
      _startTimer();
    });
  }

  void _undoLastPoint() {
    if (_scoreManager.undoLastPoint()) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot undo further.'))
      );
    }
  }

  void _recordFault() {
    setState(() {
      _scoreManager.recordFault();
    });
  }

  void _addPoint(Team team) {
    setState(() {
      final winner = _scoreManager.addPoint(team);
      if (winner != null) {
        final winningTeamName = winner == 'teamA' ? widget.teamAName : widget.teamBName;
        _showMatchEndDialog(winningTeamName);
      }
    });
  }

  Future<void> _showMatchEndDialog(String winningTeam) async {
    _timer?.cancel(); // Stop the timer
    
    // Create the match result object
    final matchResult = MatchResult(
      teamAName: widget.teamAName,
      teamBName: widget.teamBName,
      teamAScore: _scoreManager.teamAGames,
      teamBScore: _scoreManager.teamBGames,
      winningTeam: winningTeam,
      date: DateTime.now(),
      durationInSeconds: _scoreManager.secondsElapsed,
    );
    
    // Add the result to the Hive box
    await HiveService.saveMatchResult(matchResult);

    if (!mounted) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 70,
                ),
                const SizedBox(height: 24),
                Text(
                  '$winningTeam Wins!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Final Score: ${_scoreManager.teamAGames} - ${_scoreManager.teamBGames}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Close', 
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7), 
                            fontSize: 16
                          )
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        child: const Text('New Match'),
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showResetConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber.shade600,
                  size: 60,
                ),
                const SizedBox(height: 24),
                Text(
                  'Reset Match?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to reset the current match score?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Cancel', 
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7), 
                            fontSize: 16
                          )
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Reset'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _resetMatchState();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              // Top header with timer
              _buildHeaderBar(),
              const SizedBox(height: 24),

              // Main Scoreboard Area
              Expanded(
                child: Row(
                  children: [
                    _buildTeamScoreCard(Team.teamA),
                    const SizedBox(width: 12),
                    _buildTeamScoreCard(Team.teamB),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Info Bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'First Serve • Best of ${widget.bestOf} Games',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),

              // Bottom Action Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTextButton('Undo', _undoLastPoint),
                  _buildFaultButton(),
                  _buildTextButton('Reset', _showResetConfirmationDialog),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Icon and Team Names
          Flexible(
            child: Row(
              children: [
                Icon(Icons.sports_tennis_rounded, color: Theme.of(context).primaryColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${widget.teamAName} vs ${widget.teamBName}',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Right side: Timer
          Row(
            children: [
              Icon(Icons.timer_outlined, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7), size: 20),
              const SizedBox(width: 8),
              Text(
                formatDuration(_scoreManager.secondsElapsed),
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).cardColor,
      ),
      child: Text(
        label,
        style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7), fontSize: 16),
      ),
    );
  }

  Widget _buildFaultButton() {
    final bool isFirstFault = _scoreManager.faultCount == 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color getFaultButtonColor() {
      if (isFirstFault) return Colors.redAccent;
      return Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7) ?? (isDark ? Colors.white70 : Colors.black54);
    }

    return TextButton(
      onPressed: _recordFault,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          // Add a red border if it's the first fault
          side: isFirstFault ? const BorderSide(color: Colors.redAccent, width: 1.5) : BorderSide.none,
        ),
        backgroundColor: Theme.of(context).cardColor,
      ),
      child: Text(
        'FAULT: ${_scoreManager.faultCount}',
        style: TextStyle(
          color: getFaultButtonColor(),
          fontSize: 16,
          fontWeight: isFirstFault ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTeamScoreCard(Team team) {
    final teamName = (team == Team.teamA) ? widget.teamAName : widget.teamBName;
    final games = (team == Team.teamA) ? _scoreManager.teamAGames : _scoreManager.teamBGames;
    final points = (team == Team.teamA) ? _scoreManager.teamAPoints : _scoreManager.teamBPoints;
    final isServing = _scoreManager.servingTeam == team;

    return Expanded(
      child: GestureDetector(
        onTap: () => _addPoint(team),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 24, 10, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Team Name and Server Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      teamName,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isServing)
                    Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor)
                    ),
                ],
              ),
              // Score Column
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Games
                    Text(
                      '$games',
                      style: GoogleFonts.inter(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Points
                    Text(
                      points,
                      style: GoogleFonts.inter(
                        fontSize: 60,
                        fontWeight: FontWeight.w600,
                        color: points == 'AD'
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              // "Tap to add point" text
              Text(
                "Tap anywhere to add a point",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
