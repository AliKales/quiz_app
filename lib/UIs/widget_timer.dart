import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/funcs.dart';
import 'package:quiz/providers.dart';
import 'package:quiz/values.dart';

class WidgetTimer extends ConsumerWidget {
  const WidgetTimer({
    Key? key,
    required this.width,
    required this.onDone,
  }) : super(key: key);

  final double width;
  final Function() onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerProvider);
    if (timer['value'] == 1) {
      onDone.call();
    }
    return timer['value'] == -1
        ? const SizedBox.shrink()
        : LinearPercentIndicator(          
            barRadius: const Radius.circular(radius1),
            lineHeight: MediaQuery.of(context).size.height / 30,
            animation: true,
            animateFromLastPercent: true,
            percent:
                (timer['startValue'] - timer['value']) / timer['startValue'],
            linearGradient: const LinearGradient(
              colors: [color3, color2],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          );
  }
}
