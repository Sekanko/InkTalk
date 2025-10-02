import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final bool? expand;
  final int minLines;
  final int maxLines;
  final InputDecoration? decoration;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function(PointerDownEvent)? onTapOutside;

  const MyTextField({
    super.key,
    this.focusNode,
    this.controller,
    this.expand,
    this.minLines = 1,
    this.maxLines = 10,
    this.decoration,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fontSize = (constraints.maxHeight / 3).clamp(12.0, 32.0);

        return TextField(
          focusNode: focusNode,
          controller: controller,
          stylusHandwritingEnabled: false,
          textAlignVertical: TextAlignVertical.top,
          decoration: decoration,
          expands: expand ?? false,
          minLines: expand == true ? null : minLines,
          maxLines: expand == true ? null : maxLines,
          onChanged: onChanged,
          onTap: onTap,
          onTapOutside: onTapOutside,
          style: TextStyle(fontSize: fontSize),
        );
      },
    );
  }
}
