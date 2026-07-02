class Question {
  final String question;
  final List<String> options;
  final String correct;
  final String difficulty;

  Question({
    required this.question,
    required this.options,
    required this.correct,
    required this.difficulty,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      correct: json['correct'] as String,
      difficulty:
          json['difficulty'] as String? ?? 'medium', // Default if missing
    );
  }
}
