import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  final String theme;
  final List<Question> questions;
  final List<Question> allQuestions;
  final int duration;

  const QuizPage({
    super.key,
    required this.theme,
    required this.questions,
    required this.allQuestions,
    this.duration = 20,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  int _score = 0;
  late int _secondsRemaining;
  Timer? _timer;
  bool _isAnswered = false;
  String? _selectedOption;
  late List<Question> _shuffledQuestions;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.duration;
    _shuffledQuestions = widget.questions.map((q) {
      final shuffledOptions = List<String>.from(q.options)..shuffle();
      return Question(
        question: q.question,
        options: shuffledOptions,
        correct: q.correct,
        difficulty: q.difficulty,
      );
    }).toList();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _handleNextQuestion();
      }
    });
  }

  void _handleAnswer(String option) {
    if (_isAnswered) return;
    _isAnswered = true;
    _selectedOption = option;
    _timer?.cancel();

    if (option == _shuffledQuestions[_currentIndex].correct) {
      _score++;
    }

    setState(() {});

    Future.delayed(const Duration(milliseconds: 1000), () {
      _handleNextQuestion();
    });
  }

  void _handleNextQuestion() {
    _timer?.cancel();
    if (_currentIndex < _shuffledQuestions.length - 1) {
      setState(() {
        _currentIndex++;
        _secondsRemaining = widget.duration;
        _isAnswered = false;
        _selectedOption = null;
      });
      _startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            score: _score,
            totalQuestions: _shuffledQuestions.length,
            theme: widget.theme,
            allQuestions: widget.allQuestions,
            onRestart: () {},
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color _getOptionColor(String option) {
    if (!_isAnswered) return Colors.white;
    final correct = _shuffledQuestions[_currentIndex].correct;
    if (option == correct) return Colors.green.shade100;
    if (option == _selectedOption) return Colors.red.shade100;
    return Colors.white;
  }

  Color _getOptionBorderColor(String option) {
    if (!_isAnswered) return Colors.transparent;
    final correct = _shuffledQuestions[_currentIndex].correct;
    if (option == correct) return Colors.green;
    if (option == _selectedOption) return Colors.red;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final question = _shuffledQuestions[_currentIndex];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.indigo),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.theme.toUpperCase(),
          style: const TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF5F5FA),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Question ${_currentIndex + 1}/${widget.questions.length}",
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value:
                                  (_currentIndex + 1) / widget.questions.length,
                              backgroundColor: Colors.indigo.withOpacity(0.1),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.indigo,
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            value: _secondsRemaining / widget.duration,
                            color: _secondsRemaining < 5
                                ? Colors.red
                                : Colors.indigo,
                            backgroundColor: Colors.indigo.withOpacity(0.1),
                            strokeWidth: 4,
                          ),
                        ),
                        Text(
                          "$_secondsRemaining",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _secondsRemaining < 5
                                ? Colors.red
                                : Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          question.question,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ...question.options.map(
                        (option) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _getOptionColor(option) == Colors.white
                                  ? Colors.white
                                  : _getOptionColor(option),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color:
                                    _getOptionBorderColor(option) ==
                                        Colors.transparent
                                    ? Colors.grey.shade300
                                    : _getOptionBorderColor(option),
                                width: 2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () => _handleAnswer(option),
                              borderRadius: BorderRadius.circular(15),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (_isAnswered &&
                                        option ==
                                            _shuffledQuestions[_currentIndex]
                                                .correct)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    else if (_isAnswered &&
                                        option == _selectedOption &&
                                        option !=
                                            _shuffledQuestions[_currentIndex]
                                                .correct)
                                      const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
