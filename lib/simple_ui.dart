import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz/UIs/custom_gradient_button.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/funcs.dart';
import 'package:quiz/values.dart';

class SimpleUI {
  static Widget spacer({
    required context,
    double height = 0,
    double width = 0,
  }) {
    height = MediaQuery.of(context).size.height / height;
    width = MediaQuery.of(context).size.width / width;
    return SizedBox(
      height: height,
      width: width,
    );
  }

  static Widget showDropdownButton({
    required context,
    required List<String> list,
    required Function(Object?) onChanged,
    required var dropdownValue,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return DropdownButton(
          value: dropdownValue,
          items: List.generate(list.length,
              (index) => _widgetDropDownMenuItem(value: list[index])),
          onChanged: (value) {
            setState(() {
              dropdownValue = value;
            });
            onChanged.call(value);
          },
        );
      },
    );
  }

  static DropdownMenuItem<String> _widgetDropDownMenuItem(
      {required String value}) {
    return DropdownMenuItem(
      value: value,
      child: Text(value.toUpperCase()),
    );
  }

  static Future showGeneralDialogFunc({
    required context,
    List<Widget>? buttons,
    bool? barrierDismissible,
    required String headText,
    String? textBelow,
    Widget? widget,
    Dialog? dialog,
  }) async {
    double _width =
        (kIsWeb && Funcs().getSmartPhoneOrTablet() == "desktop") ? 5 : 1.4;
    FocusScope.of(context).unfocus();
    Dialog _dialog = Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius1))),
      elevation: 0,
      child: WillPopScope(
        onWillPop: () async => barrierDismissible ?? true,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width / _width,
          decoration: const BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.all(Radius.circular(radius1)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  headText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                if (textBelow != null || textBelow == "")
                  SimpleUI.spacer(context: context, height: 60),
                textBelow == null
                    ? widget ?? const SizedBox.shrink()
                    : Text(
                        textBelow,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.normal),
                      ),
                SimpleUI.spacer(context: context, height: 30),
                Column(
                  children: buttons ?? [],
                )
              ],
            ),
          ),
        ),
      ),
    );
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (BuildContext context) => dialog ?? _dialog,
    );
  }

  Widget progressIndicator() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget widgetWithProgress(Widget widget, bool progress) {
    if (progress) {
      return progressIndicator();
    } else {
      return widget;
    }
  }

  Future showProgressIndicator(context) async {
    FocusScope.of(context).unfocus();
    if (ModalRoute.of(context)?.isCurrent ?? true) {
      await showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 500),
          context: context,
          pageBuilder: (_, __, ___) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Center(
                child: progressIndicator(),
              ),
            );
          });
    }
  }

  void showQuestionsDialog(
    context,
    String textBelow,
    Function() onContinue,
  ) {
    SimpleUI.showGeneralDialogFunc(
        context: context,
        headText: "Similar Questions Found!",
        barrierDismissible: true,
        textBelow: textBelow,
        buttons: [
          CustomGradientButton(
            text: "continue",
            onTap: () => onContinue.call(),
          ),
        ]);
  }
}
