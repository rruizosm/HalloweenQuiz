import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FinalChest extends StatefulWidget {
  const FinalChest({super.key});

  @override
  State<FinalChest> createState() => _FinalChestState();
}

class _FinalChestState extends State<FinalChest> {
  final TextEditingController _controller = TextEditingController();
  bool _unlocked = false;
  final String _correctCode = "t1 levanta la sexta"; // <-- Cambia esto por el código real

  void _checkCode() {
    if (_controller.text.trim() == _correctCode) {
      setState(() {
        _unlocked = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Código incorrecto, intenta de nuevo."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_unlocked) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, color: Colors.amberAccent, size: 100),
            const SizedBox(height: 20),
            Text(
              "¡Has ganado la prueba!",
              style: GoogleFonts.creepster(
                fontSize: 40,
                color: Colors.orangeAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Desbloquea el cofre para ganar.",
            style: GoogleFonts.creepster(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 250,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: "Introduce el código",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _checkCode,
            icon: const Icon(Icons.lock_open),
            label: const Text("Desbloquear"),
          ),
        ],
      ),
    );
  }
}
