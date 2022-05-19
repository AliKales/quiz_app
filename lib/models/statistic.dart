import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quiz/values.dart';

part 'statistic.g.dart';

@HiveType(typeId: 2)
class Statistic {
  Statistic({
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.totalQuestions = 0,
  });
  
  @HiveField(0)
  int correctAnswers;

  @HiveField(1)
  int wrongAnswers;

  @HiveField(2)
  int totalQuestions;

  int get getPoint => _calculatePoint();

  Color get getColorOfRank {
    int point = _calculatePoint();
    if (point < bronzPoint) {
      return const Color.fromARGB(255, 139, 94, 72);
    } else if (point < silverPoint) {
      return const Color.fromARGB(255, 133, 152, 155);
    } else if (point < goldPoint) {
      return const Color.fromARGB(255, 213, 195, 122);
    } else if (point < platinumPoint) {
      return const Color.fromARGB(255, 95, 138, 130);
    } else {
      return const Color.fromARGB(255, 93, 196, 213);
    }
  }

  Rank get getRank {
    int point = _calculatePoint();
    if (point < bronzPoint) {
      return Rank.bronz;
    } else if (point < silverPoint) {
      return Rank.silver;
    } else if (point < goldPoint) {
      return Rank.gold;
    } else if (point < platinumPoint) {
      return Rank.platinum;
    } else {
      return Rank.diamond;
    }
  }

  int _calculatePoint() {
    return ((correctAnswers - (wrongAnswers ~/ wrongsToRemoveCorrects)) *
            pointForEachCorrect) -
        ((totalQuestions - correctAnswers - wrongAnswers) *
            notAnsweredQuestionPoint);
  }
}

enum Rank {
  bronz,
  silver,
  gold,
  platinum,
  diamond,
}
