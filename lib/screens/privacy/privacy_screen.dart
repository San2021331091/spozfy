import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
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
                "Spozfy Privacy Policy",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Last Updated: 2026\n\n"
                "Spozfy respects your privacy and is committed to protecting any personal information you may provide while using the app.\n\n"
                "1. Information We Collect\n"
                "We may collect basic device information, usage data, and analytics to improve app performance and user experience. "
                "We do not collect sensitive personal data unless explicitly provided by the user.\n\n"
                "2. How We Use Information\n"
                "Collected data is used to improve app functionality, fix bugs, and enhance sports content delivery.\n\n"
                "3. Data Sharing\n"
                "Spozfy does not sell or trade user data. Limited data may be shared with trusted analytics services to improve performance.\n\n"
                "4. Third-Party Services\n"
                "The app may use third-party APIs for sports data. These services may have their own privacy policies.\n\n"
                "5. Security\n"
                "We take reasonable measures to protect user data, but no system is 100% secure.\n\n"
                "6. Changes to Policy\n"
                "We may update this privacy policy periodically. Users are encouraged to review it regularly.\n\n"
                "7. Contact Us\n"
                "If you have any questions about this Privacy Policy, contact the Spozfy support team.",
                style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}