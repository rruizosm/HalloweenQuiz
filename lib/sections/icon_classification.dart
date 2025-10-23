import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class IconClassification extends StatelessWidget {
  final bool mostrarRanking;
  final VoidCallback onRanking;
  const IconClassification({super.key, required this.mostrarRanking, required this.onRanking});

  @override
  Widget build(BuildContext context) {
    if(!mostrarRanking) {
      return Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: InkWell(
          onTap: () {
            onRanking();
          },
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFF6F00), // naranja fuego
                      Color.fromARGB(255, 255, 226, 38), // naranja brillante
                    ],
                    stops: [0.0, 1.0],
                ),
                border: Border(top: BorderSide(color: Colors.black, width: 1))
            ),
            child: Center(
              child: HugeIcon(icon: HugeIcons.strokeRoundedAward01, size: 30, color: Colors.black,)
            ),
          ),
        ),
      );
    } else {
      return Container(); // Retorna un contenedor vacío si no se muestra el icono
    }
  }
}