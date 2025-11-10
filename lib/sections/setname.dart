import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:casa_rural_1/app/database_service.dart';

class SetName extends StatefulWidget {
  final String selection;
  final VoidCallback onSetEquipoDefinido;
  final String deviceId;
  const SetName({super.key, required this.selection, required this.onSetEquipoDefinido, required this.deviceId});

  @override
  State<SetName> createState() => _SetNameState();
}

class _SetNameState extends State<SetName> {
  bool nombreEquipoDefinido = false;
  TextEditingController _controllerPregunta = TextEditingController();
  final DatabaseService _dbService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.only(top: 20, left: 30, right: 30, bottom: 55),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("¿Cómo se llama vuestro equipo?", style: GoogleFonts.creepster(fontSize: 40, color: Colors.white), textAlign: TextAlign.center,),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _controllerPregunta,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre del equipo',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    )
                  ),
                  onSubmitted: (value) {  
                    if(value.isNotEmpty) {
                      print("DeviceID: "+widget.deviceId);
                      _dbService.update(path: 'quiz/devices/${widget.deviceId}', data: {'name': _controllerPregunta.text.toUpperCase()});
                      widget.onSetEquipoDefinido();
                      _controllerPregunta.clear();}
                    ;
                  },
                ),
              ],
            ),
          ),
        ],
      ); }
  }
