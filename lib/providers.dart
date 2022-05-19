import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/models/correct_wrong.dart';
import 'package:quiz/models/game_settings.dart';
import 'package:quiz/models/language.dart';

final counterProvider = StateProvider.autoDispose((ref) => 0);

final timerProvider =
    StateNotifierProvider<TimerNotifier, Map>((ref) => TimerNotifier());

class TimerNotifier extends StateNotifier<Map> {
  TimerNotifier() : super({'value': -1});

  final Ticker _ticker = Ticker();
  int _startValue = 0;
  StreamSubscription<int>? _streamSubscription;

  void start(int startValue) {
    _startValue = startValue;
    _streamSubscription = _ticker.tick(ticks: _startValue).listen((event) {
      state = {'startValue': _startValue, 'value': event};
      if (state['value'] == 0) {
        cancel();
      }
    });
  }

  void cancel() => _streamSubscription!.cancel();

  void pause() => _streamSubscription!.pause();

  void resume() => _streamSubscription!.resume();
}

class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
      const Duration(seconds: 1),
      (x) => ticks - x - 1,
    ).take(ticks);
  }
}

final correctWrongProvider = Provider((ref) => CorrectWrong());

final gameSettingProvider =
    StateNotifierProvider<GameSettingNotifier, GameSettings>(
        (ref) => GameSettingNotifier());

class GameSettingNotifier extends StateNotifier<GameSettings> {
  GameSettingNotifier()
      : super(GameSettings(
            category: "general",
            language: Language(language: "Türkçe", languageCode: "tr")));

  void update(GameSettings gameSettings) {
    state = GameSettings.fromJson(gameSettings.toJson());
  }

  Language get getLanguage =>
      state.language ?? Language(language: "Türkçe", languageCode: "tr");
}
