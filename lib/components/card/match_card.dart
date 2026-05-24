import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spozfy/components/animation/marquee_text.dart';
import 'package:intl/intl.dart';

class MatchCard extends StatelessWidget {
  final String league;
  final String team1;
  final String team2;
  final String time;
  final String status;
  final IconData icon1;
  final IconData icon2;

  const MatchCard({
    super.key,
    required this.league,
    required this.team1,
    required this.team2,
    required this.time,
    required this.status,
    required this.icon1,
    required this.icon2,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('hh:mm a').format(DateTime.parse(time));
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2235), Color(0xFF172C44)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF00E0B8).withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ================= TOP SECTION =================
          Row(
            children: [
              const Icon(Icons.emoji_events,
                  color: Color(0xFF00E0B8), size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  league,
                  style: GoogleFonts.roboto(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ================= STATUS =================
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: 18,
                child: ClipRect(
                  // 🔥 IMPORTANT
                  child: MarqueeText(
                    text: status,
                    style: GoogleFonts.poppins(
                      color: status.toLowerCase().contains("live")
                          ? Colors.redAccent
                          : Colors.white60,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // ================= MATCH ROW =================
          Row(
            children: [
              Expanded(child: _team(icon1, team1)),
              SizedBox(
                width: 70,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formattedTime,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.aBeeZee(
                        color: Color(0xFF00E0B8),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "VS",
                      style: GoogleFonts.acme(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _team(icon2, team2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _team(IconData icon, String name) {
    const int maxLengthForStatic = 10;

    final bool shouldAnimate = name.length > maxLengthForStatic;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF08131F),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF00E0B8).withValues(alpha: 0.35),
            ),
          ),
          child: Icon(icon, color: const Color(0xFF00E0B8), size: 22),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 18,
          width: double.infinity,
          child: ClipRect(
            child: shouldAnimate
                ? MarqueeText(
                    text: name,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
