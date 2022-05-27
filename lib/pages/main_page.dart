import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz/UIs/custom_gradient_button.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/funcs.dart';
import 'package:quiz/hive.dart';
import 'package:quiz/models/game_values.dart';
import 'package:quiz/pages/send_question_page.dart';
import 'package:quiz/pages/statistic_page.dart';
import 'package:quiz/simple_ui.dart';
import 'package:easy_localization/easy_localization.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool firstStart = HiveDatabase().get("firstStart");
    if (firstStart && kIsWeb && Funcs().getSmartPhoneOrTablet() == "android") {
      HiveDatabase().put("firstStart", false);
      Future.delayed(const Duration(seconds: 2)).then((value) {
        showPlaystore(context);
      });
    }
    return Scaffold(
      backgroundColor: color1,
      body: body(context),
    );
  }

  body(context) {
    if (kIsWeb) {
      if (Funcs().getSmartPhoneOrTablet() != "desktop") {
        return _widgetMainBody(context);
      }
      return LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: _widgetMainBody(context),
            ),
          ),
        );
      });
    } else {
      return _widgetMainBody(context);
    }
  }

  Padding _widgetMainBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SimpleUI.spacer(context: context, height: 70),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              iconSize: 36,
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                //Funcs().navigatorPush(context, const AdminPage());
                Funcs().navigatorPush(context,
                    StatisticPage(statistic: HiveDatabase().getStatistic()));
              },
              icon: const Icon(
                Icons.account_circle,
                color: colorWhite,
              ),
            ),
          ),
          const Spacer(),
          Text(
            Funcs().getGreeting(),
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: colorText, fontWeight: FontWeight.bold),
          ),
          SimpleUI.spacer(context: context, height: 40),
          Text(
            "1".tr(),
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: colorText),
          ),
          SimpleUI.spacer(context: context, height: 20),
          CustomGradientButton(
            text: "9".tr(),
            onTap: () async {
              SimpleUI().showProgressIndicator(context);
              GameValues? gameValues =
                  await HiveDatabase().getGameValues(context, false);
              Navigator.pop(context);
              if (gameValues != null) {
                if (gameValues.questions == null ||
                    gameValues.questions == [] ||
                    gameValues.categories == null ||
                    gameValues.categories!.isEmpty) {
                  Funcs().showSnackBar(context, "10".tr());
                } else {
                  Funcs.startQuiz(context: context, gameValues: gameValues);
                }
              }
            },
            disableMargin: true,
          ),
          const Spacer(),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                Funcs().navigatorPush(context, SendQuestionPage());
              },
              child: Text(
                "11".tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.grey.shade400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showPlaystore(context) {
    SimpleUI.showGeneralDialogFunc(
      context: context,
      headText: "12".tr(),
      textBelow: "13".tr(),
      buttons: [
        CustomGradientButton(text: "14".tr(), onTap: () {}),
      ],
    );
  }
}
