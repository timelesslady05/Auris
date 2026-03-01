import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
    // use provided initial categories if available, otherwise load starters
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

  String getCategory(String word) {
    final w = word.toLowerCase();
    if (["water", "toilet", "sleep", "help"].contains(w)) {
      return "Needs";
    } else if (["happy", "sad", "angry"].contains(w)) {
      return "Emotions";
    } else if (["food", "rice", "milk"].contains(w)) {
      return "Food";
    } else if (["play", "go", "come"].contains(w)) {
      return "Actions";
    } else {
      return "General";
    }
  }

  List<Map<String, dynamic>> getStarterWords(String ageRange) {
    switch (ageRange) {
      case "0-3":
        return [
          {"text": "Water", "icon": Icons.local_drink},
          {"text": "Food", "icon": Icons.fastfood},
          {"text": "Yes", "icon": Icons.check_circle},
          {"text": "No", "icon": Icons.cancel},
          {"text": "Sleep", "icon": Icons.bed},
          {"text": "Toilet", "icon": Icons.wc},
        ];

      case "4-6":
        return [
          {"text": "I want", "icon": Icons.record_voice_over},
          {"text": "Help", "icon": Icons.help},
          {"text": "Play", "icon": Icons.sports_soccer},
          {"text": "Hungry", "icon": Icons.fastfood},
          {"text": "Happy", "icon": Icons.sentiment_satisfied},
          {"text": "Sad", "icon": Icons.sentiment_dissatisfied},
        ];

      case "7-9":
        return [
          {"text": "I feel", "icon": Icons.psychology},
          {"text": "I need", "icon": Icons.warning},
          {"text": "I want water", "icon": Icons.local_drink},
          {"text": "I am happy", "icon": Icons.sentiment_satisfied},
          {"text": "Can we play?", "icon": Icons.sports_soccer},
        ];

      case "10-13":
        return [
          {"text": "I feel upset", "icon": Icons.mood_bad},
          {"text": "I need help", "icon": Icons.help},
          {"text": "Can I go outside?", "icon": Icons.directions_walk},
          {"text": "I am hungry", "icon": Icons.fastfood},
          {"text": "I want to talk", "icon": Icons.chat},
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Design Vocabulary")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                        InputDecoration(labelText: "Enter word (e.g. Water)"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addWord,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: categories.keys.map((category) {
                final items = categories[category]!;
                return ExpansionTile(
                  title: Text(category),
                  children: items.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    return ListTile(
                      title: Text(item['text'] as String),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => removeWord(category, idx),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            child: Text("Confirm Design"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                      builder: (context) =>
                        ChildPage(categories: categories, childName: widget.childName, selectedLanguage: widget.selectedLanguage, ageRange: widget.ageRange),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}