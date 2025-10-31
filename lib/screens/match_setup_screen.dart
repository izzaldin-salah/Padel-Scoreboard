import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scoreboard_screen.dart';
import 'match_history_screen.dart';

// --- App Theme Colors ---
const Color _darkSurfaceColor = Color(0xFF1E1E1E);

class MatchSetupScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;
  final ThemeMode currentTheme;
  const MatchSetupScreen({super.key, required this.onThemeChanged, required this.currentTheme});

  @override
  State<MatchSetupScreen> createState() => _MatchSetupScreenState();
}

class _MatchSetupScreenState extends State<MatchSetupScreen> {
  final _teamAController = TextEditingController(text: 'Team A');
  final _teamBController = TextEditingController(text: 'Team B');
  int _selectedBestOf = 3; // 3 or 5 for "Best of"

  @override
  void dispose() {
    _teamAController.dispose();
    _teamBController.dispose();
    super.dispose();
  }

  void _startMatch() {
    // Basic validation
    if (_teamAController.text.isEmpty || _teamBController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter names for both teams.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    
    // Calculate the number of games needed to win for a "best of" series
    final int gamesToWin = (_selectedBestOf / 2).floor() + 1;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScoreboardScreen(
          teamAName: _teamAController.text,
          teamBName: _teamBController.text,
          gamesToWin: gamesToWin,
          bestOf: _selectedBestOf, // Pass the original "best of" value for display
        ),
      ),
    );
  }

  void _viewHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MatchHistoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Padel Match',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.currentTheme == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: widget.onThemeChanged,
            tooltip: 'Toggle Theme',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Padel Logo ---
              Icon(
                Icons.sports_tennis,
                size: 100,
                color: Theme.of(context).primaryColor.withOpacity(0.8),
              ),
              const SizedBox(height: 40),

              // --- Team Name Inputs ---
              _buildTeamNameField(_teamAController, 'Team A'),
              const SizedBox(height: 20),
              _buildTeamNameField(_teamBController, 'Team B'),
              const SizedBox(height: 40),

              // --- Match Format Selector ---
              Text(
                'Match Format',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              _buildMatchFormatSelector(),
              const SizedBox(height: 60),

              // --- Action Buttons ---
              ElevatedButton(
                onPressed: _startMatch,
                child: const Text('Start Match'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _viewHistory,
                child: Text(
                  'View Match History',
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamNameField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildMatchFormatSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? _darkSurfaceColor : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFormatOption(3),
          _buildFormatOption(5),
        ],
      ),
    );
  }

  Widget _buildFormatOption(int format) {
    final isSelected = _selectedBestOf == format;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLightModeSelected = !isDark && isSelected;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedBestOf = format;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'Best of $format',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isLightModeSelected ? Colors.white : (isSelected ? Colors.black : (isDark ? Colors.white : Colors.black)),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
