import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz/UIs/custom_gradient_button.dart';
import 'package:quiz/UIs/custom_textfield.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/firebase/auth.dart';
import 'package:quiz/firebase/firestore.dart';
import 'package:quiz/funcs.dart';
import 'package:quiz/hive.dart';
import 'package:quiz/models/answer.dart';
import 'package:quiz/models/category.dart';
import 'package:quiz/models/game_values.dart';
import 'package:quiz/models/language.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/models/translate_answer.dart';
import 'package:quiz/models/translate_category.dart';
import 'package:quiz/models/translate_question.dart';
import 'package:quiz/pages/show_questions_page.dart';
import 'package:quiz/simple_ui.dart';
import 'package:collection/collection.dart';
import 'package:quiz/values.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  PageStatus pageStatus = PageStatus.loading;
  User? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => start());
  }

  start() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      if (user == null) {
        setState(() {
          pageStatus = PageStatus.signedOut;
        });
      } else {
        setState(() {
          pageStatus = PageStatus.signedIn;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color1,
        elevation: 0,
        title: const Text("Admin"),
      ),
      body: body(),
    );
  }

  body() {
    switch (pageStatus) {
      case PageStatus.loading:
        return SimpleUI().progressIndicator();
      case PageStatus.signedOut:
        return const BodySignedOut();
      case PageStatus.signedIn:
        return BodySignedIn(
          user: _user!,
        );
      default:
        return const Text("ERROR");
    }
  }
}

class BodySignedOut extends StatefulWidget {
  const BodySignedOut({Key? key}) : super(key: key);

  @override
  State<BodySignedOut> createState() => _BodySignedOutState();
}

class _BodySignedOutState extends State<BodySignedOut> {
  TextEditingController tECEmail = TextEditingController();

  TextEditingController tECPassword = TextEditingController();

  bool progress1 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          text: "EMAIL",
          textEditingController: tECEmail,
        ),
        CustomTextField(
          text: "PASSWORD",
          textEditingController: tECPassword,
        ),
        SimpleUI().widgetWithProgress(
            CustomGradientButton(text: "SIGN IN", onTap: () => signIn(context)),
            progress1),
        // SimpleUI().widgetWithProgress(
        //     CustomGradientButton(text: "SIGN UP", onTap: () => signUp(context)),
        //     progress1),
      ],
    );
  }

  Future signIn(context) async {
    setState(() {
      progress1 = true;
    });
    bool result = await Auth().signInWithEmail(
        tECEmail.text.trim(), tECPassword.text.trim(), context);
    if (mounted && !result) {
      setState(() {
        progress1 = false;
      });
    }
  }

  Future signUp(context) async {
    setState(() {
      progress1 = true;
    });
    bool result = await Auth.signUp(
        context: context,
        email: tECEmail.text.trim(),
        password: tECPassword.text.trim());
    if (mounted && !result) {
      setState(() {
        progress1 = false;
      });
    }
  }
}

