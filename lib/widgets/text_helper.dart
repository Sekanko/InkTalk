import 'package:flutter/material.dart';
import 'package:ink_talk/widgets/main_elevated_button.dart';
import 'package:intersperse/intersperse.dart';

class TextHelper extends StatelessWidget {
  final TextEditingController Function() getController;
  final List<Widget>? children;
  final double? gap;
  const TextHelper({
    super.key,
    required this.getController,
    this.children,
    this.gap,
  });

  MainElevatedButton _getClearButton() => MainElevatedButton(
    text: "Wyczyść",
    backgroundColor: Colors.red,
    onPressed: () => getController().clear(),
  );

  void _removeLastWord() {
    final controller = getController();

    String text = controller.text.trim();
    if (text.isEmpty) return;

    List<String> words = text.split(" ");
    words.removeLast();

    controller.text = words.join(" ");
  }

  MainElevatedButton _getDeleteLastWordButton() {
    return MainElevatedButton(
      text: "Usuń ostatni wyraz",
      backgroundColor: Colors.redAccent,
      onPressed: _removeLastWord,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizedBox = SizedBox(width: gap ?? 5.0);
    var allWidgets = [
      _getClearButton(),
      _getDeleteLastWordButton(),
      ...?children,
    ];
    allWidgets = allWidgets.map((widget) => Expanded(child: widget)).toList();
    allWidgets = allWidgets.intersperseOuter(sizedBox).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [...allWidgets],
    );
  }
}
