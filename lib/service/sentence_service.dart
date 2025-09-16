import 'dart:async';
import 'package:hive/hive.dart';
import 'package:ink_talk/exceptions/create_sentence_exception.dart';
import 'package:ink_talk/model/sentence.dart';

class SentenceService {
  List<Sentence> _sentences = [];

  late final StreamController<List<Sentence>> _streamController;
  late final Box<Sentence> _box;

  static final SentenceService instance = SentenceService._sharedInstance();

  SentenceService._sharedInstance() {
    _box = Hive.box<Sentence>("sentences");
    _sentences = _box.values.toList();
    _streamController = StreamController<List<Sentence>>.broadcast(
      onListen: () {
        _streamController.sink.add(_sentences);
      },
    );
  }

  factory SentenceService() => instance;

  Stream<List<Sentence>> get allSentences => _streamController.stream;

  void cacheSentences() {
    final allSentences = _box.values;
    _sentences = allSentences.toList();
    _streamController.add(_sentences);
  }

  Future<void> createSentence(String title, String content) async {
    if (content.isEmpty || title.isEmpty) {
      throw CreateSentenceException(
        "Could not create sentence with title: $title and content $content",
      );
    }

    final sentence = Sentence(title: title, content: content);
    await _box.put(sentence.id, sentence);
    cacheSentences();
  }

  Future<void> deleteSentence(Sentence sentence) async {
    await sentence.delete();
    cacheSentences();
  }

  Future<void> updateSentence(
    Sentence sentence,
    String? title,
    String? content,
  ) async {
    sentence.title = title ?? sentence.title;
    sentence.content = content ?? sentence.content;

    await sentence.save();
    cacheSentences();
  }

  void dispose() {
    _streamController.close();
  }
}
