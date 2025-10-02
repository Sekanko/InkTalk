import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ink_talk/model/sentence.dart';
import 'package:ink_talk/service/sentence_service.dart';
import 'package:ink_talk/widgets/my_text_field.dart';

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
    _isButtonEnabled = widget.sentence != null;
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

  void _submit() {
    final currentSentence = widget.sentence;
    final title = _titleController.text;
    final content = _contentController.text;

    if (currentSentence == null) {
      _sentenceService.createSentence(title, content);
    } else {
      _sentenceService.updateSentence(currentSentence, title, content);
    }
    Navigator.pop(context);
  }

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
              onPressed: _isButtonEnabled ? _submit : null,

              child: const Text(
                "Zapisz",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              MyTextField(
                controller: _titleController,
                onChanged: (value) => _areTitleOrContnetEmpty(),
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Tytuł',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: MyTextField(
                  controller: _contentController,
                  onChanged: (value) => _areTitleOrContnetEmpty(),
                  expand: true,
                  decoration: InputDecoration(
                    labelText: 'Treść',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
