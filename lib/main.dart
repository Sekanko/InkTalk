import 'package:flutter/material.dart';
import 'package:ink_talk/model/sentence.dart';
import 'package:ink_talk/views/home_screen.dart';
import 'package:ink_talk/views/sentence_views/add_or_update_sentence.dart';
import 'package:ink_talk/views/sentence_views/saved_sentences_views.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(SentenceAdapter());
  await Hive.openBox<Sentence>('sentences');

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InkTalk',
      theme: ThemeData.dark(),
      home: HomeScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case savedSentences:
            return MaterialPageRoute<String>(
              builder: (context) => const SavedSentencesViews(),
            );
          case sentenceRoute:
            final sentence = settings.arguments as Sentence?;
            return MaterialPageRoute(
              builder: (context) => AddOrUpdateSentence(sentence: sentence),
            );
          default:
            return MaterialPageRoute(builder: (context) => const HomeScreen());
        }
      },
    );
  }
}
