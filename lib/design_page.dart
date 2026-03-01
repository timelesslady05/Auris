import 'package:flutter/material.dart';
import 'child_page.dart';

class DesignPage extends StatefulWidget {
  final String childName;

  DesignPage({required this.childName});

  @override
  _DesignPageState createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
  List<Map<String, dynamic>> words = [];
  TextEditingController controller = TextEditingController();

  void addWord() {
  if (controller.text.isNotEmpty) {
    setState(() {
      words.add({
        "text": controller.text,
        "icon": Icons.star
      });
      controller.clear();
    });
  }
}

  void removeWord(int index) {
    setState(() {
      words.removeAt(index);
    });
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
            child: ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final entry = words[index];
                return ListTile(
                  title: Text(entry['text'] as String),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => removeWord(index),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            child: Text("Confirm Design"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChildPage(words: words, childName: widget.childName),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}