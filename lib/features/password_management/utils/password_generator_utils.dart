import 'dart:math';
import '../models/password_enums.dart';

class PasswordGeneratorUtils {
  static const List<String> commonWords = [
    // Common memorable words (add more as needed)
    'apple', 'banana', 'orange', 'grape', 'mango',
    'dog', 'cat', 'bird', 'fish', 'lion',
    'book', 'desk', 'chair', 'lamp', 'door',
    // ... add more words
  ];

  static const Map<String, String> similarCharacters = {
    'l': '1',
    'I': '1',
    'O': '0',
    'o': '0',
    'S': '5',
    's': '5',
    'A': '4',
    'a': '4',
    'E': '3',
    'e': '3',
    'B': '8',
    'b': '8',
  };

  static const List<String> specialCharacters = [
    '!', '@', '#', '\$', '%', '^', '&', '*',
    '(', ')', '-', '_', '+', '=',
    '[', ']', '{', '}', '|', '\\',
    ';', ':', ',', '.', '<', '>', '/',
    '?', '~', '`', '"', '\''
  ];

  static double calculateEntropy(String password, bool usedUpper, bool usedLower, 
      bool usedNumbers, bool usedSpecial) {
    int poolSize = 0;
    if (usedLower) poolSize += 26;
    if (usedUpper) poolSize += 26;
    if (usedNumbers) poolSize += 10;
    if (usedSpecial) poolSize += 32;
    
    return password.length * (log(poolSize) / log(2));
  }

  static PasswordStrength calculateStrength(String password) {
    double entropy = calculateEntropy(
      password,
      password.contains(RegExp(r'[A-Z]')),
      password.contains(RegExp(r'[a-z]')),
      password.contains(RegExp(r'[0-9]')),
      password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
    );

    if (entropy < 45) return PasswordStrength.weak;
    if (entropy < 60) return PasswordStrength.medium;
    if (entropy < 80) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  static String generateMemorablePassword(int wordCount, String separator, bool capitalize) {
    final random = Random.secure();
    final words = List.generate(wordCount, (_) {
      final word = commonWords[random.nextInt(commonWords.length)];
      return capitalize ? word[0].toUpperCase() + word.substring(1) : word;
    });
    
    // Add numbers and special characters between words
    final enhancedWords = words.map((word) {
      if (random.nextBool()) {
        return '$word${random.nextInt(10)}${specialCharacters[random.nextInt(specialCharacters.length)]}';
      }
      return word;
    }).toList();
    
    return enhancedWords.join(separator);
  }

  static String generatePassphrase(int wordCount, String separator, bool capitalize) {
    final random = Random.secure();
    final words = List.generate(wordCount, (_) {
      final word = commonWords[random.nextInt(commonWords.length)];
      return capitalize ? word[0].toUpperCase() + word.substring(1) : word;
    });
    
    return words.join(separator);
  }

  static String generatePin(int length) {
    final random = Random.secure();
    return List.generate(length, (_) => random.nextInt(10).toString()).join();
  }

  static String applyPattern(String pattern, Map<String, String> characterSets) {
    final random = Random.secure();
    return pattern.split('').map((char) {
      final charSet = characterSets[char] ?? '';
      return charSet.isEmpty ? char : charSet[random.nextInt(charSet.length)];
    }).join();
  }

  static String removeSimilarCharacters(String input) {
    return input.split('').map((char) => 
      similarCharacters.containsKey(char) ? similarCharacters[char]! : char
    ).join();
  }

  static List<String> generateMultiplePasswords(
      int count, Function generateSingle) {
    return List.generate(count, (_) => generateSingle() as String);
  }
} 