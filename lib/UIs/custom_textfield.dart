import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      this.textEditingController,
      this.text,
      this.prefixIcon,
      this.onTap,
      this.keyboardType,
      this.obscureText,
      this.suffixIconFunction,
      this.suffixIcon,
      this.readOnly = false,
      this.labelText,
      this.inputFormatters,
      this.isOnlyEnglish = false,
      this.colorHint,
      this.isFilled = false,
      this.filledColor,
      this.textStyle,
      this.prefixText,
      this.maxLine = 1,
      this.maxLength,
      this.width})
      : super(key: key);

  final TextEditingController? textEditingController;
  final String? text;
  final String? labelText;
  final String? prefixText;
  final dynamic prefixIcon;
  final Function()? onTap;
  final TextInputType? keyboardType;

  final int? maxLine;

  ///* [obscureText] makes the textfield for password input
  ///* default is false
  final bool? obscureText;
  final bool readOnly;
  final bool? isFilled;

  final TextStyle? textStyle;

  final Color? colorHint;
  final Color? filledColor;

  ///* [isOnlyEnglish] default is false
  final bool isOnlyEnglish;

  ///* if [obscureText] is true then you must set [suffixIconFunction]
  final Function()? suffixIconFunction;

  ///* [iconButton] must be null if [obscureText] is active
  final Widget? suffixIcon;

  final List<TextInputFormatter>? inputFormatters;

  final double? width;

  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        maxLength: maxLength,
        autofocus: false,
        maxLines: maxLine,
        obscureText: obscureText ?? false,
        inputFormatters: isOnlyEnglish
            ? [
                FilteringTextInputFormatter(RegExp(r'^[a-zA-Z0-9_.\-=]+$'),
                    allow: true),
              ]
            : inputFormatters,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        style: textStyle ??
            Theme.of(context).textTheme.headline6!.copyWith(color: color3),
        cursorColor: colorHint ?? color3,
        controller: textEditingController,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: colorHint ?? Colors.white60),
          prefixText: prefixText,
          filled: isFilled,
          fillColor: filledColor,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: color3),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: color3),
          ),
          prefixIcon: prefixIcon,
          alignLabelWithHint: true,
          //if obscureText is null then it checks for another iconbutton. If both are null then it returns empty widget
          suffixIcon: obscureText == null
              ? suffixIcon
              : IconButton(
                  constraints: const BoxConstraints(),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: suffixIconFunction,
                  icon: !obscureText!
                      ? const Icon(
                          Icons.remove_red_eye,
                          color: color3,
                          size: 25,
                        )
                      : const Icon(
                          Icons.remove_red_eye_outlined,
                          color: color3,
                          size: 25,
                        ),
                ),
          hintText: text,
          hintStyle: TextStyle(color: colorHint ?? Colors.white60),
          isDense: true,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }
}
