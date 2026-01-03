import 'package:flutter/material.dart';
import 'package:casa_rural_1/app/theme.dart';
import 'package:casa_rural_1/sections/spooky_widgets.dart';

class BotonAyudaSimple extends StatelessWidget {
  final bool ayudaSolicitada;
  final VoidCallback onSolicitarAyuda;

  const BotonAyudaSimple({
    Key? key,
    required this.ayudaSolicitada,
    required this.onSolicitarAyuda,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight, // Se alinea abajo a la derecha
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5),
        child: SpookyButton(
          text: ayudaSolicitada ? "Ayuda solicitada" : "Ayuda",
          onPressed: ayudaSolicitada ? null : onSolicitarAyuda,
          color: ayudaSolicitada ? Colors.grey[800] : HalloweenTheme.bloodRed,
          textColor: Colors.white,
          width: 160,
          height: 40,
        ),
      ),
    );
  }
}
