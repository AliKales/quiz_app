import 'package:flutter/material.dart';
import 'package:quiz/colors.dart';
import 'package:quiz/values.dart';

class WidgetStatisticContainerAnimatedSize extends StatefulWidget {
  const WidgetStatisticContainerAnimatedSize({
    Key? key,
    required this.label,
    required this.label2,
    this.label2TextColor = colorText,
    this.label2FontWeight,
    this.details,
  }) : super(key: key);

  final String label;
  final String label2;
  final Color label2TextColor;
  final FontWeight? label2FontWeight;
  final List<String>? details;

  @override
  State<WidgetStatisticContainerAnimatedSize> createState() =>
      _WidgetStatisticContainerAnimatedSizeState();
}

class _WidgetStatisticContainerAnimatedSizeState
    extends State<WidgetStatisticContainerAnimatedSize> {
  bool progress1 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: color1Lighter,
        borderRadius: BorderRadius.all(
          Radius.circular(radius1),
        ),
      ),
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 600),
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: colorText, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.label2,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: widget.label2TextColor,
                        fontWeight:
                            widget.label2FontWeight ?? FontWeight.normal),
                  ),
                  !progress1
                      ? const SizedBox.shrink()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.details?.length ?? 0,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            return Text(
                              widget.details?[index] ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: colorText),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () {
              setState(() {
                progress1 = !progress1;
              });
            },
            icon: Icon(
              progress1 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: colorWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetStatisticContainer extends StatelessWidget {
  const WidgetStatisticContainer({
    Key? key,
    required this.label,
    required this.label2,
    this.label2TextColor = colorText,
    this.label2FontWeight,
  }) : super(key: key);

  final String label;
  final String label2;
  final Color label2TextColor;
  final FontWeight? label2FontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: color1Lighter,
        borderRadius: BorderRadius.all(
          Radius.circular(radius1),
        ),
      ),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: colorText, fontWeight: FontWeight.bold),
          ),
          Text(
            label2,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                color: label2TextColor,
                fontWeight: label2FontWeight ?? FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
