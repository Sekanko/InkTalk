import 'package:flutter/material.dart';
import 'package:ink_talk/model/sentence.dart';
import 'package:ink_talk/service/sentence_service.dart';
import 'package:ink_talk/widgets/text_helper.dart';

class AddOrUpdateSentence extends StatefulWidget {
  final Sentence? sentence;

  const AddOrUpdateSentence({super.key, this.sentence});

  @override
  State<AddOrUpdateSentence> createState() => _AddOrUpdateSentenceState();
}

class _AddOrUpdateSentenceState extends State<AddOrUpdateSentence> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final SentenceService _sentenceService;
  late final FocusNode _titleFocus;
  late final FocusNode _contentFocus;
  late bool _isButtonEnabled;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.sentence?.title ?? "",
    );
    _contentController = TextEditingController(
      text: widget.sentence?.content ?? "",
    );
    _sentenceService = SentenceService();
    _titleFocus = FocusNode();
    _contentFocus = FocusNode();
    _titleFocus.addListener(_onFocusChange);
    _contentFocus.addListener(_onFocusChange);

    _isButtonEnabled = widget.sentence != null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocus.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _areTitleOrContnetEmpty() {
    setState(() {
      _isButtonEnabled =
          _titleController.text.isNotEmpty &&
          _contentController.text.isNotEmpty;
    });
  }

  // void setControllerTexts(String title, String content) {
  //   _titleController.text = title;
  //   _contentController.text = content;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sentence != null ? "Edytuj" : "Nowe zdanie"),
        centerTitle: true,

        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 84, 193, 140),
                disabledBackgroundColor: Colors.blueGrey,
              ),
              onPressed: _isButtonEnabled
                  ? () {
                      final currentSentence = widget.sentence;
                      final title = _titleController.text;
                      final content = _contentController.text;

                      if (currentSentence == null) {
                        _sentenceService.createSentence(title, content);
                      } else {
                        _sentenceService.updateSentence(
                          currentSentence,
                          title,
                          content,
                        );
                      }
                      Navigator.pop(context);
                    }
                  : null,
              child: const Text(
                "Zapisz",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
        child: Column(
          children: [
            TextField(
              focusNode: _titleFocus,
              controller: _titleController,
              onChanged: (value) => _areTitleOrContnetEmpty(),
              decoration: InputDecoration(
                labelText: 'Tytuł',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              focusNode: _contentFocus,
              controller: _contentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) => _areTitleOrContnetEmpty(),
              decoration: InputDecoration(
                labelText: 'Treść',
                border: OutlineInputBorder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextHelper(
                getController: () {
                  if (_titleFocus.hasFocus) return _titleController;
                  if (_contentFocus.hasFocus) return _contentController;
                  return _titleController; // fallback
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
