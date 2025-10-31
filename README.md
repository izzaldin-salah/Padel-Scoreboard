# 🎾 Padel Scoreboard

A modern, beautiful, and intuitive scoreboard application for Padel matches built with Flutter. Track your games, manage scores, and keep a complete history of all your matches.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B.svg?style=flat&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2.svg?style=flat&logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## ✨ Features

- **⚡ Real-time Score Tracking**: Tap-to-score interface for quick and easy point tracking
- **🎯 Fault Management**: Track first and second faults with visual indicators
- **↩️ Undo Functionality**: Made a mistake? Undo any point with complete state restoration
- **⏱️ Match Timer**: Automatic time tracking for every match
- **📊 Match History**: Complete history of all matches with detailed statistics
- **🌓 Dark/Light Mode**: Beautiful themes optimized for any lighting condition
- **🏆 Match Formats**: Support for Best of 3 and Best of 5 game formats
- **💾 Persistent Storage**: All match data saved locally using Hive database
- **📱 Cross-platform**: Works on Android, iOS, Web, and Desktop

## 📸 Screenshots

<table>
  <tr>
    <td><img src="screenshots/setup.png" width="250" alt="Match Setup"/></td>
    <td><img src="screenshots/scoreboard.png" width="250" alt="Scoreboard"/></td>
    <td><img src="screenshots/history.png" width="250" alt="Match History"/></td>
  </tr>
  <tr>
    <td align="center">Match Setup</td>
    <td align="center">Live Scoreboard</td>
    <td align="center">Match History</td>
  </tr>
</table>

## 🏗️ Project Structure

```
lib/
├── main.dart                      # App entry point, theme, and routing
├── models/
│   ├── match_result.dart          # Hive model for match results
│   ├── match_result.g.dart        # Generated Hive adapter
│   ├── score_state.dart           # Undo snapshot class
│   └── team.dart                  # Team enum (TeamA/TeamB)
├── screens/
│   ├── match_setup_screen.dart    # Team names & match format setup
│   ├── scoreboard_screen.dart     # Main game screen with scoring
│   └── match_history_screen.dart  # Match history list
├── helpers/
│   ├── score_manager.dart         # Core scoring logic & state management
│   └── utils.dart                 # Helper functions (formatDuration, constants)
└── services/
    └── hive_service.dart          # Database initialization & operations
```

## 🎮 How to Use

### Starting a Match

1. **Enter Team Names**: Input names for both teams (default: Team A & Team B)
2. **Select Format**: Choose between Best of 3 or Best of 5 games
3. **Start Match**: Tap "Start Match" to begin

### During the Match

- **Score Points**: Tap anywhere on a team's card to add a point
- **Record Faults**: Use the FAULT button at the bottom
  - First fault: Button turns red with border
  - Second fault (double fault): Point awarded to receiving team
- **Undo Mistakes**: Tap "Undo" to reverse the last action
- **Reset Match**: Tap "Reset" to restart the current match

### Scoring System

The app follows official Padel scoring rules:
- Points: 0, 15, 30, 40, Advantage (AD)
- Deuce at 40-40
- Must win by 2 points after deuce
- Server switches after each game
- Faults persist during a game, reset after game ends

### Viewing History

- Tap "View Match History" from the setup screen
- See all completed matches with:
  - Team names and final scores
  - Match winner highlighted
  - Match duration
  - Date played

## 🛠️ Technologies Used

- **[Flutter](https://flutter.dev)**: UI framework for building beautiful, natively compiled applications
- **[Dart](https://dart.dev)**: Programming language optimized for building mobile apps
- **[Hive](https://docs.hivedb.dev)**: Lightweight and fast NoSQL database for Flutter
- **[Google Fonts](https://pub.dev/packages/google_fonts)**: Inter font family for modern typography
- **[build_runner](https://pub.dev/packages/build_runner)**: Code generation tool for Hive adapters

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.3.0
  hive_flutter: ^1.1.0
  path_provider: ^2.1.5

dev_dependencies:
  build_runner: ^2.4.13
  hive_generator: ^2.0.1
  flutter_lints: ^4.0.0
```

## 🎨 Design Features

- **Modern UI**: Clean, minimalist design with smooth animations
- **Responsive Layout**: Adapts to different screen sizes and orientations
- **High Contrast**: Optimized color schemes for excellent readability
- **Intuitive UX**: Tap-to-score interface minimizes interaction time
- **Visual Feedback**: Clear indicators for serving team and fault count
- **Theme Support**: Beautiful dark and light themes

## 🔧 Configuration

### Changing Colors

Edit the color constants in `lib/main.dart`:

```dart
const Color _darkBackground = Color(0xFF121212);
const Color _darkAccentColor = Color(0xFFDFFF00);
const Color _lightAccentColor = Color(0xFF007BFF);
```

### Modifying Match Formats

Add more options in `match_setup_screen.dart`:

```dart
int _selectedBestOf = 3; // Change default format
// Add more format options in _buildMatchFormatSelector()
```

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/AmazingFeature
   ```
5. **Open a Pull Request**

### Development Guidelines

- Follow the existing code structure and naming conventions
- Use meaningful commit messages
- Add comments for complex logic
- Test on multiple platforms before submitting
- Update documentation if adding new features

## 🐛 Known Issues

- Windows: Build directory file locking may occur (fixed by closing File Explorer)
- First run may require `flutter clean` if build errors occur

## 📝 Roadmap

- [ ] Set score editing
- [ ] Match statistics and analytics
- [ ] Player profiles
- [ ] Tournament mode
- [ ] Export match data (CSV, PDF)
- [ ] Share match results
- [ ] Cloud sync across devices
- [ ] Multiplayer support with live updates
- [ ] Voice commands for hands-free scoring
- [ ] Apple Watch / Wear OS companion app

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Izzaldin Salah**

- GitHub: [@izzaldin-salah](https://github.com/izzaldin-salah)
- Repository: [Padel-Scoreboard](https://github.com/izzaldin-salah/Padel-Scoreboard)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Hive developers for the efficient local database
- Google Fonts for the beautiful Inter font family
- The Padel community for inspiration

## 📞 Support

If you like this project, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs via [Issues](https://github.com/izzaldin-salah/Padel-Scoreboard/issues)
- 💡 Suggesting new features
- 🔀 Contributing to the codebase

---

Made with ❤️ and Flutter by Izzaldin Salah
