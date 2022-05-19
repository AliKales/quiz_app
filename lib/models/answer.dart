import 'package:hive_flutter/hive_flutter.dart';

part 'answer.g.dart';

@HiveType(typeId: 4)
class Answer {
  Answer({this.answer, this.id});

  @HiveField(0)
  String? answer;
  @HiveField(1)
  int? id;

  Answer.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['answer'] = answer;
    data['id'] = id;
    return data;
  }
}
