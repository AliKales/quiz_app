import 'package:flutter/material.dart';
import 'package:quiz/colors.dart';
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
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onTap.call(),
      onLongPress: () => onLongPress?.call(),
      child: Container(
        margin: disableMargin
            ? const EdgeInsets.symmetric(vertical: 16)
            : const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(radius1),
          ),
          gradient: LinearGradient(
            colors: [color3, color2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}