import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ink_talk/utils/constants.dart';
import 'package:ink_talk/widgets/main_elevated_button.dart';
import 'package:ink_talk/widgets/multiple_buttons.dart';
import 'package:ink_talk/widgets/my_text_field.dart';

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

  void _moveCursorToEnd() {
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  void _readCurrentText() async {
    String text = _controller.text.trim();
    if (text.isEmpty) return;
    await _flutterTts.speak(text);
  }

  String _getReadButtonText() => "Przeczytaj";

  void _goToSavedSentences() async {
    final result = await Navigator.of(
      context,
    ).pushNamed<String>(savedSentences);
    if (result != null) {
      _controller.text += " $result";
      _moveCursorToEnd();
    }
    _textFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Listener(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MultipleButtons(
                    children: [
                      MainElevatedButton(
                        text: "Zapisane zdania",
                        backgroundColor: Colors.green,
                        onPressed: _goToSavedSentences,
                      ),
                      MainElevatedButton(
                        text: _getReadButtonText(),
                        backgroundColor: Colors.blueAccent,
                        onPressed: _readCurrentText,
                      ),
                      MainElevatedButton(
                        text: "Wyszyść",
                        backgroundColor: Colors.red,
                        onPressed: () => _controller.clear(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: MyTextField(
                    focusNode: _textFocus,
                    controller: _controller,
                    expand: true,
                    onTapOutside: (_) => _textFocus.requestFocus(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
