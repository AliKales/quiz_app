import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz/models/category.dart';
import 'package:quiz/models/translate_category.dart';
import 'package:quiz/models/language.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/values.dart';

part 'game_values.g.dart';

@HiveType(typeId: 3)
class GameValues {
  GameValues({
    this.categories,
    this.questions,
    this.updateId,
    this.databaseStatus,
    this.languages
  });

  @HiveField(0)
  List<Category>? categories;
  @HiveField(1)
  List<Question>? questions;
  @HiveField(2)
  int? updateId;
  @HiveField(3)
  DatabaseStatus? databaseStatus;
  @HiveField(4)
  List<Language>? languages;

  GameValues.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Category>[];
      for (var item in json['categories']) {
        categories!.add(Category.fromJson(item));
      }
    }
    if (json['questions'] != null) {
      questions = <Question>[];
      for (var item in json['questions']) {
        questions!.add(Question.fromJson(item));
      }
    }
    if (json['languages'] != null) {
      languages = <Language>[];
      for (var item in json['languages']) {
        languages!.add(Language.fromJson(item));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories'] = categories?.map((e) => e.toJson()).toList();
    data['questions'] = questions?.map((e) => e.toJson()).toList();
    data['languages'] = languages?.map((e) => e.toJson()).toList();
    return data;
  }
}
