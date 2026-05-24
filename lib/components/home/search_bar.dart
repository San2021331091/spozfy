import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spozfy/screens/search/search_screen.dart';

class SearchBarItem extends StatelessWidget {
  const SearchBarItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => const SearchScreen());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFF132235),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF00E0B8).withValues(alpha: .3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.white70),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Search match, league, team...",
                style: GoogleFonts.acme(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}