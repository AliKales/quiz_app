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
import 'package:easy_localization/easy_localization.dart';

class StatisticPage extends StatelessWidget {
  StatisticPage({Key? key, required this.statistic}) : super(key: key);

  final Statistic statistic;

  late int index = 0;

  late int _secretCode = 0;

  final GameValues? _gameValues = HiveDatabase().get("gameValues");
  final Map _correctWrongInfos = HiveDatabase().get("correctWrongInfos") ?? {};
  final ScrollController _sC = ScrollController();

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
          child: Text(
            "25".tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
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
          controller: _sC,
          child: Column(
            children: [
              SimpleUI.spacer(context: context, height: 65),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "26".tr(args: [
                    pointForEachCorrect.toString(),
                    wrongsToRemoveCorrects.toString(),
                    pointForEachCorrect.toString(),
                    notAnsweredQuestionPoint.toString()
                  ]),
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: colorText),
                ),
              ),
              ...getSpacers(context),
              WidgetStatisticContainer(
                label: "27".tr(),
                label2: statistic.getRank.name.toUpperCase(),
                label2TextColor: statistic.getColorOfRank,
                label2FontWeight: FontWeight.bold,
              ),
              ...getSpacers(context),
              WidgetStatisticContainerAnimatedSize(
                label: "28".tr() + ":",
                label2:
                    "${statistic.correctAnswers} ${"28".tr().toLowerCase()}",
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
                label: "29".tr() + ":",
                label2: "${statistic.wrongAnswers} ${"29".tr().toLowerCase()}",
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
                label: "30".tr() + ":",
                label2:
                    "${statistic.totalQuestions} ${"30".tr().toLowerCase()}",
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
                label: "31".tr(),
                label2: "${statistic.getPoint}",
              ),
              ...getSpacers(context),
              WidgetStatisticContainerAnimatedSize(
                onClicked: (value) async {
                  if (value) {
                    await Future.delayed(
                      const Duration(milliseconds: 600),
                    );
                    _sC.animateTo(_sC.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.ease);
                  }
                },
                label: "32".tr() + ":",
                label2: "33".tr(args: [
                  HiveDatabase().questionsLength().toString(),
                  Funcs().parseDateTime(HiveDatabase().getLastUpdateTime)
                ]),
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
