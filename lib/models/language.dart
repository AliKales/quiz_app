
import 'package:hive_flutter/hive_flutter.dart';

part 'language.g.dart';

@HiveType(typeId: 7)
class Language {
  @HiveField(0)
  String? languageCode;
  @HiveField(1)
  String? language;

  Language({this.languageCode, this.language});

  Language.fromJson(Map<String, dynamic> json) {
    languageCode = json['languageCode'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['languageCode'] = languageCode;
    data['language'] = language;
    return data;
  }
}
