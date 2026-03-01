import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChildPage extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>>? categories;
  final List<Map<String, dynamic>>? words;
  final String childName;
  final String ageRange;

  ChildPage({
    this.categories,
    this.words,
    required this.childName,
    required this.ageRange,
  });

  @override
  _ChildPageState createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  FlutterTts flutterTts = FlutterTts();

  Map<String, List<Map<String, dynamic>>> categories = {};
  String currentLanguage = "en-US";
  String sentence = "";

  @override
  void initState() {
    super.initState();
    // ensure categories available when words provided
    if (widget.categories == null && widget.words != null) {
      categories = {'General': widget.words!};
    }
    loadLanguage();
  }

  void addToSentence(String word) {
    setState(() {
      sentence += word + " ";
    });
  }

  bool useSentenceBuilder() {
    return widget.ageRange == "7-9" || widget.ageRange == "10-13";
  }

  void handleTap(String word) {
    if (widget.ageRange == "0-3" || widget.ageRange == "4-6") {
      speak(word);
    } else {
      setState(() {
        sentence += word + " ";
      });
    }
  }

  List<String> getSuggestions(String word) {
    switch (word.toLowerCase()) {
      case "i":
        return ["want", "feel", "need"];
      case "want":
        return ["water", "food", "play"];
      case "feel":
        return ["happy", "sad", "angry"];
      default:
        return [];
    }
  }

  int getGridCount() {
    switch (widget.ageRange) {
      case "0-3":
        return 2;
      case "4-6":
        return 3;
      case "7-9":
        return 3;
      case "10-13":
        return 4;
      default:
        return 2;
    }
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLang = prefs.getString("saved_language");
    if (savedLang != null) {
      currentLanguage = savedLang;
    }
    await flutterTts.setLanguage(currentLanguage);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1.0);
  }

  Future speak(String text) async {
    await flutterTts.speak(text);
  }


  @override
  Widget build(BuildContext context) {
    final flatWords = categories.values.expand((e) => e).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.childName}'s Board"),
      ),      backgroundColor: Colors.yellow.shade50,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (widget.ageRange == "7-9" || widget.ageRange == "10-13")
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  children: [
                    Text(
                      sentence,
                      style: TextStyle(fontSize: 22),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => speak(sentence),
                          child: Text("Speak"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              sentence = "";
                            });
                          },
                          child: Text("Clear"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: (() {
                  final predictedWords = getSuggestions(
                    sentence.trim().isEmpty ? '' : sentence.trim().split(" ").last
                  );
                  return predictedWords.map((word) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          sentence += " $word";
                        });
                      },
                      child: Text(word),
                    );
                  }).toList();
                })(),
              ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getGridCount(),
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: flatWords.length,
                itemBuilder: (context, index) {
                  final wordEntry = flatWords[index];
                  final text = wordEntry['text'] as String;
                  final iconData = wordEntry['icon'] as IconData;

                  return GestureDetector(
                    onTap: () => handleTap(text),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            iconData,
                            size: 60,
                            color: Colors.blue,
                          ),
                          SizedBox(height: 10),
                          Text(
                            text,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}