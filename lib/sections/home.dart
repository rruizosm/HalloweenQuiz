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
import 'package:casa_rural_1/app/theme.dart';
import 'package:casa_rural_1/sections/spooky_widgets.dart';
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
      if (mounted) setState(() => deviceId = id);
      _listenToScoreChanges();
      getTeamValues();
    } else {
      await _dbService.create(path: 'quiz/devices/$id', data: {
        'setName': false,
        'name': "",
        'phase': faseActual,
        'score': 0,
        'widgetTeam': widget.selection,
      });
      if (mounted) setState(() => deviceId = id);
      _listenToScoreChanges();
    }
  }

  void _listenToScoreChanges() {
    FirebaseDatabase.instance.ref('quiz/devices/$deviceId/score').onValue.listen((event) {
      final val = event.snapshot.value;
      if (val != null && mounted) {
        setState(() {
          final n = val is int ? val : (val is double ? val.toInt() : 0);
          puntuacion = n;
        });
      }
    });
  }

  Future<void> loadData() async {
    final jsonString = await rootBundle.loadString('assets/questions.json');
    if (mounted) {
      setState(() {
        data = json.decode(jsonString);
      });
    }
  }

  void getTeamValues() async {
    final snapshot = await _dbService.read(path: 'quiz/devices/$deviceId');
    if (snapshot != null && snapshot.value != null) {
      final dataMap = snapshot.value as Map<dynamic, dynamic>;
      if (mounted) {
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
    // setState(() => puntuacion += delta); // Removed optimistic local update to rely on listener
    final newScore = puntuacion + delta;
     await _dbService.update(path: 'quiz/devices/$deviceId', data: {'score': newScore});
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

    if (data.isEmpty) return const Center(child: CircularProgressIndicator(color: HalloweenTheme.pumpkinOrange));

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Team Header
              SpookyCard(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: AutoSizeText(
                  nombreEquipo,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: HalloweenTheme.titleStyle.copyWith(color: Colors.white, fontSize: 35),
                ),
              ),
              
              // Question Card
              SpookyCard(
                child: Column(
                  children: [
                     Text(data[widgetEquipo]![faseActual]['pregunta'],
                        textAlign: TextAlign.center,
                        style: HalloweenTheme.headerStyle.copyWith(color: HalloweenTheme.pumpkinOrange)),
                     const SizedBox(height: 15),
                     Text(data[widgetEquipo]![faseActual]['texto'],
                        textAlign: TextAlign.center,
                        style: HalloweenTheme.bodyStyle.copyWith(fontSize: 18)),
                  ],
                ),
              ),

              // Answer Section
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

        // Help Button
        BotonAyuda(
          ayudaSolicitada: ayudaSolicitada,
          onSolicitarAyuda: () {
            if (!ayudaSolicitada) {
              actualizarPuntuacion(-3);
              setState(() => ayudaSolicitada = true);
            }
            showDialog(
              context: context,
              builder: (context) => SpookyDialog(
                title: "Pista Maldita",
                content: data[widgetEquipo]![faseActual]['pista'] ?? "No hay ayuda para ti...",
                onClose: () => Navigator.pop(context),
              ),
            );
          },
        ),

        // Leaderboard Icon
        if (!mostrarOverlay)
          IconClassification(mostrarRanking: mostrarRanking, onRanking: setClassification),
        
        // Leaderboard Overlay
        if (mostrarRanking) Classification(id: deviceId, onClose: setClassification),
        
        // Phase Success Overlay
        if (mostrarOverlay)
          Container(
            color: Colors.black.withOpacity(0.8),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: SpookyCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("¡Correcto!", style: HalloweenTheme.titleStyle),
                    const SizedBox(height: 20),
                    Text(data[widgetEquipo]![faseActual]['siguienteFase'],
                        textAlign: TextAlign.center,
                        style: HalloweenTheme.bodyStyle.copyWith(fontStyle: FontStyle.italic)),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _controllerOverlay,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black45,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: "Código secreto...",
                        hintStyle: TextStyle(color: Colors.white54),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: HalloweenTheme.pumpkinOrange)),
                      ),
                      onSubmitted: (_) => validarOverlay(),
                    ),
                    const SizedBox(height: 20),
                    if (showMessage)
                       Text("Código incorrecto, sufre las consecuencias...", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
