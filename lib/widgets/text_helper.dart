import 'package:flutter/material.dart';

class TextHelper extends StatelessWidget {
  final TextEditingController Function() getController;
  const TextHelper({super.key, required this.getController});

  @override
  Widget build(BuildContext context) {
    final controller = getController();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            String text = controller.text.trim();
            if (text.isEmpty) return;

            List<String> words = text.split(" ");
            words.removeLast();

            text = words.join(" ");
            controller.text = text;
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 206, 38, 38),
            minimumSize: const Size(150, 40),
          ),

          child: const Text("Usuń ostatni wyraz"),
        ),
        ElevatedButton(
          onPressed: () {
            controller.clear();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 185, 13, 1),
            minimumSize: const Size(150, 40),
          ),
          child: const Text("Wyczyść"),
        ),
      ],
    );
  }
}
