import 'package:flutter/material.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/values.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(radius1),
          ),
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.purple, Colors.cyan],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(radius1),
            ),
            color: Color(0xFF393939),
          ),
          child: Text(
            "QUIZ'İ BAŞLAT",
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(color: colorWhite, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
