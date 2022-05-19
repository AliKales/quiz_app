import 'package:flutter/material.dart';
import 'package:quiz/UIs/custom_gradient_button.dart';
import 'package:quiz/UIs/custom_textfield.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/firebase/firestore.dart';
import 'package:quiz/funcs.dart';
import 'package:quiz/hive.dart';
import 'package:quiz/models/game_values.dart';
import 'package:quiz/models/request_question.dart';
import 'package:quiz/simple_ui.dart';

class SendQuestionPage extends StatelessWidget {
  SendQuestionPage({Key? key}) : super(key: key);

  TextEditingController tECQuestion = TextEditingController();
  TextEditingController tECAnswer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color1,
        appBar: AppBar(
          backgroundColor: color1,
          elevation: 0,
          title: const Text("SEND A QUESTION"),
        ),
        body: body(context));
  }

  body(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Write your question with its answers and indicate the correct answer.",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: colorText),
            ),
            CustomTextField(
              labelText: "Question",
              maxLine: null,
              textEditingController: tECQuestion,
            ),
            CustomTextField(
              labelText: "Answers",
              maxLine: null,
              textEditingController: tECAnswer,
            ),
            SimpleUI.spacer(context: context, height: 13),
            CustomGradientButton(
              text: "SUBMIT",
              onTap: () => submit(context),
            ),
          ],
        ),
      ),
    );
  }

  //FUNCTIONSSSSSSSSSS

  Future submit(context) async {
    DateTime? _dateTime = HiveDatabase().get("lastTimeRequestQuestion");
    if (_dateTime != null && DateTime.now().difference(_dateTime).inDays <= 3) {
      Funcs().showSnackBar(
          context, "You can only submit one question every 3 days!");
      return;
    }

    if (tECQuestion.text.trim() == "" || tECAnswer.text.trim() == "") {
      Funcs()
          .showSnackBar(context, "Write down your question and its answers!");
      return;
    }
    GameValues? _gameValues = await HiveDatabase().getGameValues(context, true);
    if (_gameValues == null || (_gameValues.questions?.isEmpty ?? true)) {
      Funcs().showSnackBar(
          context, "You must play at least once before sending a question!");
      return;
    }
    List<String> result = Funcs.checkQuestionExisting(
        questions: _gameValues.questions, question: tECQuestion.text.trim());

    if (result.isNotEmpty) {
      String _questions = "";
      for (var i = 0; i < result.length; i++) {
        _questions += "${i.toInt() + 1}-) ${result[i]}\n------------\n";
      }
      SimpleUI().showQuestionsDialog(
        context,
        _questions,
        () => () {
          Navigator.pop(context);
          sendToDatabae(context);
        },
      );
    } else {
      sendToDatabae(context);
    }
  }

  Future sendToDatabae(context) async {
    SimpleUI().showProgressIndicator(context);
    bool _result = await Firestore.sendValueToListWithDateTime(
        where: "questionRequests",
        context: context,
        value: [
          RequestQuestion(
            question: tECQuestion.text.trim(),
            answers: tECAnswer.text.trim(),
          ).toJson()
        ]);

    Navigator.pop(context);
    if (_result) {
      HiveDatabase().put("lastTimeRequestQuestion", DateTime.now());
      Navigator.pop(context);
      Funcs().showSnackBar(context, "We received your question. Thanks!");
    }
  }
}
