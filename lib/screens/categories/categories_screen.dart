import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      "International",
      "T20 League",
      "Highlights",
      "Live Streaming",
      "Upcoming Matches",
    ];

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2433),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            categories[index],
            style: GoogleFonts.aBeeZee(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}