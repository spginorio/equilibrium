// lib/widgets/time_entry_button.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeEntryButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const TimeEntryButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(145, 45),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontFamily: GoogleFonts.quicksand().fontFamily,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
