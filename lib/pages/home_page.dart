import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/quiz_service.dart';
import '../models/question.dart';
import 'level_selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuizService _quizService = QuizService();
  Map<String, List<Question>>? _questions;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _quizService.loadQuestions();
    setState(() {
      _questions = data;
      _isLoading = false;
    });
  }

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
        title: const Text("Quiz Éducatif 🎓"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                          "Choisis un thème pour commencer !",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: -0.2, end: 0),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 1.0,
                            ),
                        itemCount: _questions?.keys.length ?? 0,
                        itemBuilder: (context, index) {
                          final theme = _questions!.keys.elementAt(index);
                          return _ThemeCard(
                            themeName: _formatThemeName(theme),
                            index: index,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LevelSelectionPage(
                                    theme: theme,
                                    allQuestions: _questions![theme]!,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String themeName;
  final int index;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.themeName,
    required this.index,
    required this.onTap,
  });

  Color _getGradientColor(int index) {
    const colors = [
      Color(0xFF6A1B9A), // Purple
      Color(0xFF283593), // Indigo
      Color(0xFF1565C0), // Blue
      Color(0xFF0277BD), // Light Blue
      Color(0xFF00695C), // Teal
      Color(0xFF2E7D32), // Green
      Color(0xFFEF6C00), // Orange
      Color(0xFFC62828), // Red
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  _getGradientColor(index).withOpacity(0.8),
                  _getGradientColor(index),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: _getGradientColor(index).withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.code, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 15),
                Text(
                  themeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
        .animate(delay: (100 * index).ms)
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }
}
