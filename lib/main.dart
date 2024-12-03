import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const HangmanGame());
}

class HangmanGame extends StatelessWidget {
  const HangmanGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WORD GUESS GAME',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

/// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3)); // Duration of the splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HangmanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image.png', // Path to the image
                width: 350,
                height: 450,
              ),
              const SizedBox(height: 100),
              const Text(
                'Welcome to Word Guessing Game',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

/// Main Game Screen
class HangmanScreen extends StatefulWidget {
  const HangmanScreen({super.key});

  @override
  State<HangmanScreen> createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  final List<Map<String, dynamic>> _wordList = [
    {'word': 'HAPPY', 'image': 'assets/happy.png'},
    {'word': 'BUTTERFLY', 'image': 'assets/butterfly.png'},
    {'word': 'APPLE', 'image': 'assets/apple.png'},
    {'word': 'GUITAR', 'image': 'assets/guitar.png'},
    {'word': 'EXAM', 'image': 'assets/exam.jpg'},
    // Add more words and images here
  ];

  late String _wordToGuess;
  late String _imagePath;
  late List<String> _guessedLetters;
  late int _wrongGuesses;
  late int _maxGuesses;
  late int _score;
  String _message = '';
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _score = 0; // Initialize score
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      var selectedWord = _wordList[Random().nextInt(_wordList.length)];
      _wordToGuess = selectedWord['word'];
      _imagePath = selectedWord['image'];
      _guessedLetters = [];
      _wrongGuesses = 0;
      _maxGuesses = 6;
      _message = '';
      _gameOver = false;

      // Reveal one random letter as a hint
      String hintLetter = _wordToGuess[Random().nextInt(_wordToGuess.length)];
      _guessedLetters.add(hintLetter);
    });
  }

  void _guessLetter(String letter) {
    if (_gameOver || _guessedLetters.contains(letter)) return;

    setState(() {
      _guessedLetters.add(letter);

      if (_wordToGuess.contains(letter)) {
        if (_wordToGuess.split('').every((char) => _guessedLetters.contains(char))) {
          _message = 'You WON!';
          _score++;
          _gameOver = true;
        }
      } else {
        _wrongGuesses++;
        if (_wrongGuesses >= _maxGuesses) {
          _message = 'You LOST! The word was $_wordToGuess.';
          _gameOver = true;
        }
      }
    });
  }

  String _getDisplayWord() {
    return _wordToGuess
        .split('')
        .map((char) => _guessedLetters.contains(char) ? char : '_')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.amber],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Word Guessing Game',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Display image associated with the word
              Image.asset(
                _imagePath, // Image corresponding to the word
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white70,
                  boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black26)],
                ),
                child: Column(
                  children: [
                    Text(
                      'Score: $_score',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Wrong Guesses: $_wrongGuesses / $_maxGuesses',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _getDisplayWord(),
                style: const TextStyle(fontSize: 36, letterSpacing: 4, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                    .split('')
                    .map(
                      (letter) {
                        bool isGuessed = _guessedLetters.contains(letter);
                        bool isCorrect = isGuessed && _wordToGuess.contains(letter);
                        bool isIncorrect = isGuessed && !_wordToGuess.contains(letter);

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isCorrect
                                ? Colors.green // Correct guess
                                : isIncorrect
                                    ? Colors.red // Incorrect guess
                                    : Colors.orangeAccent, // Default
                            foregroundColor: Colors.white,
                            shadowColor: Colors.black38,
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          onPressed: isGuessed || _gameOver
                              ? null
                              : () => _guessLetter(letter),
                          child: Text(
                            letter,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              Text(
                _message,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              if (_gameOver)
                ElevatedButton(
                  onPressed: _startNewGame,
                  child: const Text('Play Again'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
