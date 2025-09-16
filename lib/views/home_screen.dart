import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ink_talk/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => prepareTTS());
  }

  Future<void> prepareTTS() async {
    await _flutterTts.setLanguage("pl-PL");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVoice({
      "name": "pl-pl-x-bmg-local",
      "locale": "pl-PL",
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: "Wpisz tekst",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String text = _controller.text.trim();
                  if (text.isEmpty) return;
                  await _flutterTts.speak(text);
                },
                child: const Text("Przeczytaj"),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.of(
                    context,
                  ).pushNamed<String>(savedSentences);
                  if (result != null) {
                    _controller.text = result;
                  }
                },
                child: const Text("Zapisane zdania"),
              ),
              ElevatedButton(
                onPressed: () {
                  String text = _controller.text.trim();
                  if (text.isEmpty) return;

                  List<String> words = text.split(" ");
                  words.removeLast();

                  text = words.join(" ");
                  _controller.text = text;
                },
                child: const Text("Usuń ostatni wyraz"),
              ),
              ElevatedButton(
                onPressed: () {
                  _controller.clear();
                },
                child: const Text("Wyczyść"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
