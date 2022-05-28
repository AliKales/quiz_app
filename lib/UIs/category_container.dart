import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/funcs.dart';
import 'package:quiz/values.dart';

class CategoryContainer extends StatelessWidget {
  const CategoryContainer(
      {Key? key,
      required this.iconData,
      required this.label,
      required this.onTap,
      required this.isSelected,
      required this.categoryInEnglish,
      required this.value})
      : super(key: key);

  final String categoryInEnglish;
  final IconData iconData;
  final String label;
  final Function(String) onTap;
  final bool isSelected;
  final int value;

  @override
  Widget build(BuildContext context) {
    double _width =
        (kIsWeb && Funcs().getSmartPhoneOrTablet() == "desktop") ? 6 : 2.5;
    return InkWell(
      onTap: () => onTap.call(categoryInEnglish),
      child: Container(
        width: MediaQuery.of(context).size.width / _width,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color1Lighter,
          border: isSelected
              ? Border.all(
                  color: colorMix,
                  width: 4,
                )
              : null,
          borderRadius: const BorderRadius.all(
            Radius.circular(radius1),
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: colorText, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
