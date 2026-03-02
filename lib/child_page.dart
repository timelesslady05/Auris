import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_page.dart';

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
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.categories == null && widget.words != null) {
      categories = {'General': widget.words!};
    } else if (widget.categories != null) {
      categories = widget.categories!;
    }
    loadLanguage();

    _textController.addListener(() {
      if (sentence != _textController.text) {
        setState(() {
          sentence = _textController.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateText(String newText) {
    _textController.text = newText;
    _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
  }

  void addToSentence(String word) {
    _updateText(sentence + word + " ");
  }

  bool useSentenceBuilder() {
    return widget.ageRange == "7-9" || widget.ageRange == "10-13" || widget.ageRange == "14-16";
  }

  void handleTap(String word) {
    if (widget.ageRange == "0-3" || widget.ageRange == "4-6") {
      speak(word);
    } else {
      _updateText(sentence + word + " ");
    }
  }

  List<String> getSuggestions(String word) {
    String w = word.toLowerCase();
    if (w.isEmpty) return ["I", "Yes", "No", "Help"];
    
    switch (w) {
      case "i": return ["want", "feel", "need", "think", "am"];
      case "want": return ["water", "food", "play", "to go", "sleep"];
      case "feel": return ["happy", "sad", "angry", "tired", "sick"];
      case "need": return ["help", "toilet", "break", "medicine"];
      case "can": return ["we", "i", "you"];
      case "go": return ["outside", "home", "to bed"];
      case "have": return ["a snack", "lunch", "dinner"];
      default: return ["and", "then", "please"];
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
      case "14-16":
        return 4;
      default:
        return 2;
    }
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLang = prefs.getString("saved_language") ?? prefs.getString("selectedLanguage");
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

  // Color palette for word cards
  static const List<List<Color>> _cardGradients = [
    [Color(0xFF667eea), Color(0xFF764ba2)],
    [Color(0xFF43e97b), Color(0xFF38f9d7)],
    [Color(0xFFfa709a), Color(0xFFfee140)],
    [Color(0xFF4facfe), Color(0xFF00f2fe)],
    [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
    [Color(0xFFffecd2), Color(0xFFfcb69f)],
  ];

  @override
  Widget build(BuildContext context) {
    final flatWords = categories.values.expand((e) => e).toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF2D3B89).withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: Color(0xFF2D3B89), size: 18),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.childName}'s Board",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3B89),
                          ),
                        ),
                        Text(
                          "Communication Board",
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Color(0xFFA3AED0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ProfilePage())),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF2D3B89).withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.person_outline, color: Color(0xFF2D3B89), size: 22),
                    ),
                  ),
                ],
              ),
            ),

            // Sentence builder for older children
            if (widget.ageRange == "7-9" || widget.ageRange == "10-13" || widget.ageRange == "14-16")
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF2D3B89).withOpacity(0.08),
                        blurRadius: 20,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFF4F7FE),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextField(
                          controller: _textController,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Color(0xFF2D3B89),
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: "Tap words or type a sentence...",
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Color(0xFFA3AED0),
                              fontWeight: FontWeight.normal,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: null,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2D3B89),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: Icon(Icons.volume_up, size: 20),
                              label: Text("Speak", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                              onPressed: () => speak(sentence),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Color(0xFF2D3B89),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(color: Color(0xFFE0E5F2)),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                              ),
                              icon: Icon(Icons.clear, size: 20),
                              label: Text("Clear", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                              onPressed: () {
                                _textController.clear();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Suggestions
            if (widget.ageRange == "7-9" || widget.ageRange == "10-13" || widget.ageRange == "14-16")
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Wrap(
                  spacing: 8,
                  children: (() {
                    final predictedWords = getSuggestions(
                      sentence.trim().isEmpty ? '' : sentence.trim().split(" ").last
                    );
                    return predictedWords.map((word) {
                      return ActionChip(
                        label: Text(word, style: GoogleFonts.poppins(
                          color: Color(0xFF2D3B89),
                          fontWeight: FontWeight.w500,
                        )),
                        backgroundColor: Color(0xFF4A90E2).withOpacity(0.12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide.none,
                        ),
                        onPressed: () {
                          _updateText(sentence + (sentence.endsWith(" ") ? "" : " ") + word + " ");
                        },
                      );
                    }).toList();
                  })(),
                ),
              ),

            SizedBox(height: 8),

            // Word grid
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  padding: EdgeInsets.only(bottom: 20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getGridCount(),
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: flatWords.length,
                  itemBuilder: (context, index) {
                    final wordEntry = flatWords[index];
                    final text = wordEntry['text'] as String;
                    final iconData = wordEntry['icon'] as IconData;
                    final gradient = _cardGradients[index % _cardGradients.length];

                    return GestureDetector(
                      onTap: () => handleTap(text),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              gradient[0].withOpacity(0.15),
                              gradient[1].withOpacity(0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: gradient[0].withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradient[0].withOpacity(0.1),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              width: getGridCount() > 3 ? 36 : 48,
                              height: getGridCount() > 3 ? 36 : 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(getGridCount() > 3 ? 10 : 14),
                              ),
                              child: Icon(
                                iconData,
                                size: getGridCount() > 3 ? 20 : 28,
                                color: gradient[0],
                              ),
                            ),
                            SizedBox(height: getGridCount() > 3 ? 4 : 8),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  text,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: getGridCount() > 3 ? 11 : 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D3B89),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}