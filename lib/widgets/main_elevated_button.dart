import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MainElevatedButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Function()? onPressed;
  const MainElevatedButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
      child: AutoSizeText(
        text,
        textAlign: TextAlign.center,
        maxFontSize: 100,
        minFontSize: 8,
        maxLines: 2,
      ),
    );
  }
}
