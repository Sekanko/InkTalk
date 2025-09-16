import 'package:flutter/material.dart';
import 'package:ink_talk/constants.dart';
import 'package:ink_talk/service/sentence_service.dart';

class SavedSentencesViews extends StatefulWidget {
  const SavedSentencesViews({super.key});

  @override
  State<SavedSentencesViews> createState() => _SavedSentencesViewsState();
}

class _SavedSentencesViewsState extends State<SavedSentencesViews> {
  late final SentenceService _sentenceService;

  @override
  void initState() {
    super.initState();
    _sentenceService = SentenceService();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zapisane zdania"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 62, 143, 65),
      ),
      body: StreamBuilder(
        stream: _sentenceService.allSentences,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allSentences = snapshot.data!;
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Brak zapisanych zdań"));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: ListView.builder(
              itemCount: allSentences.length + 1,
              itemBuilder: (context, index) {
                if (index == allSentences.length) {
                  return const SizedBox(height: 80);
                }

                final sentence = allSentences[index];
                return ListTile(
                  title: Text(
                    sentence.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                  ),
                  subtitle: Text(
                    sentence.content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                  ),
                  onTap: () {
                    Navigator.pop(context, sentence.content);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed(sentenceRoute, arguments: sentence);
                        },
                        icon: Icon(Icons.settings),
                        color: Colors.blue,
                      ),
                      IconButton(
                        onPressed: () {
                          _sentenceService.deleteSentence(sentence);
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(sentenceRoute);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
