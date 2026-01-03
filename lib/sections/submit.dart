import 'package:halloween_quiz/sections/device_id_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:halloween_quiz/app/database_service.dart';
import 'package:halloween_quiz/app/theme.dart';

class Submit extends StatefulWidget {
  final String selection;
  final int faseActual;
  final String deviceId;
  final VoidCallback onMostrarOverlay;
  final void Function(bool acierto) onRespuesta;

  const Submit({
    Key? key,
    required this.selection,
    required this.faseActual,
    required this.deviceId,
    required this.onMostrarOverlay,
    required this.onRespuesta,
  }) : super(key: key);

  @override
  State<Submit> createState() => _SubmitState();
}

class _SubmitState extends State<Submit> {
  final TextEditingController _controllerPregunta = TextEditingController();
  bool showMessage = false;
  String mensaje = "";
  int intentos= 0;
  Map<String, dynamic> data = {};
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final jsonString = await rootBundle.loadString('assets/questions.json');
    if (mounted) {
       setState(() {
         data = json.decode(jsonString);
       });
    }
  }

  void comprobarRespuesta() {
    final respuestaUsuario = _controllerPregunta.text.trim();
    if (data.isEmpty) return; // Guard clause

    final respuestaCorrecta = data[widget.selection]![widget.faseActual]['respuesta'];
    final acierto = respuestaUsuario.toLowerCase() == respuestaCorrecta.toLowerCase();

    widget.onRespuesta(acierto); // ✅ notify parent to update score

    if (acierto) {
      _controllerPregunta.clear();
      intentos=0;
      widget.onMostrarOverlay();
    } else {
      setState(() {
        _dbService.create(path: 'quiz/logs/${widget.deviceId}/${widget.faseActual}/$intentos', data: {'text': _controllerPregunta.text});
        _controllerPregunta.clear();
        mensaje = "¡Incorrecto! La oscuridad se ríe de ti...";
        showMessage = true;
        intentos++;
      });
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => showMessage = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controllerPregunta,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black45, // Slightly transparent black
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: HalloweenTheme.pumpkinOrange)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
            labelText: 'Tu Respuesta',
            labelStyle: TextStyle(color: Colors.white70),
            suffixIcon: IconButton(
              icon: Icon(Icons.send_rounded, color: HalloweenTheme.bloodRed),
              onPressed: comprobarRespuesta,
            ),
          ),
          onSubmitted: (_) => comprobarRespuesta(),
        ),
        const SizedBox(height: 10),
        if (showMessage)
          Text(
            mensaje,
            style: GoogleFonts.montserrat(fontSize: 15, color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
