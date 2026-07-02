import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuizService {
  Future<Map<String, List<Question>>> loadQuestions() async {
    final String response = await rootBundle.loadString(
      'assets/questions.json',
    );
    final Map<String, dynamic> data = json.decode(response);

    final Map<String, List<Question>> questions = {};

    data.forEach((key, value) {
      if (value is List) {
        questions[key] = [];
        for (int i = 0; i < value.length; i++) {
          final item = value[i];
          Map<String, dynamic> questionData = Map<String, dynamic>.from(item);

          // Use existing difficulty if present, otherwise assign round-robin
          if (!questionData.containsKey('difficulty')) {
            String difficulty;
            if (i % 3 == 0) {
              difficulty = 'easy';
            } else if (i % 3 == 1) {
              difficulty = 'medium';
            } else {
              difficulty = 'hard';
            }
            questionData['difficulty'] = difficulty;
          }

          questions[key]!.add(Question.fromJson(questionData));
        }
      }
    });

    return questions;
  }
}
