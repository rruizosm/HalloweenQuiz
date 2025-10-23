import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:casa_rural_1/app/database_service.dart';

class Classification extends StatefulWidget {
  final VoidCallback onClose;
  const Classification({super.key, required this.onClose});

  @override
  State<Classification> createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
  final DatabaseService _dbService = DatabaseService();
  int teamAScore = 0;
  int teamBScore = 0;
  String teamAName = "";
  String teamBName = "";

  
  @override

  void initState() {
    super.initState();
    
    // Listen for real-time updates
    _dbService.read(path: 'quiz/teams').then((DataSnapshot? snapshot) {
      if (snapshot != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          teamAScore = data['teamA']?['score'] ?? 0;
          teamBScore = data['teamB']?['score'] ?? 0;
          teamAName = data['teamA']?['name'] ?? "Team A";
          teamBName = data['teamB']?['name'] ?? "Team B";
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                // width: 350,
                // height: 600,
                child: Stack(
                  children: [
                    Container(
                      width: 350,
                      height: 650,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFF6F00), // naranja fuego
                              Color(0xFFFFA726), // naranja brillante
                              Color(0xFFFFD54F), // dorado cálido
                              Color(0xFFFFECB3), // amarillo pálido
                            ],
                            stops: [0.0, 0.4, 0.75, 1.0],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Clasificación", style: GoogleFonts.creepster(fontSize: 45, fontWeight: FontWeight.normal, color: Colors.black),),
                          SizedBox(height: 100,),
                          Text(teamAName, style: GoogleFonts.creepster(fontSize: 40, color: Colors.black),),
                          SizedBox(height: 10,),
                          Text(teamAScore.toString(), style: GoogleFonts.creepster(fontSize: 25, color: Colors.black),),
                          SizedBox(height: 60,),
                          Text(teamBName, style: GoogleFonts.creepster(fontSize: 40, color: Colors.black),),
                          SizedBox(height: 10,),
                          Text(teamBScore.toString(), style: GoogleFonts.creepster(fontSize: 25, color: Colors.black),),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 15,
                        right: 15,
                        child: InkWell(
                          onTap: () {
                            widget.onClose();
                            print("Cerrar clasificación");
                          },
                          child: HugeIcon(icon: HugeIcons.strokeRoundedMultiplicationSign, size: 30, color: Colors.black,),
                        )
                    ),
                  ],
                )
              ),
            ),
          ],
        );
  }
}