import 'package:hive/hive.dart';
import 'package:quiz/models/answer.dart';
import 'package:quiz/models/translate_answer.dart';
import 'package:quiz/models/translate_question.dart';

part 'question.g.dart';

@HiveType(typeId: 1)
class Question {
  @HiveField(0)
  List<TranslateQuestion>? question;

  @HiveField(1)
  int? answer;

  @HiveField(2)
  List<TranslateAnswer>? answers;

  @HiveField(3)
  String? id;

  @HiveField(4)
  String? catergory;

  Question(
      {this.question,
      this.answer,
      this.answers,
      this.id,
      this.catergory});

  Question.fromJson(Map<String, dynamic> json) {
    if (json['question'] != null) {
      question = <TranslateQuestion>[];
      for (var item in json['question']) {
        question!.add(TranslateQuestion.fromJson(item));
      }
    }
    answer = json['answer'];
    if (json['answers'] != null) {
      answers = <TranslateAnswer>[];
      for (var item in json['answers']) {
        answers!.add(TranslateAnswer.fromJson(item));
      }
    }
    id = json['id'];
    catergory = json['catergory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question?.map((e) => e.toJson()).toList();
    data['answer'] = answer;
    data['answers'] = answers?.map((e) => e.toJson()).toList();
    data['id'] = id;
    data['catergory'] = catergory;
    return data;
  }
}
