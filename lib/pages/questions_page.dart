import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/UIs/custom_gradient_button.dart';
import 'package:quiz/UIs/custom_textfield.dart';
import 'package:quiz/UIs/widget_timer.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/firebase/firestore.dart';
import 'package:quiz/funcs.dart';
import 'package:quiz/models/answer.dart';
import 'package:quiz/models/game_settings.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/models/question_report.dart';
import 'package:quiz/providers.dart';
import 'package:quiz/simple_ui.dart';
import 'package:quiz/values.dart';
import 'package:collection/collection.dart';

class QuestionsPage extends ConsumerWidget {
  QuestionsPage({
    Key? key,
    required this.questions,
  }) : super(key: key);

  final List<Question> questions;
  double width = 0;

  TextEditingController tECReport = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color1,
        leading: IconButton(
          onPressed: () {
            ref.read(timerProvider.notifier).cancel();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [
          //Skip button on App Bar
          TextButton(
            onPressed: () {
              if (questions.length != counter + 1) {
                ref.read(counterProvider.state).state++;
              }
            },
            child: const Text(
              "Skip",
              style: TextStyle(color: colorText),
            ),
          ),
        ],
      ),
      body: body(context, counter, ref),
    );
  }

  body(context, counter, ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetTimer(
              width: width,
              onDone: () async {
                await Future.delayed(const Duration(milliseconds: 1500));
                await Funcs().finishQuiz(context, ref);
                Navigator.pop(context);
              }),
          SimpleUI.spacer(context: context, height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Question ${int.parse(counter.toString()) + 1}/${questions.length}",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.grey),
              ),
              InkWell(
                onTap: () => _onReportTap(ref, context, counter),
                child: const Icon(
                  Icons.report,
                  color: colorWhite,
                  size: 30,
                ),
              )
            ],
          ),
          const Divider(),
          QuestionAnswersContainer(
            question: questions[counter],
            questionsLength: questions.length,
            counter: counter,
          ),
        ],
      ),
    );
  }

  //FUNCTIONSSSSSSSSSSSSSSSSSSSSSS

  Future _onReportTap(WidgetRef ref, context, int counter) async {
    ref.read(timerProvider.notifier).pause();
    bool result = false;

    await SimpleUI.showGeneralDialogFunc(
        context: context,
        headText: "Report Question",
        buttons: [
          CustomGradientButton(
            text: "Submit",
            onTap: () {
              result = true;
              Navigator.pop(context);
            },
          ),
        ],
        widget: CustomTextField(
          maxLine: null,
          maxLength: 200,
          text: "Your excuse",
          colorHint: Colors.grey,
          textEditingController: tECReport,
        ));

    if (result && tECReport.text.trim() != "") {
      List<Answer> _answers = questions[counter].answers?.first.answers ?? [];
      SimpleUI().showProgressIndicator(context);
      bool _result = await Firestore.sendValueToListWithDateTime(
          context: context,
          value: [
            QuestionReport(
                    report: tECReport.text.trim(),
                    question: questions[counter].question?.first.question,
                    answers:
                        "A-) ${_answers.first.answer}\nB-) ${_answers[1].answer}\nC-) ${_answers[2].answer}\nD-) ${_answers[3].answer}")
                .toJson(),
          ],
          where: "questionReports");
      Navigator.pop(context);

      Funcs().showSnackBar(context, _result ? "Sent!" : "ERROR!");
    }
    tECReport.clear();

    ref.read(timerProvider.notifier).resume();
  }
}

class QuestionAnswersContainer extends ConsumerStatefulWidget {
  const QuestionAnswersContainer({
    Key? key,
    required this.question,
    required this.questionsLength,
    required this.counter,
  }) : super(key: key);

  final Question question;
  final int questionsLength;
  final int counter;

  @override
  _QuestionAnswersContainerState createState() =>
      _QuestionAnswersContainerState();
}

class _QuestionAnswersContainerState
    extends ConsumerState<QuestionAnswersContainer> {
  int selectedAnswer = -1;
  int correctAnswer = -1;

  GameSettings? gameSettings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gameSettings = ref.read(gameSettingProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: colorMix,
          borderRadius: BorderRadius.all(
            Radius.circular(radius1),
          ),
        ),
        width: double.maxFinite,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  widget.question.question
                          ?.firstWhere((element) =>
                              element.language?.languageCode ==
                              gameSettings!.language!.languageCode)
                          .question ??
                      "",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: color1, fontWeight: FontWeight.bold),
                ),
                SimpleUI.spacer(context: context, height: 30),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      widget.question.answers?.first.answers?.length ?? 0,
                  itemBuilder: (context, index) {
                    return widgetAnswer(context, index);
                  },
                ),
                SimpleUI.spacer(context: context, height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetAnswer(BuildContext context, int index) {
    return InkWell(
      onTap: () => selectAnswer(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorMix2,
          border: Border.all(
            color: getBorderColor(index),
            width: 4,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(radius1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                getAnswerString(index),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //FUNCTIONSS
  Color getBorderColor(int index) {
    if (selectedAnswer == -1 && correctAnswer == -1) {
      return colorMix2;
    } else if (selectedAnswer == index && correctAnswer == -1) {
      return Colors.yellow.shade300;
    } else if (correctAnswer == index) {
      return Colors.green;
    } else if (selectedAnswer == index &&
        correctAnswer != -1 &&
        correctAnswer != index) {
      return Colors.red;
    } else {
      return colorMix2;
    }
  }

  Future selectAnswer(int index) async {
    if (selectedAnswer != -1) return;

    if ((widget.counter + 1) == widget.questionsLength) {
      ref.read(timerProvider.notifier).cancel();
    }
    setState(() {
      selectedAnswer = index;
    });
    await Future.delayed(const Duration(seconds: 1));
    correctAnswer = widget.question.answers?.first.answers
            ?.indexWhere((element) => element.id == widget.question.answer) ??
        -1;
    setState(() {});
    if (correctAnswer == index) {
      ref.read(correctWrongProvider).correct++;
    } else {
      ref.read(correctWrongProvider).wrong++;
    }
    await Future.delayed(const Duration(seconds: 2));
    selectedAnswer = -1;
    correctAnswer = -1;
    if (widget.counter + 1 == widget.questionsLength) {
      await Funcs().finishQuiz(context, ref);
      Navigator.pop(context);
    } else {
      ref.read(counterProvider.state).state++;
    }
  }

  String getAnswerString(int index) {
    String? label = widget.question.answers
            ?.firstWhereOrNull((element) =>
                element.language?.languageCode ==
                gameSettings?.language?.languageCode)
            ?.answers?[index]
            .answer ??
        "";

    switch (index) {
      case 0:
        return "A: $label";
      case 1:
        return "B: $label";
      case 2:
        return "C: $label";
      case 3:
        return "D: $label";
      default:
        return "";
    }
  }
}
