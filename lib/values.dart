import 'package:hive_flutter/hive_flutter.dart';
part 'values.g.dart';

const double radius1 = 16;
const int wrongsToRemoveCorrects = 3;
const int pointForEachCorrect = 5;
const int notAnsweredQuestionPoint = 4;
const int bronzPoint = 500;
const int silverPoint = 1500;
const int goldPoint = 3000;
const int platinumPoint = 5000;
const int diamondPoint = 10000;
const int dayToUpdate = 7;
const int rateOfMatchingWords = 40;
const int secondPerQuestion = 10;
const int minByteForDB = 5000;
const int questionLength = 10;
const String wordsToBeDeleted =
    "much many an a this that what which where when how who am is are the in on what's";

@HiveType(typeId: 10)
enum DatabaseStatus {
  @HiveField(0)
  error,
  @HiveField(1)
  nulll,
  @HiveField(2)
  data,
}
