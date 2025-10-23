// import 'dart:math';
// import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

// import 'package:casa_rural_1/sections/classification.dart';
// import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

import 'package:casa_rural_1/sections/classification.dart';
import 'package:casa_rural_1/sections/setname.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:hugeicons/hugeicons.dart';
import 'package:casa_rural_1/sections/icon_classification.dart';
import 'package:casa_rural_1/app/database_service.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Home extends StatefulWidget {
  final String selection;
  const Home({Key? key, required this.selection}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool mostrarPista1 = false;
  bool showMessage = false;
  bool mostrarPista2 = false;
  int puntuacion = 0;
  String mensaje = "";
  TextEditingController _controllerPregunta = TextEditingController();
  TextEditingController _controllerOverlay = TextEditingController();
  final DatabaseService _dbService = DatabaseService();

  Map<String,List<Map<String, dynamic>>> fases = {
    'teamA' : [
            {
              'pregunta': 'Pregunta 1',
              'texto': "¿Cuál es la capital de Australia?",
              'pistas': ["No es Sydney ni Melbourne.", "Su nombre comienza con 'C' y termina con 'a'."],
              'respuesta': "Camberra",
              'siguienteFase': "Nunca ha sido tocada,\nse guarda intacta.\nLa llaman pura,\ny no conoce hombre.",
              "respuestaFase": "26489918",

            },
            {
              'pregunta': 'Pregunta 2',
              'texto': "1, 2, 6, 24, 120, 720, 5040, ?",
              'pistas': ["Multiplicación", "Factorial"],
              'respuesta': "40320",
              'siguienteFase': "Un espacio oscuro,\con muros que no respiran.\nA veces guarda secretos,\na veces solo rutina.\nSe abre al curioso,\ny calla cuando se cierra.",
              "respuestaFase": "61478100",
            },    
            {
              'pregunta': 'Pregunta 3',
              'texto': "¿Qué partícula subatómica es responsable de conferir masa a otras partículas elementales, según el Modelo Estándar de la física de partículas?",
              'pistas': ["CERN", "Empieza por H"],
              'respuesta': "Higgs",
              'siguienteFase': "Un cuerpo de hierro,\nque despierta con fuego.\nGuarda brasas rojas,\nAlimenta la espera,\ny calla cuando se enfría.",
              "respuestaFase": "53080104",
            },    
            {
              'pregunta': 'Pregunta 4',
              'texto': "¿Cuál fue el último país en unirse a la OTAN?",
              'pistas': ["Europeo", "S"],
              'respuesta': "",
              'siguienteFase': "Un refugio silencioso,\nque acoge sin preguntar.\nGuarda sueños y secretos,\ny a veces susurra descanso.\nSe abre cada noche,\ny calla con la mañana.",
              "respuestaFase": "22559516",
            },    
            {
              'pregunta': 'Pregunta 5',
              'texto': "¿Cuantos días ha vivido la persona más joven de este grupo?",
              'pistas': ["Pista 1", "Pista 2"],
              'respuesta': "9144",
              'siguienteFase': "",
              "respuestaFase": "74217812",
            },
            {
              'pregunta': 'Pregunta 6',
              'texto': "Calcular:∬(xcos(y)+2y) dA\ndonde R es el rectángulo: 0≤x≤2 , 0≤y≤𝜋/2",
              'pistas': ["Pista 1", "Pista 2"],
              'respuesta': "4+3pi",
              'siguienteFase': "",
              "respuestaFase": "94440471",
            },
            {
              'pregunta': 'Pregunta 7',
              'texto': "El aprendizaje continuo es la clave nvertir",
              'pistas': ["Pista 1", "Pista 2"],
              'respuesta': "",
              'siguienteFase': "",
              "respuestaFase": "35729852",
            },
    ],
    'teamB' : [
        {
          'pregunta': 'Pregunta 1',
          'texto': "Si me tumbas, soy todo. Si me cortas por la cintura, me quedo en nada. ¿Qué soy?",
          'pistas': ["testo", "número"],
          'respuesta': "8",
          'siguienteFase': "",
          "respuestaFase": "20540316",

        },
        {
          'pregunta': 'Pregunta 2',
          'texto': "Un hombre empuja su coche. Se detiene al llegar a un hotel y de pronto sabe que está arruinado. ¿Qué ha pasado?",
          'pistas': [""],
          'respuesta': "Monopoly",
          'siguienteFase': "",
          "respuestaFase": "35426264",
        }, 
        {
          'pregunta': 'Pregunta 3',
          'texto': "Si estás a 2,4 metros de una puerta y con cada movimiento avanzas la mitad de la distancia hasta la puerta. ¿Cuántos movimientos necesitarás para llegar a la puerta?",
          'pistas': [""],
          'respuesta': "Nunca",
          'siguienteFase': "",
          "respuestaFase": "45159988",

        },
        {
          'pregunta': 'Pregunta 4',
          'texto': "Una pera cuesta 40 céntimos, una banana 60 céntimos y una ciruela 80 céntimos. ¿Cuánto cuesta una manzana?",
          'pistas': [""],
          'respuesta': "60",
          'siguienteFase': "",
          "respuestaFase": "69390974",
        }, 
        {
          'pregunta': 'Pregunta 5',
          'texto': "¿Cómo se llama la estación de esquí a la que hemos ido a todos en Font Romeu? (dos palabras)",
          'pistas': [""],
          'respuesta': "Pyrinees 2000",
          'siguienteFase': "",
          "respuestaFase": "53217556",

        },
        {
          'pregunta': 'Pregunta 6',
          'texto': "¿Cuándo se estrenó Interestellar?",
          'pistas': [""],
          'respuesta': "2014",
          'siguienteFase': "",
          "respuestaFase": "88128090",
        },
        {
          'pregunta': 'Pregunta 7',
          'texto': "",
          'pistas': [""],
          'respuesta': "",
          'siguienteFase': "",
          "respuestaFase": "78015938",
        },  
    ],
  };

  int faseActual = 0;
  bool mostrarOverlay=false;
  bool mostrarRanking=false;

  bool nombreEquipoDefinido = false;
  String nombreEquipo  = "";


  void comprobarRespuesta(){
    String respuestaUsuario = _controllerPregunta.text;
    String respuestaCorrecta = fases[widget.selection]![faseActual]['respuesta'];
    setState(() {
      if (respuestaUsuario.toLowerCase() == respuestaCorrecta.toLowerCase()) {
        mostrarOverlay=true;
        mensaje = "";
      }else {
        setState(() {
          mensaje = "Respuesta incorrecta. Inténtalo de nuevo.";
          showMessage = true;        
          _controllerPregunta.clear();
          puntuacion--;
        });

        print(showMessage);
        Future.delayed(Duration(seconds: 5), () {
          setState(() {
            showMessage = false;
          });
        });
      }
    });
  }

  void validarOverlay() {
    String respuestaOverlay = _controllerOverlay.text;
    String respuestaCorrectaOverlay = fases[widget.selection]![faseActual]['respuestaFase'];
    setState(() {
      if (respuestaOverlay.toLowerCase() == respuestaCorrectaOverlay.toLowerCase()) {
        faseActual++;
        mostrarOverlay = false;
        mostrarPista1 = false;
        mostrarPista2 = false;
        _controllerOverlay.clear();
        puntuacion += 10;
        mensaje = "";
        _dbService.update(path: 'quiz/teams/${widget.selection}', data: {'score': puntuacion});

      } else {
        setState(() {
          mensaje = "Respuesta incorrecta. Inténtalo de nuevo.";
          showMessage = true;        
          _controllerOverlay.clear();
        });
        Future.delayed(Duration(seconds: 5), () {
          setState(() {
            showMessage = false;
          });
        });
      }
    });
  }

  void setClassification() {
    setState(() {
      mostrarRanking = !mostrarRanking;
    });
  }

  void setEquipoDefinido() {
    setState(() {
      nombreEquipoDefinido = true;
    _dbService.read(path: 'quiz/teams/${widget.selection}').then((DataSnapshot? snapshot) {
    if (snapshot != null) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        nombreEquipo = data['name'] ?? 0;
      });
    }
    });
    });
  }
  @override

  Widget build(BuildContext context) {
    if (nombreEquipoDefinido) {
      return Stack(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.only(top: 20, left: 30, right: 30, bottom: 55),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Color(0xFF4B0000), // sangre seca
                        Color(0xFF8A0303), // rojo sangre
                        Color(0xFF1A0000), // sombra profunda
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    child: AutoSizeText(
                      nombreEquipo,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.creepster(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // color base (se reemplaza por el degradado)
                      ),
                    ),
                  ),
                Text(fases[widget.selection]![faseActual]['pregunta'], style: GoogleFonts.creepster(fontSize: 30, color: Colors.white)),
                Text(fases[widget.selection]![faseActual]['texto'], style: GoogleFonts.creepster(fontSize: 24, color: Colors.white),),
                mostrarPista1 
                ? Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.transparent,
                  child: Text(fases[widget.selection]![faseActual]['pistas'][0], style: GoogleFonts.creepster(fontSize: 20, color: Colors.white,)),
                )
                : InkWell(
                  onTap: () {
                    setState(() {
                      mostrarPista1 = true;
                      puntuacion--;
                      _dbService.update(path: 'quiz/teams/${widget.selection}', data: {'score':puntuacion});

                    });
                  },
                  child: Icon(Icons.task_alt, size: 40, color: Colors.white,),
                ),
                mostrarPista2 ? Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.transparent,
                  child: Text(fases[widget.selection]![faseActual]['pistas'][1], style: GoogleFonts.creepster(fontSize: 20, color: Colors.white),),
                )
                : InkWell(
                  onTap: () {
                    setState(() {
                      mostrarPista2 = true;
                      puntuacion--;
                      _dbService.update(path: 'quiz/teams/${widget.selection}', data: {'score':puntuacion});

                    });
                  },
                  child: Icon(Icons.task_alt, size: 40, color: Colors.white,),
                ),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _controllerPregunta,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Respuesta',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    )
                  ),
                  onSubmitted: (value) => comprobarRespuesta(),
                ),
                if (mensaje!="" && showMessage)
                Text(mensaje, style: GoogleFonts.montserrat(fontSize: 15, color: Colors.white),),
                Text("Puntuación: $puntuacion", style: GoogleFonts.creepster(fontSize: 25, color: Colors.white),),
              ],
            ),
          ),
          if (!mostrarOverlay) IconClassification(mostrarRanking: mostrarRanking, onRanking: setClassification,),
          if(mostrarRanking)
            Classification(onClose: setClassification,),
          if(mostrarOverlay) 
            Container(
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(30),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      
                      children: [
                        Text(fases[widget.selection]![faseActual]['siguienteFase'], style: GoogleFonts.montserrat(fontSize: 20),),
                        const SizedBox(height: 100,),
                        TextField(
                          controller: _controllerOverlay,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Introduce tu respuesta",
                          ),
                        ),
                        const SizedBox(height: 60,),
                        ElevatedButton(onPressed: validarOverlay, child: Text("Validar")),
                        const SizedBox(height: 60,),
                        if (mensaje!="" && showMessage)
                        Text(mensaje, style: GoogleFonts.montserrat(fontSize: 15, color: Colors.red[700]),),
                      ],
                    ),),
                ),
              ),
            ),
        ],
      ); } else {
      return SetName(selection: widget.selection, onSetEquipoDefinido: setEquipoDefinido,); }
  }
}