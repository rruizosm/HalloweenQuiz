import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class Classification extends StatefulWidget {
  const Classification({super.key});

  @override
  State<Classification> createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
  bool isTapped = true;
  @override
  Widget build(BuildContext context) {
    return  HugeIcon(icon: HugeIcons.strokeRoundedAward01, color: Colors.yellow, size: 35, );
  }
}