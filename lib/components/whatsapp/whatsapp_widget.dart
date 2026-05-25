import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppWidget extends StatelessWidget {
  final String phoneNumber;

  /// Optional pre-filled message
  final String? message;

  const WhatsAppWidget({
    super.key,
    required this.phoneNumber,
    this.message,
  });

  Future<void> openWhatsApp() async {
    final String encodedMessage =
        Uri.encodeComponent(message ?? "");

    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/$phoneNumber?text=$encodedMessage",
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openWhatsApp,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xff25D366),
              Color(0xff128C7E),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.chat,
              color: Colors.white,
              size: 30,
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "Chat on WhatsApp",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Text(
                  "+$phoneNumber",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}