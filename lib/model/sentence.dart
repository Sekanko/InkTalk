import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

@HiveType(typeId: 0)
class Sentence {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  Sentence({required this.title, required this.content}) : id = Uuid().v4();
}
