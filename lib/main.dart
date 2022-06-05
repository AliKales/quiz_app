import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
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
import 'package:easy_localization/easy_localization.dart';

import 'pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //MobileAds.instance.initialize();
  await Hive.initFlutter();
  await EasyLocalization.ensureInitialized();
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
  final box = await Hive.openBox('database');
  box.put("firstStart", true);
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('tr')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en'),
        child: const ProviderScope(child: MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      debugShowCheckedModeBanner: false,
      title: "Bi'Quiz",
      theme: ThemeData(
        fontFamily: "TiroBangla",
        primarySwatch: Colors.blue,
        dividerColor: Colors.grey,
        unselectedWidgetColor: colorWhite,
      ),
      home: const MainPage(),
    );
  }
}
