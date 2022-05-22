import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz/funcs.dart';
import 'package:quiz/hive.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/models/game_values.dart';
import 'package:quiz/values.dart';

class Firestore {
  static Future<GameValues> getGameValues({
    required context,
    required int updateId,
  }) async {
    try {
      var db = FirebaseFirestore.instance;
      var valueUpdateId = await db.collection("updateId").doc("updateId").get();
      int _updateId = valueUpdateId.data()?['updateId'] ?? 0;
      // if database is updated then it WONT return null;
      if (updateId >= _updateId) {
        return GameValues(databaseStatus: DatabaseStatus.nulll);
      }

      var valueGameValues = await db.collection("gameValues").get();

      if (valueGameValues.docs.isNotEmpty) {
        HiveDatabase().put("gameValues_update_date", DateTime.now());
        GameValues gameValues =
            GameValues.fromJson(valueGameValues.docs.first.data());
        List<Question> _questions = [];

        for (var i = 1; i < valueGameValues.docs.length; i++) {
          if (valueGameValues.docs.length - 1 == i) {
            HiveDatabase().put(
              "lastGameValueDoc",
              {
                'id': valueGameValues.docs[i].id,
                "length": valueGameValues.docs[i].data().toString().length
              },
            );
          }
          _questions +=
              GameValues.fromJson(valueGameValues.docs[i].data()).questions ??
                  [];
        }

        if (valueGameValues.docs.length == 1) {
          HiveDatabase().put(
            "lastGameValueDoc",
            {
              'id': valueGameValues.docs.first.id,
              "length": valueGameValues.docs.first.data().toString().length
            },
          );
        }

        if (gameValues.questions != null) {
          gameValues.questions = gameValues.questions! + _questions;
        } else {
          gameValues.questions = _questions;
        }

        gameValues.databaseStatus = DatabaseStatus.data;
        gameValues.updateId = _updateId;
        HiveDatabase().put("gameValues", gameValues);
        return gameValues;
      } else {
        return GameValues(databaseStatus: DatabaseStatus.nulll);
      }
    } on FirebaseException {
      return GameValues(databaseStatus: DatabaseStatus.error);
    } catch (e) {
      return GameValues(databaseStatus: DatabaseStatus.error);
    }
  }

  static Future deneme({
    required context,
    required Map<String, dynamic> map,
  }) async {
    try {
      var db = FirebaseFirestore.instance;

      var gameValues = db.collection("gameValues").doc("1");
      gameValues.set(map);
    } on FirebaseException {}
  }

  static Future<bool> addValueToList({
    required context,
    required List value,
    required String where,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("gameValues")
          .doc("1")
          .update({
        where: FieldValue.arrayUnion(value),
      });
      Funcs().showSnackBar(context, "Done!");
      return true;
    } on FirebaseException {
      Funcs().showSnackBar(context, "ERROR! TRY AGAIN");
      return false;
    } catch (e) {
      Funcs().showSnackBar(context, "ERROR! TRY AGAIN");
      return false;
    }
  }

  static Future<bool> sendValueToListWithDateTime({
    required context,
    required List value,
    required String where,
    String? collection,
    String? doc,
  }) async {
    DateTime now = DateTime.now();
    try {
      await FirebaseFirestore.instance
          .collection(collection ?? where)
          .doc(doc ?? "${now.year}-${now.month}")
          .update({
        where: FieldValue.arrayUnion(value),
      });

      return true;
    } on FirebaseException catch (e) {
      if (e.code == "not-found") {
        bool _result = await Firestore()
            ._putQuestion(now, context, value, where, doc, collection);
        return _result;
      }

      Funcs().showSnackBar(context, "ERROR!");
      return false;
    } catch (e) {
      Funcs().showSnackBar(context, "ERROR!");
      return false;
    }
  }

  Future<bool> _putQuestion(DateTime now, context, List value, String where,
      String? doc, String? collection) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection ?? where)
          .doc(doc ?? "${now.year}-${now.month}")
          .set({
        where: value,
      });
      return true;
    } on FirebaseException {
      Funcs().showSnackBar(context, "ERROR!");
      return false;
    } catch (e) {
      Funcs().showSnackBar(context, "ERROR!");
      return false;
    }
  }
}
