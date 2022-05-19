import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz/models/language.dart';

part 'translate_category.g.dart';

@HiveType(typeId: 8)
class TranslateCategory {
  TranslateCategory({this.category, this.language});
  
  @HiveField(0)
  String? category;
  @HiveField(1)
  Language? language;

  TranslateCategory.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    language = Language.fromJson(json['language']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['language'] = language?.toJson();
    return data;
  }
}
