import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:casa_rural_1/app/database_service.dart';

class Classification extends StatefulWidget {
  final VoidCallback onClose;
  final String id;
  const Classification({super.key, required this.onClose, required this.id});

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
    _dbService.read(path: 'quiz/devices').then((DataSnapshot? snapshot) {
      if (snapshot != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          final team = value['widgetTeam'];
          final int score = value['score'];
          final name = value['name'];
          if (team == 'teamA') {
            teamAScore += score;
            teamAName = name ?? "Team A";
          } else if (team == 'teamB') {
            teamBScore += score;
            teamBName = name ?? "Team B";
          }
        });
        
        setState(() {
          teamAScore = teamAScore;
          teamBScore = teamBScore;
          teamAName = teamAName;
          teamBName = teamBName;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.8,
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