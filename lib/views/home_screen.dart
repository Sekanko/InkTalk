import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ink_talk/utils/constants.dart';
import 'package:ink_talk/widgets/text_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _controller;
  late final FlutterTts _flutterTts;
  late final FocusNode _textFocus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _flutterTts = FlutterTts();
    _textFocus = FocusNode();

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
    _textFocus.dispose();
    super.dispose();
  }

  void focusAndMoveCursorToEnd() {
    _textFocus.requestFocus();
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
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
                  focusNode: _textFocus,
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
                          focusAndMoveCursorToEnd();
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
          TextHelper(getController: () => _controller),
        ],
      ),
    );
  }
}
