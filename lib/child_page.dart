import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChildPage extends StatefulWidget {
  final List<Map<String, dynamic>> words;
  final String childName;

  ChildPage({required this.words, required this.childName});

  @override
  _ChildPageState createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  FlutterTts flutterTts = FlutterTts();

  // default language code
  String selectedLanguage = "en-IN";

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() async {
    // set initial language; examples:
    // await flutterTts.setLanguage("en-IN");  // Indian English
    // await flutterTts.setLanguage("en-AU");  // Australian
    // await flutterTts.setLanguage("en-GB");  // British
    // await flutterTts.setLanguage("en-US");  // American
    // await flutterTts.setLanguage("hi-IN");  // Hindi
    // await flutterTts.setLanguage("ta-IN");  // Tamil
    // await flutterTts.setLanguage("sv-SE");  // Swedish
    // await flutterTts.setLanguage("af-ZA");  // African

    await flutterTts.setLanguage(selectedLanguage);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1.0);

    // 🔹 Set Female Voice Example
    await flutterTts.setVoice({
      "name": "en-us-x-sfg#female",
      "locale": "en-US"
    });

    // 🎧 optionally print available voices for debugging
    var voices = await flutterTts.getVoices;
    print(voices);
  }

  Future speak(String text) async {
    await flutterTts.speak(text);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.childName}'s Board"),
        actions: [
          DropdownButton<String>(
            value: selectedLanguage,
            dropdownColor: Colors.white,
            underline: SizedBox(),
            items: [
              DropdownMenuItem(value: "en-IN", child: Text("Indian")),
              DropdownMenuItem(value: "en-GB", child: Text("British")),
              DropdownMenuItem(value: "en-AU", child: Text("Australian")),
              DropdownMenuItem(value: "en-US", child: Text("American")),
              DropdownMenuItem(value: "hi-IN", child: Text("Hindi")),
              DropdownMenuItem(value: "ta-IN", child: Text("Tamil")),
              DropdownMenuItem(value: "sv-SE", child: Text("Swedish")),
              DropdownMenuItem(value: "af-ZA", child: Text("African")),
            ],
            onChanged: (value) async {
              setState(() {
                selectedLanguage = value!;
              });
              await flutterTts.setLanguage(selectedLanguage);
            },
          ),
        ],
      ),
      backgroundColor: Colors.yellow.shade50,
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: widget.words.length,
        itemBuilder: (context, index) {
          final wordEntry = widget.words[index];
          final text = wordEntry['text'] as String;
          final iconData = wordEntry['icon'] as IconData;

          return GestureDetector(
            onTap: () => speak(text),
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
    );
  }
}