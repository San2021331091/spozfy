import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms & Conditions",
          style: GoogleFonts.acme(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Spozfy Terms & Conditions",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Last Updated: 2026\n\n"
                "By downloading or using Spozfy, you agree to comply with and be bound by the following terms and conditions. "
                "If you do not agree with any part of these terms, you should discontinue use of the application immediately.\n\n"
                "1. Use of the App\n"
                "Spozfy provides live sports updates, scores, and related content for personal and non-commercial use only. "
                "You agree not to misuse, copy, or redistribute any part of the app or its content.\n\n"
                "2. User Responsibility\n"
                "Users are responsible for how they use the information provided in the app. Spozfy is not responsible for any "
                "decisions made based on match data, scores, or statistics.\n\n"
                "3. Content Ownership\n"
                "All content, branding, and design elements are owned by Spozfy unless stated otherwise. Third-party sports data "
                "remains the property of its respective owners.\n\n"
                "4. Prohibited Activities\n"
                "You may not reverse engineer, scrape, copy, or exploit the app in any unauthorized manner.\n\n"
                "5. Changes to Terms\n"
                "Spozfy reserves the right to update these terms at any time without prior notice.\n\n"
                "6. Contact\n"
                "For questions regarding these terms, contact the Spozfy support team.",
                style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}