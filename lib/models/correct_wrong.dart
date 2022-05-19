import 'package:hive_flutter/hive_flutter.dart';

part 'correct_wrong.g.dart';

@HiveType(typeId: 11)
class CorrectWrong {
  @HiveField(0)
  int correct;
  @HiveField(1)
  int wrong;
  @HiveField(2)
  int questionsLength;

  CorrectWrong({this.correct = 0, this.wrong = 0, this.questionsLength = 0});

  void reset(int _questionsLength) {
    correct = 0;
    wrong = 0;
    questionsLength = _questionsLength;
  }
}
