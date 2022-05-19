import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz/models/answer.dart';
import 'package:quiz/models/language.dart';

part 'translate_answer.g.dart';

@HiveType(typeId: 5)
class TranslateAnswer {
  TranslateAnswer({this.language, this.answers});

  @HiveField(0)
  Language? language;
  @HiveField(1)
  List<Answer>? answers;

  TranslateAnswer.fromJson(Map<String, dynamic> json) {
    language = Language.fromJson(json['language']);
    if (json['answers'] != null) {
      answers = <Answer>[];
      for (var item in json['answers']) {
        answers!.add(Answer.fromJson(item));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = language?.toJson();
    data['answers'] = answers?.map((e) => e.toJson()).toList();
    return data;
  }
}
