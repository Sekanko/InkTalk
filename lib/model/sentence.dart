import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'sentence.g.dart';

@HiveType(typeId: 0)
class Sentence extends HiveObject {
  Sentence({required this.title, required this.content}) : id = Uuid().v4();

  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String content;
}
