import 'package:casa_rural_1/sections/device_id_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:casa_rural_1/app/database_service.dart';
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
    data = json.decode(jsonString);
  }

  void comprobarRespuesta() {
    final respuestaUsuario = _controllerPregunta.text.trim();
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
        mensaje = "Respuesta incorrecta. Inténtalo de nuevo.";
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
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Respuesta',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          ),
          onSubmitted: (_) => comprobarRespuesta(),
        ),
        const SizedBox(height: 20),
        if (showMessage)
          Text(
            mensaje,
            style: GoogleFonts.montserrat(fontSize: 15, color: Colors.white),
          ),
      ],
    );
  }
}
