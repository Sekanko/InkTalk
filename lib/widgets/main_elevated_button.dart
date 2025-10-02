// ...existing code...
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MainElevatedButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Function()? onPressed;
  final Color? textColor;

  const MainElevatedButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height * 0.06;

        final double step = 0.1;
        final double rawFont = (availHeight * 0.45).clamp(8.0, 36.0);
        final double computedFontSize = (rawFont / step).round() * step;

        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            minimumSize: Size.fromHeight(availHeight),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          focusNode: FocusNode(skipTraversal: true),
          child: AutoSizeText(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontSize: computedFontSize),
            minFontSize: 10,
            maxLines: 2,
            stepGranularity: step,
            wrapWords: true,
          ),
        );
      },
    );
  }
}
// ...existing code...