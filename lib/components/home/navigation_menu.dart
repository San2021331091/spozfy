import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spozfy/components/navigation_item/navigation_item.dart';
import 'package:spozfy/screens/copyright/copyright_screen.dart';
import 'package:spozfy/screens/network_stream/network_stream_screen.dart';
import 'package:spozfy/screens/playlist/playlist_screen.dart';
import 'package:spozfy/screens/privacy/privacy_screen.dart';
import 'package:spozfy/screens/terms/terms_condition_screen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0B1220),
      child: SafeArea(
        child: Column(
          children: [
            // 🔴 HEADER
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F1A2B),
                    Color(0xFF0B1220),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      "assets/icon.png",
                      width: 110,
                      height: 110,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Spozfy SD TV",
                    style: GoogleFonts.acme(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // MENU ITEMS
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  item(
                      icon: Icons.stream,
                      title: "Network Stream",
                      ontap: () {
                        Get.to(() => const NetworkStreamScreen());
                      }),
                  item(
                      icon: Icons.playlist_play,
                      title: "Playlists",
                      ontap: () {
                        Get.to(() => const PlaylistScreen());
                      }),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white12),
                  item(
                      icon: Icons.rule,
                      title: "Terms & Security",
                      ontap: () {
                        Get.to(() => const TermsAndConditionsScreen());
                      }),
                  item(
                      icon: Icons.security,
                      title: "Privacy",
                      ontap: () {
                        Get.to(() => const PrivacyPolicyScreen());
                      }),
                  item(
                      icon: Icons.copyright,
                      title: "Copyright",
                      ontap: () {
                        Get.to(() => const CopyrightScreen());
                      }),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white12),
                  item(icon: Icons.telegram, title: "Telegram"),
                  item(icon: Icons.phone, title: "Contact"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
