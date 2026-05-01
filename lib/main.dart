import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0D0221),
      textTheme: GoogleFonts.zenMaruGothicTextTheme(ThemeData.dark().textTheme),
    ),
    home: Scaffold(
      appBar: AppBar(title: const Text("OBAN ADMIN"), centerTitle: true, backgroundColor: Colors.transparent),
      body: const AdminPanel(),
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});
  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _img = TextEditingController();
  final _url = TextEditingController();
  void _update() async {
    if (_img.text.isEmpty || _url.text.isEmpty) return;
    await FirebaseFirestore.instance.collection('ads').doc('current').set({
      'imageUrl': _img.text, 'targetUrl': _url.text, 'updatedAt': Timestamp.now(),
    });
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✨ Готово! Реклама обновлена.")));
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(controller: _img, decoration: const InputDecoration(labelText: "URL картинки баннера", filled: true)),
          const SizedBox(height: 15),
          TextField(controller: _url, decoration: const InputDecoration(labelText: "Ссылка перехода", filled: true)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _update, 
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.purpleAccent), 
            child: const Text("ОБНОВИТЬ РЕКЛАМУ")
          )
        ],
      ),
    );
  }
}
