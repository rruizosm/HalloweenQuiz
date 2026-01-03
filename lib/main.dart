import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'sections/home.dart';
import 'app/theme.dart';
import 'sections/spooky_widgets.dart';

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
      theme: ThemeData(
        primaryColor: HalloweenTheme.pumpkinOrange,
        scaffoldBackgroundColor: Colors.black, // Fallback
        textTheme: TextTheme(
          bodyMedium: HalloweenTheme.bodyStyle,
        ),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false, // Prevent keyboard from breaking layout
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: HalloweenTheme.midnightBlack,
          title: Text(
            'Casa Rural',
            style: HalloweenTheme.titleStyle,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child: Container(
              color: HalloweenTheme.bloodRed,
              height: 2.0,
            ),
          ),
        ),
        body: SpookyBackground(
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Elige tu Destino",
            style: HalloweenTheme.headerStyle.copyWith(fontSize: 35),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOptionButton(context, "teamA", "Equipo A"),
              const SizedBox(width: 30),
              _buildOptionButton(context, "teamB", "Equipo B"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String value, String label) {
    return SpookyButton(
      text: label,
      onPressed: () => onSelected(value),
      width: 140,
      height: 140,
      color: HalloweenTheme.charcoal,
      textColor: HalloweenTheme.pumpkinOrange,
    );
  }
}
