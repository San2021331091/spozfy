import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spozfy/components/home/filter_bar.dart';
import 'package:spozfy/components/home/match_list.dart';

class LiveEventsScreen extends StatelessWidget {
  const LiveEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cricket Match",
          style: GoogleFonts.aBeeZee(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 22),

        FilterBar(),

        const SizedBox(height: 20),
        Expanded(
          child: MatchList(),
        ),
      ],
    );
  }
}