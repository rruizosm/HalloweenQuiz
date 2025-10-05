import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:casa_rural_1/sections/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:casa_rural_1/app/database_service.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          'Casa Rural',
          style: GoogleFonts.creepster(fontSize: 50, color: Colors.orangeAccent, shadows: [Shadow(blurRadius: 10, color: Colors.red, offset: Offset(3, 3))]),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF000000), // negro
              Color(0xFF4A0E0E), // rojo sangre oscuro
              Color(0xFFB71C1C), // rojo sangre brillante
              Color(0xFFFF6F00), // naranja fuego
            ],
            stops: [0.1, 0.4, 0.7, 1.0],
          ),
        ),
        child: FutureBuilder<String?>(
          future: _getSelection(),
          builder: (context, snapshot) {
            print(snapshot.data);
            // Check the connection state and data
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while the future is resolving
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data == null) {
              // If no selection exists, show the selection screen
              return SelectionScreen();
            } else {
              // If a selection exists, show the main home screen
              return Home(selection: snapshot.data!);
            }
          },
        ),
      ),
    ),
  );
}
  Future<String?> _getSelection() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_selection"); // Cambia esto a un valor no nulo para probar la pantalla principal
  }
}

class SelectionScreen extends StatelessWidget {
  Future<void> _saveSelection(BuildContext context, String choice) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_selection", choice);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Elige una opción", style: GoogleFonts.creepster(fontSize: 30, color: Colors.white),),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180, 
                  height: 180, 
                  child: Container(
                    child: Card(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                        ),),
                        onPressed: ()=> _saveSelection(context, "A"),
                         
                        child: Text("A", style: GoogleFonts.creepster(fontSize: 30,),)),
                      ),
                    ),
                  ),
                SizedBox(
                  width: 180, 
                  height: 180, 
                  child: Container(
                    child: Card(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                        ),),
                        onPressed: ()=> _saveSelection(context, "B"),                      
                        child: Text("B", style: GoogleFonts.creepster(fontSize: 30, color: Colors.black),)
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

