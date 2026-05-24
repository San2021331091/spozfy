import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spozfy/screens/notification/notification_screen.dart';
import 'package:spozfy/screens/search/search_screen.dart';

class TopBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const TopBar({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  bool isStarred = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _TopIcon(
              icon: Icons.menu,
              onTap: () {
                widget.scaffoldKey.currentState?.openDrawer();
              },
            ),
            const SizedBox(width: 12),
            Text(
              "Spozfy",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),

        // RIGHT SIDE
        Row(
          children: [
            _TopIcon(
              icon: isStarred ? Icons.star : Icons.star_border,
              color: isStarred ? Colors.amber : Colors.white,
              onTap: () {
                setState(() {
                  isStarred = !isStarred;
                });
              },
            ),

            const SizedBox(width: 10),

            // 🔔 NOTIFICATION WITH BADGE
            Stack(
              clipBehavior: Clip.none,
              children: [
                _TopIcon(
                  icon: Icons.notifications,
                  onTap: () {
                    Get.to(() => const NotificationScreen());
                  },
                ),

                // 🔴 BADGE (static = 5)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      "5",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 10),

            _TopIcon(
              icon: Icons.search,
              onTap: () {
                Get.to(() => const SearchScreen());
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _TopIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  const _TopIcon({
    required this.icon,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF132235),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: color ?? Colors.white,
        ),
      ),
    );
  }
}