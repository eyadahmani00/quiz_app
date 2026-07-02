import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/question.dart';
import 'quiz_page.dart';

class LevelSelectionPage extends StatelessWidget {
  final String theme;
  final List<Question> allQuestions;

  const LevelSelectionPage({
    super.key,
    required this.theme,
    required this.allQuestions,
  });

  String _formatThemeName(String key) {
    return key
        .split('_')
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Niveau: ${_formatThemeName(theme)}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F5FA), Color(0xFFE0E0E0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Choisissez votre difficulté",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ).animate().fadeIn().slideY(begin: -0.5, end: 0),
              const SizedBox(height: 40),
              _LevelButton(
                label: "Facile",
                color: Colors.green,
                icon: Icons.sentiment_satisfied_alt,
                delay: 100,
                onTap: () => _startQuiz(context, 30),
              ),
              const SizedBox(height: 20),
              _LevelButton(
                label: "Moyen",
                color: Colors.blue,
                icon: Icons.sentiment_neutral,
                delay: 200,
                onTap: () => _startQuiz(context, 20),
              ),
              const SizedBox(height: 20),
              _LevelButton(
                label: "Difficile",
                color: Colors.orange,
                icon: Icons.sentiment_very_dissatisfied,
                delay: 300,
                onTap: () => _startQuiz(context, 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startQuiz(BuildContext context, int duration) {
    String difficulty;
    if (duration == 30) {
      difficulty = 'easy';
    } else if (duration == 20) {
      difficulty = 'medium';
    } else {
      difficulty = 'hard';
    }

    // Filter questions by difficulty
    List<Question> filteredQuestions = allQuestions
        .where((q) => q.difficulty == difficulty)
        .toList();

    // Fallback if not enough questions in that difficulty (though our round-robin ensures balance)
    if (filteredQuestions.length < 5) {
      filteredQuestions = allQuestions; // Fallback to all if scarce
    }

    List<Question> questions = List.from(filteredQuestions)..shuffle();
    List<Question> selectedQuestions = questions.take(10).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
          theme: theme,
          questions: selectedQuestions,
          allQuestions:
              allQuestions, // Keep all for "Continue" button later if needed
          duration: duration,
        ),
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final int delay;
  final VoidCallback onTap;

  const _LevelButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 28),
      label: Text(label, style: const TextStyle(fontSize: 20)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
      ),
    ).animate(delay: delay.ms).fadeIn().scale();
  }
}
