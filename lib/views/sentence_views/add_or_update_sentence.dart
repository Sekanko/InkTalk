import 'package:flutter/material.dart';
import 'package:ink_talk/model/sentence.dart';
import 'package:ink_talk/service/sentence_service.dart';

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
  bool _isButtonEnabled = false;

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
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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
        actions: [
          TextButton(
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
            child: const Text("Zapisz"),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            onChanged: (value) => _areTitleOrContnetEmpty(),
          ),
          TextField(
            controller: _contentController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (value) => _areTitleOrContnetEmpty(),
          ),
        ],
      ),
    );
  }
}
