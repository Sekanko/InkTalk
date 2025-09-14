import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => prepareTTS());
  }

  Future<void> prepareTTS() async {
    await flutterTts.setLanguage("pl-PL");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVoice({"name": "pl-pl-x-bmg-local", "locale": "pl-PL"});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Wpisz tekst"),
          ),
          Wrap(
            alignment: WrapAlignment.center,
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
                child: const Text("Usuń ostatni wyraz"),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.clear();
                },
                child: const Text("Wyczyść"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String text = controller.text.trim();
                  if (text.isEmpty) return;
                  await flutterTts.speak(text);
                },
                child: const Text("Przeczytaj"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
