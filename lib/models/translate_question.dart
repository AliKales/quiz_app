import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz/models/language.dart';

part 'translate_question.g.dart';

@HiveType(typeId: 9)
class TranslateQuestion {
  TranslateQuestion({this.language, this.question});

  @HiveField(0)
  Language? language;
  @HiveField(1)
  String? question;

  TranslateQuestion.fromJson(Map<String, dynamic> json) {
    language = Language.fromJson(json['language']);
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = language?.toJson();
    data['question'] = question;

    return data;
  }
}
