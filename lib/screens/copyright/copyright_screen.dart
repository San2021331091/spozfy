import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CopyrightScreen extends StatelessWidget {
  const CopyrightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Copyright & Legal",style: GoogleFonts.acme(fontSize: 20,),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text(
                "Spozfy, Live Sports App",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),

              Text(
                "Copyright Notice",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

              Text(
                "© 2026 Spozfy. All rights reserved.\n\n"
                "Spozfy is a live sports streaming and updates application designed to deliver "
                "real-time scores, match updates, highlights, and sports-related content to users "
                "around the world. All content, including but not limited to text, graphics, logos, "
                "icons, images, audio clips, digital downloads, data compilations, and software, "
                "is the property of Spozfy or its content suppliers and is protected by international "
                "copyright laws.\n\n"
                "Unauthorized reproduction, distribution, modification, transmission, display, or "
                "performance of any content from this application is strictly prohibited unless "
                "explicit written permission is obtained from Spozfy.\n\n"
                "All trademarks, service marks, and trade names displayed in the app are the property "
                "of their respective owners. Any use of third-party sports data, team names, league "
                "information, or match statistics is for informational and entertainment purposes only.\n\n"
                "Spozfy does not claim ownership of external sports data sources and respects all "
                "broadcasting and data rights held by official sports organizations and partners.\n\n"
                "By using this application, users agree not to copy, scrape, redistribute, or exploit "
                "any part of the service for commercial purposes without authorization.\n\n"
                "For permissions, partnerships, or copyright-related inquiries, please contact the "
                "Spozfy development team through official support channels.",
                style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
              ),

              SizedBox(height: 20),

              Text(
                "Disclaimer",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

              Text(
                "Spozfy provides sports information and live updates for general informational purposes only. "
                "While we strive for accuracy, we do not guarantee that all scores, statistics, or match "
                "details are always up to date or error-free. Users should verify critical information "
                "from official sources when necessary.",
                style: GoogleFonts.roboto(fontSize: 14, height: 1.5),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}