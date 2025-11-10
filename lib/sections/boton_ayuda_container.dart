import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                ayudaSolicitada ? Colors.grey[700] : Colors.red[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 6,
          ),
          onPressed: ayudaSolicitada ? null : onSolicitarAyuda,
          child: Text(
            ayudaSolicitada ? "Ayuda solicitada" : "Ayuda",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
