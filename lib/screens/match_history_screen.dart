import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/match_result.dart';
import '../helpers/utils.dart';

class MatchHistoryScreen extends StatelessWidget {
  const MatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Match History',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      body: ValueListenableBuilder<Box<MatchResult>>(
        valueListenable: Hive.box<MatchResult>(kMatchHistoryBox).listenable(),
        builder: (context, box, _) {
          final matches = box.values.toList().cast<MatchResult>();
          if (matches.isEmpty) {
            return Center(
              child: Text(
                'No saved matches yet.',
                style: GoogleFonts.inter(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7), fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              // Display the list in reverse chronological order
              final match = matches[matches.length - 1 - index];
              final isTeamAWinner = match.winningTeam == match.teamAName;
              final dateString = '${match.date.day}/${match.date.month}/${match.date.year}';
              final textColor = Theme.of(context).textTheme.bodyMedium?.color;

              return Card(
                color: Theme.of(context).cardColor,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Teams Row
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              match.teamAName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: isTeamAWinner ? FontWeight.bold : FontWeight.normal,
                                color: isTeamAWinner ? Theme.of(context).primaryColor : textColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                'vs',
                                style: GoogleFonts.inter(fontSize: 16, color: textColor?.withOpacity(0.7)),
                              ),
                            ),
                            Text(
                              match.teamBName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: !isTeamAWinner ? FontWeight.bold : FontWeight.normal,
                                color: !isTeamAWinner ? Theme.of(context).primaryColor : textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Score
                      Center(
                        child: Text(
                          '${match.teamAScore} - ${match.teamBScore}',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Date and Duration
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Duration: ${formatDuration(match.durationInSeconds)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor?.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            dateString,
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor?.withOpacity(0.5),
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
        },
      ),
    );
  }
}
