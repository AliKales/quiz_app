import 'package:quiz/models/language.dart';

class GameSettings {
  String? category;
  Language? language;

  GameSettings({this.category, this.language});

  GameSettings.fromJson(Map<String, dynamic> json) {
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
