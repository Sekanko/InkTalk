import 'package:flutter/material.dart';

class MultipleButtons extends StatelessWidget {
  final List<Widget> children;
  final double? buttonHeight;

  const MultipleButtons({super.key, required this.children, this.buttonHeight});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    final double baseFactor = orientation == Orientation.landscape
        ? 0.05
        : 0.06;

    final raw = buttonHeight ?? MediaQuery.of(context).size.height * baseFactor;

    final double minH = 30.0;
    final double maxH = orientation == Orientation.landscape ? 40.0 : 84.0;

    final double h = raw.clamp(minH, maxH);

    final expandedButtons = children.map(
      (w) => Expanded(
        child: SizedBox(height: h, child: w),
      ),
    );

    final allWidgets = <Widget>[];
    for (var i = 0; i < expandedButtons.length; i++) {
      allWidgets.add(expandedButtons.elementAt(i));
      if (i != expandedButtons.length - 1) {
        allWidgets.add(const SizedBox(width: 10));
      }
    }

    return Row(children: [...allWidgets]);
  }
}
