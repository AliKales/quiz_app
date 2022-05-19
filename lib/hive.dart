import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz/firebase/firestore.dart';
import 'package:quiz/funcs.dart';
import 'package:quiz/models/correct_wrong.dart';
import 'package:quiz/models/game_values.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/models/statistic.dart';
import 'package:quiz/values.dart';

class HiveDatabase {
  GameValues? _gameValues;

  var box = Hive.box('database');

  Statistic getStatistic() {
    return box.get("statistic") ?? Statistic();
  }

  void put(String key, dynamic value) {
    box.put(key, value);
  }

  dynamic get(String key) {
    return box.get(key);
  }

  Future<GameValues?> getGameValues(context, bool direct) async {
    //firt it checks if GameValues was already gotten.
    if (_gameValues != null) return _gameValues!;

    //then it gets GameValues and Last Update Date
    GameValues? gameValues = box.get("gameValues");
    DateTime? dateTime = box.get("gameValues_update_date");

    if (direct) {
      String str = jsonEncode(gameValues?.toJson());
      int _bytes = str.length;


      //return gameValues;
      GameValues result =
          await Firestore.getGameValues(context: context, updateId: 0);
      if (result.databaseStatus == DatabaseStatus.data) {
        put("gameValues", result);
        return result;
      } else {
        return null;
      }
    }
    //if it needs to get values from Database, it does it
    if (dateTime == null ||
        DateTime.now().difference(dateTime).inDays >= dayToUpdate ||
        gameValues == null ||
        gameValues.questions == null ||
        gameValues.questions!.isEmpty) {
      GameValues result = await Firestore.getGameValues(
          context: context, updateId: gameValues?.updateId ?? 0);

      if (result.databaseStatus == DatabaseStatus.data) {
        _gameValues = result;
        return result;
      } else if (result.databaseStatus == DatabaseStatus.nulll &&
          gameValues != null) {
        _gameValues = result;
        return gameValues;
      } else {
        Funcs().showSnackBar(context, "ERROR!");
        return null;
      }
    } else {
      return gameValues;
    }
  }

  int? questionsLength() {
    if (_gameValues != null) {
      return _gameValues!.questions?.length;
    } else {
      GameValues? gameValues = box.get("gameValues");
      return gameValues?.questions?.length;
    }
  }

  DateTime? get getLastUpdateTime => box.get("gameValues_update_date");

  void update(CorrectWrong correctWrong) {
    Statistic statistic = getStatistic();
    statistic.correctAnswers += correctWrong.correct;
    statistic.wrongAnswers += correctWrong.wrong;
    statistic.totalQuestions += correctWrong.questionsLength;
    box.put("statistic", statistic);
  }

  List<Question> getAdminQuestions() {
    List q = box.get("adminQuestions") ?? [];
    List<Question> returnList = [];
    for (var item in q) {
      returnList.add(item);
    }
    return returnList;
  }

  void putAdminQuestion(List<Question> list) {
    box.put("adminQuestions", list);
  }

  void delete(String key) {
    box.delete(key);
  }
}
