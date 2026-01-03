import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:halloween_quiz/app/theme.dart';

class SpookyBackground extends StatelessWidget {
  final Widget child;
  const SpookyBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: HalloweenTheme.backgroundGradient,
      ),
      child: SafeArea(child: child),
    );
  }
}

class SpookyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Border? border;

  const SpookyCard({
    Key? key,
    required this.child,
    this.padding,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: HalloweenTheme.cardGradient,
            borderRadius: BorderRadius.circular(20),
            border: border ?? Border.all(color: HalloweenTheme.bloodRed.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class SpookyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double width;
  final double height;

  const SpookyButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.width = double.infinity,
    this.height = 55,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: (color ?? HalloweenTheme.pumpkinOrange).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? HalloweenTheme.pumpkinOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: HalloweenTheme.buttonTextStyle.copyWith(
            color: textColor ?? HalloweenTheme.midnightBlack,
          ),
        ),
      ),
    );
  }
}

class SpookyDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onClose;
  final String? iconPath; // Optional asset icon

  const SpookyDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onClose,
    this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SpookyCard(
        border: Border.all(color: HalloweenTheme.pumpkinOrange, width: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: HalloweenTheme.headerStyle.copyWith(color: HalloweenTheme.pumpkinOrange, fontSize: 30)),
            const SizedBox(height: 20),
            if (iconPath != null) ...[
              Image.asset(iconPath!, height: 60),
              const SizedBox(height: 20),
            ],
            Text(
              content,
              textAlign: TextAlign.center,
              style: HalloweenTheme.bodyStyle,
            ),
            const SizedBox(height: 30),
            SpookyButton(
              text: "Cerrar",
              onPressed: onClose,
              color: HalloweenTheme.bloodRed,
              textColor: Colors.white,
              width: 150,
              height: 45,
            ),
          ],
        ),
      ),
    );
  }
}
