import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/UIs/category_container.dart';
import 'package:quiz/UIs/custom_gradient_button.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/hive.dart';
import 'package:quiz/models/correct_wrong.dart';
import 'package:quiz/models/game_settings.dart';
import 'package:quiz/models/game_values.dart';
import 'package:quiz/models/language.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/models/translate_category.dart';
import 'package:quiz/pages/questions_page.dart';
import 'package:quiz/providers.dart';
import 'package:quiz/values.dart';
import 'package:collection/collection.dart';

import 'simple_ui.dart';

class Funcs {
  String getGreeting() {
    int hour = DateTime.now().hour;
    String text = "";
    if (hour > 04 && hour < 12) {
      text = "Good Morning";
    } else if (hour > 12 && hour < 16) {
      text = "Good Afternoon";
    } else {
      text = "Good Evening";
    }
    return text;
  }

  Future<dynamic> navigatorPush(context, page) async {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    var object = await Navigator.push(context, route);
    return object;
  }

  void navigatorPushReplacement(context, page) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    Navigator.pushReplacement(context, route);
  }

  void showSnackBar(context, String text) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: color3,
      ),
    );
  }

  Future finishQuiz(context, WidgetRef ref) async {
    final CorrectWrong correctWrong = ref.read(correctWrongProvider);
    final int _intCorrect = correctWrong.correct.toInt();
    final int _intWrong = correctWrong.wrong.toInt();
    final int _intQuestionsLength = correctWrong.questionsLength.toInt();

    //Here it does the trick for detailed infos for correct, wrong, length
    String category = ref.read(gameSettingProvider).category ?? "";
    category = category.toLowerCase();
    Map _correctWrongInfos = HiveDatabase().get("correctWrongInfos") ?? {};

    CorrectWrong _cWInfos = _correctWrongInfos[category] ?? CorrectWrong();
    _cWInfos.correct += _intCorrect;
    _cWInfos.wrong += _intWrong;
    _cWInfos.questionsLength += _intQuestionsLength;

    _correctWrongInfos[category] = _cWInfos;

    HiveDatabase().put("correctWrongInfos", _correctWrongInfos);

    HiveDatabase().update(correctWrong);
    //Until here......................................

    await SimpleUI.showGeneralDialogFunc(
      context: context,
      barrierDismissible: false,
      headText: "Quiz has finished!",
      textBelow:
          "$_intCorrect correct, $_intWrong wrong out of $_intQuestionsLength questions",
      buttons: [
        CustomGradientButton(
          text: "Okay",
          disableMargin: false,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  static Future startQuiz({
    required context,
    required GameValues gameValues,
  }) async {
    String selectedCategory = "";
    int _selectedCategoryNum = -1;
    Dialog dialogGameSetting = Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius1))),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width / 1.4,
        decoration: const BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.all(Radius.circular(radius1)),
        ),
        child: Consumer(builder: (context, ref, _) {
          GameSettings gameSettings = ref.watch(gameSettingProvider);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "GAME SETTINGS",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SimpleUI.spacer(context: context, height: 60),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Category: ${gameValues.categories?.firstWhereOrNull((element) => element.translateCategories?.first.category == selectedCategory)?.translateCategories?.firstWhereOrNull((element) => element.language?.languageCode == gameSettings.language?.languageCode)?.category ?? "---"}",
                  style: Theme.of(context).textTheme.headline6!.copyWith(),
                ),
              ),
              SimpleUI.spacer(context: context, height: 70),
              SizedBox(
                height: MediaQuery.of(context).size.width / 3,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: gameValues.categories!.length,
                    itemBuilder: (context, index) {
                      TranslateCategory? translateCategory = gameValues
                          .categories![index].translateCategories
                          ?.firstWhereOrNull((element) =>
                              element.language?.languageCode ==
                              gameSettings.language?.languageCode);
                      return CategoryContainer(
                        categoryInEnglish: gameValues.categories![index]
                                .translateCategories?.first.category ??
                            "",
                        iconData: Icons.abc,
                        label: translateCategory?.category ?? "",
                        value: index,
                        isSelected: index == _selectedCategoryNum,
                        onTap: (value) {
                          _selectedCategoryNum = index;
                          gameSettings.category = value;
                          selectedCategory = value;
                          ref
                              .read(gameSettingProvider.notifier)
                              .update(gameSettings);
                        },
                      );
                    },
                  ),
                ),
              ),
              SimpleUI.spacer(context: context, height: 70),
              SimpleUI.showDropdownButton(
                  context: context,
                  dropdownValue: gameSettings.language?.language ?? "Türkçe",
                  onChanged: (value) {
                    gameSettings.language = gameValues.languages?.firstWhere(
                            (element) => element.language == value) ??
                        Language(language: "Türkçe", languageCode: "tr");
                    ref.read(gameSettingProvider.notifier).update(gameSettings);
                  },
                  list: gameValues.languages
                          ?.map((e) => e.language ?? "")
                          .toList() ??
                      []),
              SimpleUI.spacer(context: context, height: 70),
              CustomGradientButton(
                text: "START",
                onTap: () {
                  Navigator.pop(context);
                  var _questions = <Question>[];

                  _questions = gameValues.questions!
                      .where((element) =>
                          element.catergory?.toLowerCase() ==
                          gameValues.categories?[_selectedCategoryNum].id
                              ?.toLowerCase())
                      .toList();
                  if (_questions.isEmpty) {
                    Funcs().showSnackBar(context, "No question found!");
                    return;
                  }

                  _questions.shuffle();
                  int _end = _questions.length <= 21 ? _questions.length : 21;
                  var questions = _questions.getRange(0, _end).toList();
                  print(questions.length);
                  ref.read(correctWrongProvider).reset(questions.length);
                  ref.read(timerProvider.notifier).start(questions.length*secondPerQuestion);
                  Funcs().navigatorPush(
                      context, QuestionsPage(questions: questions));
                },
              ),
            ],
          );
        }),
      ),
    );
    SimpleUI.showGeneralDialogFunc(
      context: context,
      headText: "Aha",
      dialog: dialogGameSetting,
    );
  }

  static String createId({
    required final context,
    required final String personnelUsername,
  }) {
    DateTime currentGlobalTime = DateTime.now();
    return "$personnelUsername-${currentGlobalTime.year}-${currentGlobalTime.month}-${currentGlobalTime.day}";
  }

  String parseDateTime(DateTime? dateTime) {
    if (dateTime == null) return "null";
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }

  static List<String> checkQuestionExisting({
    required List<Question>? questions,
    required String question,
  }) {
    List<String> result = [];
    String _question = Funcs()._removeCertainWords(question.toLowerCase());
    List<String> wordsFromUser = _question.split(" ");
    for (var i = 0; i < questions!.length; i++) {
      int counter = 0;
      String mainString =
          questions[i].question?.first.question?.toLowerCase() ?? "";
      String q = mainString;

      q = Funcs()._removeCertainWords(q);

      for (var item in wordsFromUser) {
        if (q.contains(item)) counter++;
      }

      if ((100 * (counter / q.split(" ").length)) >= rateOfMatchingWords) {
        result.add(mainString);
      }
    }
    return result;
  }

  String _removeCertainWords(String value) {
    List<String> words = wordsToBeDeleted.split(" ");
    List<String> _value = value.split(" ");
    for (var item in words) {
      _value.removeWhere((element) => element == item);
    }
    return _value.join(" ");
  }

  Future<String> sortListWithCounts(List<Question> list) async {
    String returnString = "";
    Map values = {};
    for (var item in list) {
      if (values.keys.contains(item.catergory)) {
        values[item.catergory] += 1;
      } else {
        values[item.catergory] = 1;
      }
    }
    for (var item in values.keys) {
      returnString += "$item: ${values[item]}\n";
    }
    return returnString;
  }
}
