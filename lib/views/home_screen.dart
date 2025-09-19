import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ink_talk/utils/constants.dart';
import 'package:ink_talk/widgets/main_elevated_button.dart';
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
      focusAndMoveCursorToEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      extendBody: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
            ],
          ),
          TextHelper(
            getController: () => _controller,
            gap: !isPortrait ? 20.0 : null,
            children: [
              MainElevatedButton(
                text: "Zapisane",
                backgroundColor: Colors.green,
                onPressed: _goToSavedSentences,
              ),
              if (!isPortrait)
                MainElevatedButton(
                  text: _getReadButtonText(),
                  backgroundColor: Colors.blue,
                  onPressed: _readCurrentText,
                ),
            ],
          ),
        ],
      ),

      floatingActionButton: isPortrait
          ? FloatingActionButton.extended(
              onPressed: _readCurrentText,
              backgroundColor: Colors.blue,
              label: Text(_getReadButtonText()),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
