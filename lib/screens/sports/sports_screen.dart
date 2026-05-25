import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SportsScreen extends StatelessWidget {
  const SportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      children: const [
        SportCard(
          icon: Icons.sports_cricket,
          title: "Cricket",
        ),
        SportCard(
          icon: Icons.sports_soccer,
          title: "Football",
        ),
        SportCard(
          icon: Icons.sports_basketball,
          title: "Basketball",
        ),
        SportCard(
          icon: Icons.sports_tennis,
          title: "Tennis",
        ),
      ],
    );
  }
}

class SportCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const SportCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B2433),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 45,
            color: Colors.tealAccent,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: GoogleFonts.aBeeZee(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}