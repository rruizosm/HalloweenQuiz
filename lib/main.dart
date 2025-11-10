import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'sections/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _selection;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            'Casa Rural',
            style: GoogleFonts.creepster(
              fontSize: 50,
              color: Colors.orangeAccent,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.red,
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF000000), // negro
                Color(0xFF4A0E0E), // rojo sangre oscuro
                Color(0xFFB71C1C), // rojo brillante
                Color(0xFFFF6F00), // naranja fuego
              ],
              stops: [0.1, 0.4, 0.7, 1.0],
            ),
          ),
          child: _selection == null
              ? SelectionScreen(
                  onSelected: (choice) {
                    setState(() {
                      _selection = choice;
                    });
                  },
                )
              : Home(selection: _selection!),
        ),
      ),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  final Function(String) onSelected;

  const SelectionScreen({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Elige una opción",
              style: GoogleFonts.creepster(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOptionButton(context, "teamA"),
                const SizedBox(width: 20),
                _buildOptionButton(context, "teamB"),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String team) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Card(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => onSelected(team),
          child: Text(
            team,
            style: GoogleFonts.creepster(
              fontSize: 30,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
