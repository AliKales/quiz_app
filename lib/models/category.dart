import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz/models/translate_category.dart';

part 'category.g.dart';

@HiveType(typeId: 6)
class Category {
  Category({this.id, this.translateCategories});

  @HiveField(0)
  String? id;
  @HiveField(1)
  List<TranslateCategory>? translateCategories;

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['translateCategories'] != null) {
      translateCategories = <TranslateCategory>[];
      for (var item in json['translateCategories']) {
        translateCategories!.add(TranslateCategory.fromJson(item));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['translateCategories'] =
        translateCategories?.map((e) => e.toJson()).toList();
    return data;
  }
}
