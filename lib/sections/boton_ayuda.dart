import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotonAyuda extends StatelessWidget {
  final bool ayudaSolicitada;
  final VoidCallback onSolicitarAyuda;

  const BotonAyuda({
    Key? key,
    required this.ayudaSolicitada,
    required this.onSolicitarAyuda,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Solo mostramos el botón si no está activo el overlay
    return Positioned(
      top: 10,
      right: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              ayudaSolicitada ? Colors.grey[700] : Colors.red[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          elevation: 6,
        ),
        onPressed: ayudaSolicitada ? null : onSolicitarAyuda,
        child: Text(
          ayudaSolicitada ? "Ayuda solicitada" : "Ayuda",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
