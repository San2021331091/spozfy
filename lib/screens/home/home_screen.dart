import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spozfy/components/home/filter_bar.dart';
import 'package:spozfy/components/home/match_list.dart';
import 'package:spozfy/components/home/navigation_menu.dart';
import 'package:spozfy/components/home/top_bar.dart';
import 'package:spozfy/components/home/search_bar.dart';
import 'package:spozfy/services/cricket_service.dart';
import 'package:spozfy/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await _requestPermission();   
      await _loadNotifications();
    });
  }

  // ================= PERMISSION =================
  Future<void> _requestPermission() async {
    final android = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await android?.requestNotificationsPermission();
  }

  // ================= LOAD NOTIFICATIONS =================
  Future<void> _loadNotifications() async {
    try {
      final matches = await CricketService().getRecentMatches();

      if (matches.isNotEmpty) {
        await NotificationService.showLatestThree(matches);
      }
    } catch (e) {
      debugPrint("Notification error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(scaffoldKey: scaffoldKey),
              const SizedBox(height: 20),
              const SearchBarItem(),
              const SizedBox(height: 18),

              Text(
                "Cricket Match",
                style: GoogleFonts.aBeeZee(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 22),
              FilterBar(),
              const SizedBox(height: 20),

              Expanded(child: MatchList()),
            ],
          ),
        ),
      ),
      drawer: const NavigationMenu(),
    );
  }
}