import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/funcs.dart';
import 'package:quiz/values.dart';

class CustomGradientButton extends StatelessWidget {
  const CustomGradientButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.disableMargin = false,
    this.onLongPress,
  }) : super(key: key);

  final String text;
  final Function() onTap;
  final Function()? onLongPress;
  final bool disableMargin;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => onTap.call(),
        onLongPress: () => onLongPress?.call(),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(radius1),
            ),
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.pink, Colors.purple, Colors.cyan],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: 12, horizontal: kIsWeb ? 20 : 0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(radius1),
              ),
              color: Color(0xFF393939),
            ),
            child: Funcs().isWeb(true)
                ? _text(context)
                : Row(
                    children: [
                      Expanded(
                        child: _text(context),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Text _text(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context)
          .textTheme
          .button!
          .copyWith(color: colorWhite, fontWeight: FontWeight.w600),
    );
  }
}
