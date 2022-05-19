import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/firebase_options.dart';
import 'package:quiz/models/answer.dart';
import 'package:quiz/models/category.dart';
import 'package:quiz/models/correct_wrong.dart';
import 'package:quiz/models/game_values.dart';
import 'package:quiz/models/language.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/models/statistic.dart';
import 'package:quiz/models/translate_answer.dart';
import 'package:quiz/models/translate_category.dart';
import 'package:quiz/models/translate_question.dart';
import 'package:quiz/values.dart';

import 'pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(AnswerAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(GameValuesAdapter());
  Hive.registerAdapter(StatisticAdapter());
  Hive.registerAdapter(LanguageAdapter());
  Hive.registerAdapter(TranslateAnswerAdapter());
  Hive.registerAdapter(TranslateCategoryAdapter());
  Hive.registerAdapter(TranslateQuestionAdapter());
  Hive.registerAdapter(DatabaseStatusAdapter());
  Hive.registerAdapter(CorrectWrongAdapter());
  var box = await Hive.openBox('database');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        dividerColor: Colors.grey,
        unselectedWidgetColor: colorWhite,
      ),
      home: const MainPage(),
    );
  }
}