class BodySignedIn extends StatefulWidget {
  const BodySignedIn({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<BodySignedIn> createState() => _BodySignedInState();
}

class _BodySignedInState extends State<BodySignedIn> {
  bool progress1 = false;
  GameValues? gameValues;
  Category? _category;
  int _valueRaios = 0;
  bool isQuestionChecked = false;
  Language language = Language(language: "Türkçe", languageCode: "tr");
  List<TextEditingController> tECSCategoryNQuestion = [];
  List<TextEditingController> tECSLanguage = [
    TextEditingController(),
    TextEditingController(),
  ];
  List<TextEditingController> tECSAnswers = [];
  List<Question> adminQuestions = HiveDatabase().getAdminQuestions();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HiveDatabase().getGameValues(context, true).then((value) {
      if (value != null) {
        gameValues = value;
        generateCategoryTECS();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //DropDownButton for changing language
            Align(
              alignment: Alignment.centerRight,
              child: SimpleUI.showDropdownButton(
                  context: context,
                  list: gameValues?.languages
                          ?.map((e) => e.language ?? "")
                          .toList() ??
                      [],
                  onChanged: (value) {
                    setState(() {
                      language = gameValues?.languages?.firstWhere(
                              (element) => element.language == value) ??
                          Language();
                    });
                  },
                  dropdownValue: language.language),
            ),
            //Text showing Email
            Text(
              widget.user.email!,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: colorText),
            ),
            //Button for Log Out
            SimpleUI().widgetWithProgress(
              TextButton(
                onPressed: () => logOut(context),
                child: Text(
                  "LOG OUT",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: colorText, fontWeight: FontWeight.bold),
                ),
              ),
              progress1,
            ),
            const Divider(
              thickness: 3,
            ),
            //ListView for show categories
            WidgetListViewShowTexts(
              texts: List.generate(
                  gameValues?.categories?.length ?? 0,
                  (index) =>
                      gameValues?.categories?[index].translateCategories
                          ?.firstWhereOrNull((element) =>
                              element.language?.languageCode ==
                              language.languageCode)
                          ?.category ??
                      ""),
            ),
            //ListView for TextFields for Categories
            widgetTextfields(width: width, height: height),
            //Button for ADD CATEGORY
            CustomGradientButton(
              text: "Add Category",
              onTap: () => addCategory(),
            ),
            const Divider(
              thickness: 3,
            ),
            //ListView for show Languages
            WidgetListViewShowTexts(
              texts: List.generate(gameValues?.languages?.length ?? 0,
                  (index) => gameValues?.languages?[index].language ?? ""),
            ),
            //TextField for Language
            CustomTextField(
              text: "Language",
              textEditingController: tECSLanguage[0],
            ),
            //TextField for LanguageCode
            CustomTextField(
              text: "LanguageCode",
              textEditingController: tECSLanguage[1],
            ),
            //Button for ADD LANGUAGE
            CustomGradientButton(
              text: "Add Language",
              onTap: () => addLanguage(),
            ),
            const Divider(
              thickness: 3,
            ),
            //DrowDown for Show Categories
            SimpleUI.showDropdownButton(
                context: context,
                list: gameValues?.categories
                        ?.map(
                            (e) => e.translateCategories?.first.category ?? "")
                        .toList() ??
                    [],
                onChanged: (value) {
                  setState(() {
                    _category = gameValues?.categories?.firstWhereOrNull(
                            (element) =>
                                element.translateCategories?.first.category ==
                                value) ??
                        Category();
                  });
                },
                dropdownValue: _category?.translateCategories?.first.category),
            //Text QUESTION
            text(text: "Question"),
            widgetTextButton(
              text: "SEE ADMIN QUESTIONS",
              func: () {
                Funcs().navigatorPush(
                  context,
                  ShowQuestionsPage(
                    questions: adminQuestions,
                  ),
                );
              },
            ),
            //ListView FOR QUESTİIN
            widgetTextfields(width: width, height: height, isCheck: true),
            //BUTTON for check questions
            widgetTextButton(
                text: "CHECK QUESTION",
                func: () {
                  _checkQuestionExisting();
                }),
            //Text answers
            text(text: "Answers"),
            SimpleUI.spacer(context: context, height: 17),
            //ListView for Answers
            SizedBox(
              height: height / 1.5,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: gameValues?.languages?.length ?? 0,
                itemBuilder: (context, index) {
                  int _index = (index.toInt() * 4);
                  int _oldIndex = ((index.toInt() - 1) * 4);
                  return WidgetTextFieldsForAnswer(
                    onCopy: (_val) {
                      tECSAnswers[_val + _index].text =
                          tECSAnswers[_val + _oldIndex].text.toString();
                    },
                    prefixIcon: _index == 0
                        ? null
                        : const Icon(
                            Icons.copy,
                            color: colorWhite,
                          ),
                    width: width,
                    label: gameValues?.languages?[index].language ?? "",
                    tEC1: tECSAnswers[1 + _index],
                    tEC2: tECSAnswers[2 + _index],
                    tEC3: tECSAnswers[3 + _index],
                    tEC4: tECSAnswers[4 + _index],
                  );
                },
              ),
            ),
            //Radios
            StatefulBuilder(builder: (context, _setState) {
              return Column(
                children: <Widget>[
                  for (int i = 1; i <= 4; i++)
                    ListTile(
                      title: Text(
                        getAnswerString(i - 1),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: colorText),
                      ),
                      leading: Radio(
                        value: i,
                        groupValue: _valueRaios,
                        activeColor: colorMix,
                        onChanged: (value) {
                          _setState(() {
                            _valueRaios = value as int;
                          });
                        },
                      ),
                    ),
                ],
              );
            }),
            //Button for ADD QUESTION
            CustomGradientButton(
              text: "Add question",
              onTap: () => addQuestion(),
              onLongPress: () {
                SimpleUI.showGeneralDialogFunc(
                  context: context,
                  headText: "SURE?",
                  textBelow: "Do you want to upload questions?",
                  buttons: [
                    CustomGradientButton(
                      text: "YES",
                      onTap: () {
                        Funcs().showSnackBar(context, "Press Long to continue");
                      },
                      onLongPress: () {
                        Navigator.pop(context);
                        uploadQuestions();
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  TextButton widgetTextButton({required String text, Function()? func}) {
    return TextButton(
        onPressed: () => func?.call(),
        child: Text(
          text,
          style: const TextStyle(color: colorMix),
        ));
  }

  Text text({required String text}) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline6!.copyWith(
            color: colorText,
          ),
    );
  }

  WidgetListViewRowTextFields widgetTextfields({
    required double width,
    required double height,
    bool isCheck = false,
  }) {
    return WidgetListViewRowTextFields(
      width: width,
      height: height,
      onTap: isCheck
          ? () {
              isQuestionChecked = false;
            }
          : null,
      length: gameValues?.languages?.length ?? 0,
      tECS: tECSCategoryNQuestion,
      labels: List.generate(gameValues?.languages?.length ?? 0,
          (index) => gameValues?.languages?[index].language ?? ""),
    );
  }

  //FUNCTIONSSSSSSSSSSSSSSSSSSSSSSSSSSSS
  Future uploadQuestions() async {
    //SimpleUI().showProgressIndicator(context);
    if (adminQuestions.isEmpty) {
      Funcs().showSnackBar(context, "There is no question to upload!!!");

      return;
    }

    Map _lastGameValueDoc = HiveDatabase().get("lastGameValueDoc") ?? {};
    List<Map<String, dynamic>> _listAdminQuestionsJson =
        adminQuestions.map((e) => e.toJson()).toList();

    String _docId = "";

    if (_lastGameValueDoc.isEmpty) {
      _lastGameValueDoc['id'] = "1";
      _docId = "1";
    } else {
      if ((_lastGameValueDoc['length'] +
              _listAdminQuestionsJson.toString().length) >=
          (1048576 - minByteForDB)) {
        int _int = (int.tryParse(_lastGameValueDoc['id']) ?? 0) + 1;
        _docId = ((int.tryParse(_lastGameValueDoc['id']) ?? 0) + 1).toString();
      } else {
        _docId = _lastGameValueDoc['id'];
      }
    }

    bool _result = await Firestore.sendValueToListWithDateTime(
        context: context,
        value: _listAdminQuestionsJson,
        where: "questions",
        doc: _docId,
        collection: "gameValues");

    Navigator.pop(context);
    if (_result) {
      if (_docId != _lastGameValueDoc['id']) {
        HiveDatabase().put("lastGameValueDoc", {
          'id': _docId,
          "length": _listAdminQuestionsJson.toString().length
        });
      }
      List<Question> _q = gameValues?.questions ?? [];
      _q += adminQuestions;
      gameValues?.questions = _q;
      HiveDatabase().put("gameValues", gameValues);
      HiveDatabase().delete("adminQuestions");
      adminQuestions = [];
      Funcs().showSnackBar(context, "Done");
    }
  }

  String getAnswerString(int index) {
    switch (index) {
      case 0:
        return "A";
      case 1:
        return "B";
      case 2:
        return "C";
      case 3:
        return "D";
      default:
        return "";
    }
  }

  void generateCategoryTECS() {
    tECSCategoryNQuestion = List.generate(
        gameValues?.languages?.length ?? 0, (index) => TextEditingController());

    //here it creats +1 text editing controller to avoid mess
    tECSAnswers = List.generate(((gameValues?.languages?.length ?? 0) * 4) + 1,
        (index) => TextEditingController());
    if (mounted) setState(() {});
  }

  void _checkQuestionExisting() {
    if (tECSCategoryNQuestion.first.text.trim() == "") {
      Funcs()
          .showSnackBar(context, "Please write down a Question in *ENGLISH*");
      return;
    }
    List<String> result = Funcs.checkQuestionExisting(
        question: tECSCategoryNQuestion.first.text.trim(),
        questions: gameValues?.questions ?? []);

    List<String> _result2 = Funcs.checkQuestionExisting(
        question: tECSCategoryNQuestion.first.text.trim(),
        questions: adminQuestions);

    result += _result2;

    if (result.isNotEmpty) {
      String _questions = "";
      for (var i = 0; i < result.length; i++) {
        _questions += "${i.toInt() + 1}-) ${result[i]}\n------------\n";
      }
      SimpleUI().showQuestionsDialog(context, _questions, () {
        return {
          Navigator.pop(context),
          isQuestionChecked = true,
        };
      });
    } else {
      isQuestionChecked = true;
    }
  }

  Future addQuestion() async {
    //here we define a text to first tEC which will nerver be used
    tECSAnswers.first.text = "admin-code";

    int index =
        tECSAnswers.indexWhere((element) => (element.text.trim() == ""));
    if (index != -1) {
      Funcs().showSnackBar(context, "Please fill each Answers");
      return;
    }

    int index2 = tECSCategoryNQuestion
        .indexWhere((element) => (element.text.trim() == ""));
    if (index2 != -1) {
      Funcs().showSnackBar(context, "Please fill each Questions");
      return;
    }

    if (_valueRaios == 0) {
      Funcs().showSnackBar(context, "Please select the correct answer");
      return;
    }

    if (_category == null) {
      Funcs().showSnackBar(context, "Please select a category");
      return;
    }

    if (!isQuestionChecked) {
      Funcs().showSnackBar(context, "Please check question existing first");
      return;
    }

    List<TranslateQuestion> _translateQuestions = List.generate(
      gameValues?.languages?.length ?? 0,
      (index) => TranslateQuestion(
        language: gameValues?.languages?[index],
        question: tECSCategoryNQuestion[index].text.trim(),
      ),
    );

    List<TranslateAnswer> _translateAnswers = List.generate(
      gameValues?.languages?.length ?? 0,
      (index) => TranslateAnswer(
        language: gameValues?.languages?[index],
        answers: List.generate(
          4,
          (_index) {
            int value = (index.toInt() * 4);
            return Answer(
              id: (_index.toInt() + 1),
              answer: tECSAnswers[(_index.toInt() + 1) + value].text.trim(),
            );
          },
        ),
      ),
    );

    Question _question = Question(
      catergory: _category?.translateCategories?.first.category,
      question: _translateQuestions,
      answer: _valueRaios,
      answers: _translateAnswers,
      id: Funcs.createId(
          context: context,
          personnelUsername: Auth().getEMail().split("@").first),
    );

    adminQuestions.add(_question);
    HiveDatabase().putAdminQuestion(adminQuestions);

    _category = null;
    for (var element in tECSCategoryNQuestion) {
      element.clear();
    }
    isQuestionChecked = false;
    for (var element in tECSAnswers) {
      element.clear();
    }
    _valueRaios = 0;
    setState(() {});
  }

  Future addLanguage() async {
    int index =
        tECSLanguage.indexWhere((element) => (element.text.trim() == ""));
    if (index != -1) {
      Funcs().showSnackBar(context, "Please fill each TextFields");
    } else {
      Language language = Language(
        language: tECSLanguage[0].text.trim(),
        languageCode: tECSLanguage[1].text.trim(),
      );
      SimpleUI().showProgressIndicator(context);
      bool result = await Firestore.addValueToList(
          context: context, value: [language.toJson()], where: "languages");
      Navigator.pop(context);
      if (result) {
        gameValues?.languages?.add(language);
        for (var element in tECSLanguage) {
          element.clear();
        }
        generateCategoryTECS();
      }
    }
  }

  Future addCategory() async {
    int index = tECSCategoryNQuestion
        .indexWhere((element) => (element.text.trim() == ""));
    if (index != -1) {
      Funcs().showSnackBar(context, "Please fill each translation");
    } else {
      Category category = Category(
        id: tECSCategoryNQuestion.first.text.toLowerCase().trim(),
        translateCategories: List.generate(
          gameValues?.languages?.length ?? 1,
          (index) => TranslateCategory(
              category: tECSCategoryNQuestion[index].text.trim(),
              language: gameValues?.languages?[index]),
        ),
      );
      SimpleUI().showProgressIndicator(context);
      bool result = await Firestore.addValueToList(
          context: context, value: [category.toJson()], where: "categories");
      Navigator.pop(context);
      if (result) {
        gameValues?.categories?.add(category);
        for (var element in tECSCategoryNQuestion) {
          element.clear();
        }
        setState(() {});
      }
    }
  }

  Future logOut(context) async {
    setState(() {
      progress1 = true;
    });
    bool result = await Auth().logOut(context);
    if (mounted && !result) {
      setState(() {
        progress1 = false;
      });
    }
  }
}

class WidgetTextFieldsForAnswer extends StatelessWidget {
  const WidgetTextFieldsForAnswer({
    Key? key,
    required this.width,
    required this.label,
    required this.tEC1,
    required this.tEC2,
    required this.tEC3,
    required this.tEC4,
    this.prefixIcon,
    this.onCopy,
  }) : super(key: key);

  final double width;
  final String label;
  final TextEditingController tEC1;
  final TextEditingController tEC2;
  final TextEditingController tEC3;
  final TextEditingController tEC4;
  final Widget? prefixIcon;
  final Function(int)? onCopy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: colorText),
            ),
            CustomTextField(
              prefixIcon: prefixIcon == null
                  ? null
                  : InkWell(onTap: () => onCopy?.call(1), child: prefixIcon),
              width: width / 1.5,
              labelText: "A: $label",
              textEditingController: tEC1,
              maxLine: null,
            ),
            CustomTextField(
              prefixIcon: prefixIcon == null
                  ? null
                  : InkWell(onTap: () => onCopy?.call(2), child: prefixIcon),
              width: width / 1.5,
              labelText: "B: $label",
              textEditingController: tEC2,
              maxLine: null,
            ),
            CustomTextField(
              prefixIcon: prefixIcon == null
                  ? null
                  : InkWell(onTap: () => onCopy?.call(3), child: prefixIcon),
              width: width / 1.5,
              labelText: "C: $label",
              textEditingController: tEC3,
              maxLine: null,
            ),
            CustomTextField(
              prefixIcon: prefixIcon == null
                  ? null
                  : InkWell(onTap: () => onCopy?.call(4), child: prefixIcon),
              width: width / 1.5,
              labelText: "D: $label",
              textEditingController: tEC4,
              maxLine: null,
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetListViewRowTextFields extends StatelessWidget {
  const WidgetListViewRowTextFields({
    Key? key,
    required this.width,
    required this.height,
    required this.length,
    required this.tECS,
    required this.labels,
    this.prefixIcon,
    this.onTap,
  }) : super(key: key);

  final double width;
  final double height;
  final int length;
  final List<TextEditingController> tECS;
  final List<String> labels;
  final dynamic prefixIcon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height / 4,
      child: ListView.builder(
        itemCount: length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: width / 1.5,
              child: CustomTextField(
                onTap: index == 0 ? onTap?.call() : null,
                prefixIcon: prefixIcon,
                labelText: labels[index],
                textEditingController: tECS[index],
                maxLine: null,
              ),
            ),
          );
        },
      ),
    );
  }
}

class WidgetListViewShowTexts extends StatelessWidget {
  const WidgetListViewShowTexts({
    Key? key,
    required this.texts,
  }) : super(key: key);

  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorMix2,
      width: double.maxFinite,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: texts.length,
        itemBuilder: (context, index) {
          return Text(
            texts[index],
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: colorText),
          );
        },
      ),
    );
  }
}

enum PageStatus { loading, signedOut, signedIn }
