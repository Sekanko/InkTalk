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
                  minLines: 3,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Wpisz tekst",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 8, width: 16),
              IntrinsicWidth(
                stepWidth: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        String text = _controller.text.trim();
                        if (text.isEmpty) return;
                        await _flutterTts.speak(text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 33, 82, 243),
                      ),
                      child: const Text("Przeczytaj"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.of(
                          context,
                        ).pushNamed<String>(savedSentences);
                        if (result != null) {
                          _controller.text = result;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 62, 143, 65),
                      ),

                      child: const Text("Zapisane zdania"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  String text = _controller.text.trim();
                  if (text.isEmpty) return;

                  List<String> words = text.split(" ");
                  words.removeLast();

                  text = words.join(" ");
                  _controller.text = text;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 206, 38, 38),
                  minimumSize: const Size(150, 40),
                ),

                child: const Text("Usuń ostatni wyraz"),
              ),
              ElevatedButton(
                onPressed: () {
                  _controller.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 185, 13, 1),
                  minimumSize: const Size(150, 40),
                ),
                child: const Text("Wyczyść"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
