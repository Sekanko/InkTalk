import 'package:flutter/material.dart';
import 'package:ink_talk/utils/constants.dart';
import 'package:ink_talk/service/sentence_service.dart';

class SavedSentencesViews extends StatefulWidget {
  const SavedSentencesViews({super.key});

  @override
  State<SavedSentencesViews> createState() => _SavedSentencesViewsState();
}

class _SavedSentencesViewsState extends State<SavedSentencesViews> {
  late final SentenceService _sentenceService;
  final double _iconSize = 40;

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Zapisane zdania"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 62, 143, 65),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 44, 103, 239),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(sentenceRoute);
                },
                icon: Icon(Icons.add),
              ),
            ),
          ),
        ],
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
                        iconSize: _iconSize,
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed(sentenceRoute, arguments: sentence);
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.blue,
                      ),
                      IconButton(
                        iconSize: _iconSize,
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
    );
  }
}
