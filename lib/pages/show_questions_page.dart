import 'package:flutter/material.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/funcs.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/values.dart';
import 'package:easy_localization/easy_localization.dart';

class ShowQuestionsPage extends StatelessWidget {
  const ShowQuestionsPage({Key? key, required this.questions})
      : super(key: key);

  final List<Question> questions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color1,
        title: Text("24".tr()),
      ),
      body: body(context),
    );
  }

  body(context) {
    return Column(
      children: [
        FutureBuilder(
          future: Funcs().sortListWithCounts(questions),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                "\n${questions.length} ${"17".tr().toLowerCase()}\n" + (snapshot.data as String),
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: colorText),
              );
            }
            return Text(
              "${questions.length} ${"17".tr().toLowerCase()}",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: colorText),
            );
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: colorMix2,
                  borderRadius: BorderRadius.all(
                    Radius.circular(radius1),
                  ),
                ),
                child: Text(
                  "${index + 1}-) " +
                      (questions[index].question?.first.question ?? ""),
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: colorText),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
