import 'package:casa_rural_1/sections/boton_ayuda_container.dart';
import 'package:casa_rural_1/sections/classification.dart';
import 'package:casa_rural_1/sections/device_id_service.dart';
import 'package:casa_rural_1/sections/setname.dart';
import 'package:casa_rural_1/sections/submit.dart';
import 'package:casa_rural_1/sections/boton_ayuda.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:casa_rural_1/sections/finalChest.dart';
import 'package:casa_rural_1/sections/icon_classification.dart';
import 'package:casa_rural_1/app/database_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';

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
  TextEditingController _controllerOverlay = TextEditingController();
  final DatabaseService _dbService = DatabaseService();

  int faseActual = 0;
  bool mostrarOverlay = false;
  bool mostrarRanking = false;
  bool ayudaSolicitada = false;

  bool nombreEquipoDefinido = false;
  String nombreEquipo = "";
  String deviceId = "";
  String widgetEquipo = "";
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    initDevice();
    loadData();
  }

  Future<void> initDevice() async {
    final id = await DeviceIdService.getDeviceId();
    final snapshot = await _dbService.read(path: 'quiz/devices/$id');

    if (snapshot != null && snapshot.value != null) {
      setState(() => deviceId = id);
      _listenToScoreChanges(); // ✅ start real-time listener
      getTeamValues();
    } else {
      await _dbService.create(path: 'quiz/devices/$id', data: {
        'setName': false,
        'name': "",
        'phase': faseActual,
        'score': 0,
        'widgetTeam': widget.selection,
      });
      setState(() => deviceId = id);
      _listenToScoreChanges();
    }
  }

  void _listenToScoreChanges() {
    FirebaseDatabase.instance.ref('quiz/devices/$deviceId/score').onValue.listen((event) {
      final val = event.snapshot.value;
      if (val != null) {
        setState(() {
          final n = val is int ? val : (val is double ? val.toInt() : 0);
          puntuacion = n;
        });
      }
    });
  }

  Future<void> loadData() async {
    final jsonString = await rootBundle.loadString('assets/questions.json');
    data = json.decode(jsonString);
  }

  void getTeamValues() async {
    final snapshot = await _dbService.read(path: 'quiz/devices/$deviceId');
    if (snapshot != null && snapshot.value != null) {
      final dataMap = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        nombreEquipoDefinido = dataMap['setName'] ?? false;
        nombreEquipo = dataMap['name'] ?? "";
        faseActual = dataMap['phase'] ?? 0;
        widgetEquipo = dataMap['widgetTeam'] ?? "";
        final rawScore = dataMap['score'];
        puntuacion = (rawScore is int) ? rawScore : (rawScore is double ? rawScore.toInt() : 0);
      });
    }
  }

  void validarOverlay() async {
    String respuestaOverlay = _controllerOverlay.text.trim();
    String respuestaCorrectaOverlay = data[widgetEquipo]![faseActual]['respuestaFase'];
    if (respuestaOverlay.toLowerCase() == respuestaCorrectaOverlay.toLowerCase()) {
      setState(() {
        faseActual++;
        mostrarOverlay = false;
        mostrarPista1 = false;
        mostrarPista2 = false;
        ayudaSolicitada = false;
        _controllerOverlay.clear();
      });

      puntuacion += 5;
      await _dbService.update(path: 'quiz/devices/$deviceId', data: {
        'score': puntuacion,
        'phase': faseActual,
      });
    } else {
      setState(() {
        showMessage = true;
        _controllerOverlay.clear();
      });
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) setState(() => showMessage = false);
      });
    }
  }

  void setClassification() => setState(() => mostrarRanking = !mostrarRanking);

  void setMostrarOverlay() => setState(() {
        mostrarOverlay = !mostrarOverlay;
        ayudaSolicitada = false;
      });

  void setEquipoDefinido() async {
    setState(() => nombreEquipoDefinido = true);
    await _dbService.update(path: 'quiz/devices/$deviceId', data: {'setName': true});
    getTeamValues();
  }

  Future<void> actualizarPuntuacion(int delta) async {
    setState(() => puntuacion += delta);
    await _dbService.update(path: 'quiz/devices/$deviceId', data: {'score': puntuacion});
  }

  @override
  Widget build(BuildContext context) {
    if (faseActual > 6) return const FinalChest();

    if (!nombreEquipoDefinido) {
      return SetName(
        selection: widgetEquipo,
        onSetEquipoDefinido: setEquipoDefinido,
        deviceId: deviceId,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 55),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF4B0000), Color(0xFF8A0303), Color(0xFF1A0000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: AutoSizeText(
                  nombreEquipo,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.creepster(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Text(data[widgetEquipo]![faseActual]['pregunta'],
                  style: GoogleFonts.creepster(fontSize: 30, color: Colors.white)),
              Text(data[widgetEquipo]![faseActual]['texto'],
                  style: GoogleFonts.creepster(fontSize: 24, color: Colors.white)),
              Submit(
                selection: widgetEquipo,
                faseActual: faseActual,
                onMostrarOverlay: setMostrarOverlay,
                deviceId: deviceId,
                onRespuesta: (acierto) => actualizarPuntuacion(acierto ? 5 : -1),
              ),
            ],
          ),
        ),
        BotonAyuda(
          ayudaSolicitada: ayudaSolicitada,
          onSolicitarAyuda: () {
            if (!ayudaSolicitada) {
              actualizarPuntuacion(-3);
              setState(() => ayudaSolicitada = true);
            }
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Text("Ayuda", style: GoogleFonts.creepster(color: Colors.red, fontSize: 28)),
                content: Text(
                  data[widgetEquipo]![faseActual]['pista'] ?? "Aquí puedes recibir una pista.",
                  style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cerrar", style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );
          },
        ),
        if (!mostrarOverlay)
          IconClassification(mostrarRanking: mostrarRanking, onRanking: setClassification),
        if (mostrarRanking) Classification(id: deviceId, onClose: setClassification),
        if (mostrarOverlay)
          Center(
            child: Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.red, width: 2)),
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(data[widgetEquipo]![faseActual]['siguienteFase'],
                        style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white)),
                    TextField(
                      controller: _controllerOverlay,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Introduce tu respuesta",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      ),
                      onSubmitted: (_) => validarOverlay(),
                    ),
                    BotonAyudaSimple(
                      ayudaSolicitada: ayudaSolicitada,
                      onSolicitarAyuda: () {
                        if (!ayudaSolicitada) {
                          actualizarPuntuacion(-3);
                          setState(() => ayudaSolicitada = true);
                        }
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: Text("Ayuda", style: GoogleFonts.creepster(color: Colors.red, fontSize: 28)),
                            content: Text(
                              data[widgetEquipo]![faseActual]['pista'] ?? "Aquí puedes recibir una pista.",
                              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cerrar", style: TextStyle(color: Colors.redAccent)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
