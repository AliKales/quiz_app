import 'package:flutter/material.dart';
import 'package:quiz/UIs/widget_statistic_container.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/funcs.dart';
import 'package:quiz/hive.dart';
import 'package:quiz/models/correct_wrong.dart';
import 'package:quiz/models/game_values.dart';
import 'package:quiz/models/statistic.dart';
import 'package:quiz/pages/admin_page.dart';
import 'package:quiz/simple_ui.dart';
import 'package:quiz/values.dart';

class StatisticPage extends StatelessWidget {
  StatisticPage({Key? key, required this.statistic}) : super(key: key);

  final Statistic statistic;

  late int index = 0;

  late int _secretCode = 0;

  final GameValues? _gameValues = HiveDatabase().get("gameValues");
  final Map _correctWrongInfos = HiveDatabase().get("correctWrongInfos") ?? {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            _secretCode++;
            if (_secretCode == 10) {
              Navigator.pop(context);
              Funcs().navigatorPush(context, const AdminPage());
            }
          },
          child: const Text(
            "Statistics",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: color1,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: body(context),
    );
  }

  body(context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SimpleUI.spacer(context: context, height: 65),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Each correct answer; +$pointForEachCorrect\nEvery $wrongsToRemoveCorrects wrong answers; -$pointForEachCorrect\nEach not answered question; -$notAnsweredQuestionPoint",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: colorText),
                ),
              ),
              ...getSpacers(context),
              WidgetStatisticContainer(
                label: "Rank:",
                label2: statistic.getRank.name.toUpperCase(),
                label2TextColor: statistic.getColorOfRank,
                label2FontWeight: FontWeight.bold,
              ),
              ...getSpacers(context),
              WidgetStatisticContainerAnimatedSize(
                label: "Correct Answers:",
                label2: "${statistic.correctAnswers} correct answer",
                details: List.generate(
                  _gameValues?.categories?.length ?? 0,
                  (index) {
                    String category = _gameValues?.categories?[index].id ?? "";
                    CorrectWrong? correctWrong = _correctWrongInfos[category];
                    return "$category: ${correctWrong?.correct ?? 0}";
                  },
                ),
              ),
              ...getSpacers(context),
              WidgetStatisticContainerAnimatedSize(
                label: "Wrong Answers:",
                label2: "${statistic.wrongAnswers} wrong answer",
                details: List.generate(
                  _gameValues?.categories?.length ?? 0,
                  (index) {
                    String category = _gameValues?.categories?[index].id ?? "";
                    CorrectWrong? correctWrong = _correctWrongInfos[category];
                    return "$category: ${correctWrong?.wrong ?? 0}";
                  },
                ),
              ),
              ...getSpacers(context),
              WidgetStatisticContainerAnimatedSize(
                label: "Total Questions:",
                label2: "${statistic.totalQuestions} total question",
                details: List.generate(
                  _gameValues?.categories?.length ?? 0,
                  (index) {
                    String category = _gameValues?.categories?[index].id ?? "";
                    CorrectWrong? correctWrong = _correctWrongInfos[category];
                    return "$category: ${correctWrong?.questionsLength ?? 0}";
                  },
                ),
              ),
              ...getSpacers(context),
              WidgetStatisticContainer(
                label: "Score:",
                label2: "${statistic.getPoint}",
              ),
              ...getSpacers(context),
              WidgetStatisticContainerAnimatedSize(
                label: "Questions:",
                label2:
                    "Length: ${HiveDatabase().questionsLength()}\nLast Update: ${Funcs().parseDateTime(HiveDatabase().getLastUpdateTime)}",
                details: List.generate(
                  _gameValues?.categories?.length ?? 0,
                  (index) {
                    String category = _gameValues?.categories?[index].id ?? "";
                    int _int = _gameValues?.questions
                            ?.where((element) =>
                                element.catergory?.toLowerCase() == category)
                            .toList()
                            .length ??
                        0;

                    return "$category: $_int";
                  },
                ),
              ),
              SimpleUI.spacer(context: context, height: 65),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getSpacers(context) {
    return [
      SimpleUI.spacer(context: context, height: 65),
      const Divider(),
      SimpleUI.spacer(context: context, height: 65),
    ];
  }
}
