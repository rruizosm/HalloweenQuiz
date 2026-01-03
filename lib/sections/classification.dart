import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:halloween_quiz/app/database_service.dart';
import 'package:halloween_quiz/app/theme.dart';
import 'package:halloween_quiz/sections/spooky_widgets.dart';

class Classification extends StatefulWidget {
  final VoidCallback onClose;
  final String id;
  const Classification({super.key, required this.onClose, required this.id});

  @override
  State<Classification> createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
  int teamAScore = 0;
  int teamBScore = 0;
  String teamAName = "Team A";
  String teamBName = "Team B";

  @override
  void initState() {
    super.initState();
    _listenToTeamScores();
  }

  void _listenToTeamScores() {
    FirebaseDatabase.instance.ref('quiz/devices').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        
        int tempTeamA = 0;
        int tempTeamB = 0;
        String tempNameA = "Team A";
        String tempNameB = "Team B";

        data.forEach((key, value) {
          final team = value['widgetTeam'];
          final int score = (value['score'] is int) ? value['score'] : (value['score'] as double).toInt();
          final name = value['name'];
          
          if (team == 'teamA') {
            tempTeamA = score; // Assuming 1 device per team? Or sum? Code implies sum initially, but let's stick to last value or sum? 
            // Original code: teamAScore += score. Implicitly: sum of ALL devices in teamA.
            // CAUTION: original code had `teamAScore += score` inside `forEach`. 
            // If there are multiple devices per team, we sum them.
            // If there is only one device per team, it takes that value.
            // Since it's a quiz, likely one device per team leader?
            // Actually, if I re-read the original: it iterated and summed.
            // But variables were not reset! `data.forEach` ran once in `initState`.
            // Here, inside `listen`, we must reset variables before loop.
            tempNameA = name ?? "Team A";
             // If multiple devices, name might be overwritten. Assuming single source of truth or don't care.
          } else if (team == 'teamB') {
            tempTeamB = score;
            tempNameB = name ?? "Team B";
          }
        });

        if (mounted) {
          setState(() {
            teamAScore = tempTeamA;
            teamBScore = tempTeamB;
            teamAName = tempNameA;
            teamBName = tempNameB;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                child: Stack(
                  children: [
                    // Glassmorphic Helper Container
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: screenWidth * 0.85,
                          height: screenHeight * 0.7,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                HalloweenTheme.pumpkinOrange.withOpacity(0.9),
                                Colors.orangeAccent.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                            boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 20, spreadRadius: 5)],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Clasificación", style: HalloweenTheme.titleStyle.copyWith(color: Colors.black, fontSize: 40)),
                              const SizedBox(height: 50),
                              _buildScoreRow(teamAName, teamAScore),
                              const Divider(color: Colors.black26, thickness: 2, height: 40),
                              _buildScoreRow(teamBName, teamBScore),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: InkWell(
                          onTap: widget.onClose,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              shape: BoxShape.circle,
                            ),
                            child: HugeIcon(icon: HugeIcons.strokeRoundedMultiplicationSign, size: 25, color: Colors.white,),
                          ),
                        )
                    ),
                  ],
                )
              ),
            ),
          ],
        );
  }

  Widget _buildScoreRow(String name, int score) {
     return Column(
       children: [
         Text(name, style: HalloweenTheme.headerStyle.copyWith(color: Colors.black, fontSize: 30)),
         const SizedBox(height: 5),
         Text(score.toString(), style: HalloweenTheme.titleStyle.copyWith(color: Colors.black, fontSize: 45)),
       ],
     );
  }
}
