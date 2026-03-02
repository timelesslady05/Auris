import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'child_page.dart';

class DesignPage extends StatefulWidget {
  final String childName;
  final String selectedLanguage;
  final String ageRange;
  final Map<String, List<Map<String, dynamic>>>? initialCategories;

  DesignPage({required this.childName, required this.selectedLanguage, required this.ageRange, this.initialCategories});

  @override
  _DesignPageState createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
  Map<String, List<Map<String, dynamic>>> categories = {};
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialCategories != null) {
      categories = widget.initialCategories!;
    } else {
      final starters = getStarterWords(widget.ageRange);
      final Map<String, List<Map<String, dynamic>>> initial = {};
      for (var w in starters) {
        final cat = getCategory((w['text'] as String));
        initial.putIfAbsent(cat, () => []).add(w);
      }
      categories = initial;
    }
  }

  Future<void> saveCategories() async {
    final Map<String, List<Map<String, dynamic>>> serializable = {};
    categories.forEach((cat, list) {
      serializable[cat] = list.map((e) {
        final iconData = e['icon'] as IconData;
        return {'text': e['text'], 'icon': iconData.codePoint};
      }).toList();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('vocab', jsonEncode(serializable));
  }

  void addWord() {
    if (controller.text.isNotEmpty) {
      setState(() {
        final entry = {"text": controller.text, "icon": Icons.star};
        final cat = getCategory(controller.text);
        categories.putIfAbsent(cat, () => []).add(entry);
        controller.clear();
      });
      saveCategories();
    }
  }

  void removeWord(String category, int index) {
    setState(() {
      categories[category]?.removeAt(index);
      if (categories[category]?.isEmpty ?? false) {
        categories.remove(category);
      }
    });
    saveCategories();
  }

  static const Map<String, Map<String, String>> _categoryNames = {
    "en": {"needs": "Needs", "emotions": "Emotions", "food": "Food", "actions": "Actions", "general": "General"},
    "es": {"needs": "Necesidades", "emotions": "Emociones", "food": "Comida", "actions": "Acciones", "general": "General"},
    "fr": {"needs": "Besoins", "emotions": "Émotions", "food": "Nourriture", "actions": "Actions", "general": "Général"},
    "de": {"needs": "Bedürfnisse", "emotions": "Emotionen", "food": "Essen", "actions": "Aktionen", "general": "Allgemein"},
    "it": {"needs": "Bisogni", "emotions": "Emozioni", "food": "Cibo", "actions": "Azioni", "general": "Generale"},
  };

  static const Map<String, Map<String, List<String>>> _needsWords = {
    "en": {"needs": ["water", "toilet", "sleep", "help"], "emotions": ["happy", "sad", "angry"], "food": ["food", "rice", "milk"], "actions": ["play", "go", "come"]},
    "es": {"needs": ["agua", "baño", "dormir", "ayuda"], "emotions": ["feliz", "triste", "enojado"], "food": ["comida", "arroz", "leche"], "actions": ["jugar", "ir", "venir"]},
    "fr": {"needs": ["eau", "toilettes", "dormir", "aide"], "emotions": ["heureux", "triste", "en colère"], "food": ["nourriture", "riz", "lait"], "actions": ["jouer", "aller", "venir"]},
    "de": {"needs": ["wasser", "toilette", "schlafen", "hilfe"], "emotions": ["glücklich", "traurig", "wütend"], "food": ["essen", "reis", "milch"], "actions": ["spielen", "gehen", "kommen"]},
    "it": {"needs": ["acqua", "bagno", "dormire", "aiuto"], "emotions": ["felice", "triste", "arrabbiato"], "food": ["cibo", "riso", "latte"], "actions": ["giocare", "andare", "venire"]},
  };

  String getCategory(String word) {
    final lang = widget.selectedLanguage;
    final w = word.toLowerCase();
    final catWords = _needsWords[lang] ?? _needsWords["en"]!;
    if (catWords["needs"]!.contains(w)) {
      return (_categoryNames[lang] ?? _categoryNames["en"]!)["needs"]!;
    } else if (catWords["emotions"]!.contains(w)) {
      return (_categoryNames[lang] ?? _categoryNames["en"]!)["emotions"]!;
    } else if (catWords["food"]!.contains(w)) {
      return (_categoryNames[lang] ?? _categoryNames["en"]!)["food"]!;
    } else if (catWords["actions"]!.contains(w)) {
      return (_categoryNames[lang] ?? _categoryNames["en"]!)["actions"]!;
    } else {
      return (_categoryNames[lang] ?? _categoryNames["en"]!)["general"]!;
    }
  }

  List<Map<String, dynamic>> getStarterWords(String ageRange) {
    final lang = widget.selectedLanguage;
    final words = _translatedWords[lang] ?? _translatedWords["en"]!;
    return words[ageRange] ?? [];
  }

  static const Map<String, Map<String, List<Map<String, dynamic>>>> _translatedWords = {
    "en": {
      "0-3": [
        {"text": "Water", "icon": Icons.local_drink},
        {"text": "Food", "icon": Icons.fastfood},
        {"text": "Yes", "icon": Icons.check_circle},
        {"text": "No", "icon": Icons.cancel},
        {"text": "Sleep", "icon": Icons.bed},
        {"text": "Toilet", "icon": Icons.wc},
      ],
      "4-6": [
        {"text": "I want", "icon": Icons.record_voice_over},
        {"text": "Help", "icon": Icons.help},
        {"text": "Play", "icon": Icons.sports_soccer},
        {"text": "Hungry", "icon": Icons.fastfood},
        {"text": "Happy", "icon": Icons.sentiment_satisfied},
        {"text": "Sad", "icon": Icons.sentiment_dissatisfied},
      ],
      "7-9": [
        {"text": "I feel", "icon": Icons.psychology},
        {"text": "I need", "icon": Icons.warning},
        {"text": "I want water", "icon": Icons.local_drink},
        {"text": "I am happy", "icon": Icons.sentiment_satisfied},
        {"text": "Can we play?", "icon": Icons.sports_soccer},
      ],
      "10-13": [
        {"text": "I feel upset", "icon": Icons.mood_bad},
        {"text": "I need help", "icon": Icons.help},
        {"text": "Can I go outside?", "icon": Icons.directions_walk},
        {"text": "I am hungry", "icon": Icons.fastfood},
        {"text": "I want to talk", "icon": Icons.chat},
      ],
      "14-16": [
        {"text": "I think", "icon": Icons.lightbulb_outline},
        {"text": "It's important", "icon": Icons.priority_high},
        {"text": "Can you explain?", "icon": Icons.question_answer},
        {"text": "I disagree", "icon": Icons.thumb_down_alt},
        {"text": "Let's talk", "icon": Icons.forum},
        {"text": "I need some space", "icon": Icons.do_not_disturb},
      ],
    },
    "es": {
      "0-3": [
        {"text": "Agua", "icon": Icons.local_drink},
        {"text": "Comida", "icon": Icons.fastfood},
        {"text": "Sí", "icon": Icons.check_circle},
        {"text": "No", "icon": Icons.cancel},
        {"text": "Dormir", "icon": Icons.bed},
        {"text": "Baño", "icon": Icons.wc},
      ],
      "4-6": [
        {"text": "Quiero", "icon": Icons.record_voice_over},
        {"text": "Ayuda", "icon": Icons.help},
        {"text": "Jugar", "icon": Icons.sports_soccer},
        {"text": "Hambre", "icon": Icons.fastfood},
        {"text": "Feliz", "icon": Icons.sentiment_satisfied},
        {"text": "Triste", "icon": Icons.sentiment_dissatisfied},
      ],
      "7-9": [
        {"text": "Me siento", "icon": Icons.psychology},
        {"text": "Necesito", "icon": Icons.warning},
        {"text": "Quiero agua", "icon": Icons.local_drink},
        {"text": "Estoy feliz", "icon": Icons.sentiment_satisfied},
        {"text": "¿Podemos jugar?", "icon": Icons.sports_soccer},
      ],
      "10-13": [
        {"text": "Estoy molesto", "icon": Icons.mood_bad},
        {"text": "Necesito ayuda", "icon": Icons.help},
        {"text": "¿Puedo salir?", "icon": Icons.directions_walk},
        {"text": "Tengo hambre", "icon": Icons.fastfood},
        {"text": "Quiero hablar", "icon": Icons.chat},
      ],
      "14-16": [
        {"text": "Yo creo", "icon": Icons.lightbulb_outline},
        {"text": "Es importante", "icon": Icons.priority_high},
        {"text": "¿Puedes explicar?", "icon": Icons.question_answer},
        {"text": "No estoy de acuerdo", "icon": Icons.thumb_down_alt},
        {"text": "Hablemos de ello", "icon": Icons.forum},
        {"text": "Necesito espacio", "icon": Icons.do_not_disturb},
      ],
    },
    "fr": {
      "0-3": [
        {"text": "Eau", "icon": Icons.local_drink},
        {"text": "Nourriture", "icon": Icons.fastfood},
        {"text": "Oui", "icon": Icons.check_circle},
        {"text": "Non", "icon": Icons.cancel},
        {"text": "Dormir", "icon": Icons.bed},
        {"text": "Toilettes", "icon": Icons.wc},
      ],
      "4-6": [
        {"text": "Je veux", "icon": Icons.record_voice_over},
        {"text": "Aide", "icon": Icons.help},
        {"text": "Jouer", "icon": Icons.sports_soccer},
        {"text": "Faim", "icon": Icons.fastfood},
        {"text": "Heureux", "icon": Icons.sentiment_satisfied},
        {"text": "Triste", "icon": Icons.sentiment_dissatisfied},
      ],
      "7-9": [
        {"text": "Je me sens", "icon": Icons.psychology},
        {"text": "J'ai besoin", "icon": Icons.warning},
        {"text": "Je veux de l'eau", "icon": Icons.local_drink},
        {"text": "Je suis heureux", "icon": Icons.sentiment_satisfied},
        {"text": "On peut jouer?", "icon": Icons.sports_soccer},
      ],
      "10-13": [
        {"text": "Je suis triste", "icon": Icons.mood_bad},
        {"text": "J'ai besoin d'aide", "icon": Icons.help},
        {"text": "Je peux sortir?", "icon": Icons.directions_walk},
        {"text": "J'ai faim", "icon": Icons.fastfood},
        {"text": "Je veux parler", "icon": Icons.chat},
      ],
      "14-16": [
        {"text": "Je pense", "icon": Icons.lightbulb_outline},
        {"text": "C'est important", "icon": Icons.priority_high},
        {"text": "Tu peux expliquer?", "icon": Icons.question_answer},
        {"text": "Je ne suis pas d'accord", "icon": Icons.thumb_down_alt},
        {"text": "Parlons-en", "icon": Icons.forum},
        {"text": "J'ai besoin d'espace", "icon": Icons.do_not_disturb},
      ],
    },
    "de": {
      "0-3": [
        {"text": "Wasser", "icon": Icons.local_drink},
        {"text": "Essen", "icon": Icons.fastfood},
        {"text": "Ja", "icon": Icons.check_circle},
        {"text": "Nein", "icon": Icons.cancel},
        {"text": "Schlafen", "icon": Icons.bed},
        {"text": "Toilette", "icon": Icons.wc},
      ],
      "4-6": [
        {"text": "Ich will", "icon": Icons.record_voice_over},
        {"text": "Hilfe", "icon": Icons.help},
        {"text": "Spielen", "icon": Icons.sports_soccer},
        {"text": "Hunger", "icon": Icons.fastfood},
        {"text": "Glücklich", "icon": Icons.sentiment_satisfied},
        {"text": "Traurig", "icon": Icons.sentiment_dissatisfied},
      ],
      "7-9": [
        {"text": "Ich fühle", "icon": Icons.psychology},
        {"text": "Ich brauche", "icon": Icons.warning},
        {"text": "Ich will Wasser", "icon": Icons.local_drink},
        {"text": "Ich bin glücklich", "icon": Icons.sentiment_satisfied},
        {"text": "Können wir spielen?", "icon": Icons.sports_soccer},
      ],
      "10-13": [
        {"text": "Ich bin traurig", "icon": Icons.mood_bad},
        {"text": "Ich brauche Hilfe", "icon": Icons.help},
        {"text": "Kann ich rausgehen?", "icon": Icons.directions_walk},
        {"text": "Ich habe Hunger", "icon": Icons.fastfood},
        {"text": "Ich will reden", "icon": Icons.chat},
      ],
      "14-16": [
        {"text": "Ich denke", "icon": Icons.lightbulb_outline},
        {"text": "Es ist wichtig", "icon": Icons.priority_high},
        {"text": "Kannst du das erklären?", "icon": Icons.question_answer},
        {"text": "Ich bin dagegen", "icon": Icons.thumb_down_alt},
        {"text": "Lass uns darüber reden", "icon": Icons.forum},
        {"text": "Ich brauche Platz", "icon": Icons.do_not_disturb},
      ],
    },
    "it": {
      "0-3": [
        {"text": "Acqua", "icon": Icons.local_drink},
        {"text": "Cibo", "icon": Icons.fastfood},
        {"text": "Sì", "icon": Icons.check_circle},
        {"text": "No", "icon": Icons.cancel},
        {"text": "Dormire", "icon": Icons.bed},
        {"text": "Bagno", "icon": Icons.wc},
      ],
      "4-6": [
        {"text": "Voglio", "icon": Icons.record_voice_over},
        {"text": "Aiuto", "icon": Icons.help},
        {"text": "Giocare", "icon": Icons.sports_soccer},
        {"text": "Fame", "icon": Icons.fastfood},
        {"text": "Felice", "icon": Icons.sentiment_satisfied},
        {"text": "Triste", "icon": Icons.sentiment_dissatisfied},
      ],
      "7-9": [
        {"text": "Mi sento", "icon": Icons.psychology},
        {"text": "Ho bisogno", "icon": Icons.warning},
        {"text": "Voglio acqua", "icon": Icons.local_drink},
        {"text": "Sono felice", "icon": Icons.sentiment_satisfied},
        {"text": "Possiamo giocare?", "icon": Icons.sports_soccer},
      ],
      "10-13": [
        {"text": "Sono triste", "icon": Icons.mood_bad},
        {"text": "Ho bisogno di aiuto", "icon": Icons.help},
        {"text": "Posso uscire?", "icon": Icons.directions_walk},
        {"text": "Ho fame", "icon": Icons.fastfood},
        {"text": "Voglio parlare", "icon": Icons.chat},
      ],
      "14-16": [
        {"text": "Penso", "icon": Icons.lightbulb_outline},
        {"text": "È importante", "icon": Icons.priority_high},
        {"text": "Puoi spiegare?", "icon": Icons.question_answer},
        {"text": "Non sono d'accordo", "icon": Icons.thumb_down_alt},
        {"text": "Parliamone", "icon": Icons.forum},
        {"text": "Ho bisogno di spazio", "icon": Icons.do_not_disturb},
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
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
                          "Design Vocabulary",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3B89),
                          ),
                        ),
                        Text(
                          "Customize words for ${widget.childName}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Color(0xFFA3AED0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Add word input card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                child: Row(
                  children: [
                    Icon(Icons.edit_note, color: Color(0xFF4A90E2)),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        style: GoogleFonts.poppins(color: Color(0xFF2D3B89)),
                        decoration: InputDecoration(
                          hintText: "Add a new word...",
                          hintStyle: GoogleFonts.poppins(color: Color(0xFFA3AED0)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: addWord,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2D3B89), Color(0xFF4A90E2)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Categories list
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                children: categories.keys.map((category) {
                  final items = categories[category]!;
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2D3B89).withOpacity(0.06),
                          blurRadius: 15,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Color(0xFF4A90E2).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.folder_outlined,
                                  color: Color(0xFF4A90E2), size: 20),
                            ),
                            SizedBox(width: 12),
                            Text(
                              category,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3B89),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFD700).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${items.length}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFD4A800),
                                ),
                              ),
                            ),
                          ],
                        ),
                        children: items.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final item = entry.value;
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                              leading: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4F7FE),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: Color(0xFF4A90E2),
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                item['text'] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Color(0xFF2D3B89),
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap: () => removeWord(category, idx),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.delete_outline,
                                      color: Colors.red.shade300, size: 18),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Confirm button
            Padding(
              padding: EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2D3B89),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                    shadowColor: Color(0xFF2D3B89).withOpacity(0.4),
                  ),
                  child: Text(
                    "Confirm Design",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                            builder: (context) =>
                              ChildPage(categories: categories, childName: widget.childName, ageRange: widget.ageRange),
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