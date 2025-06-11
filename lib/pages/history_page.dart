import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _db = FirebaseDatabase.instance.reference();
  late List<HistoryItem> _history;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _history = [];
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    final snapshot = await _db.child('History').child(currentUser.uid).once();
    final Map<String, dynamic>? data = (snapshot.snapshot.value as Map<dynamic, dynamic>?)?.cast<String, dynamic>();

    if (data == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final history = data.entries.map((entry) {
      return HistoryItem(
        id: entry.key,
        originalText: entry.value['originalText'],
        translatedText: entry.value['translatedText'],
      );
    }).toList();

    setState(() {
      _history = history;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text('History'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _history.isEmpty
          ? Center(child: Text('No history available'))
          : ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              title: Text(
                item.originalText,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                item.translatedText,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HistoryItem {
  final String id;
  final String originalText;
  final String translatedText;

  HistoryItem({required this.id, required this.originalText, required this.translatedText});
}

