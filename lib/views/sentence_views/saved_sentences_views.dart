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
      appBar: AppBar(title: Text("Zapisane zdania")),
      body: StreamBuilder(
        stream: _sentenceService.allSentences,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Brak zapisanych zdań"));
          }

          final allSentences = snapshot.data!;
          return ListView.builder(
            itemCount: allSentences.length,
            itemBuilder: (context, index) {
              final sentence = allSentences[index];
              return ListTile(
                title: Text(sentence.title),
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
