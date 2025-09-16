import 'package:hive/hive.dart';
import 'package:ink_talk/exceptions/sentence_not_found_exception.dart';
import 'package:ink_talk/model/sentence.dart';
import 'package:ink_talk/exceptions/create_sentence_exception.dart';

class SentenceService {
  late final Box<Sentence> _box;

  static final SentenceService instance = SentenceService._sharedInstance();

  SentenceService._sharedInstance() {
    _box = Hive.box<Sentence>("sentences");
  }

  factory SentenceService() => instance;

  Future<void> addSentence(String title, String content) async {
    if (_box.containsKey(title)) {
      throw CreateSentenceException("Sentence with this title already exists");
    }

    final sentence = Sentence(title: title, content: content);
    await _box.put(sentence.id, sentence);
  }

  List<Sentence> getAllSentences() {
    return _box.values.toList();
  }

  Future<void> deleteSentence(String id) async {
    if (!_box.containsKey(id)) {
      throw SentenceNotFoundException("Sentence with id: $id not found");
    }

    await _box.delete(id);
  }

  Future<void> updateSentence(Sentence sentence) async {
    if (!_box.containsKey(sentence.id)) {
      throw SentenceNotFoundException(
        "Sentence with id ${sentence.id} not found",
      );
    }
    await _box.put(sentence.id, sentence);
  }
}
